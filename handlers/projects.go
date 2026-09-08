package handlers

import (
	"context"
	"database/sql"
	"strconv"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
)

type propertyProjectResponse struct {
	PublicProjectID        string   `json:"public_project_id"`
	Slug                   string   `json:"slug"`
	ProjectCategory        string   `json:"project_category"`
	NameTH                 string   `json:"name_th"`
	NameEN                 string   `json:"name_en"`
	Aliases                []string `json:"aliases"`
	DeveloperNameTH        string   `json:"developer_name_th"`
	DeveloperNameEN        string   `json:"developer_name_en"`
	SupportedPropertyTypes []string `json:"supported_property_types"`
	DescriptionTH          string   `json:"description_th"`
	DescriptionEN          string   `json:"description_en"`
	Subdistrict            string   `json:"subdistrict"`
	District               string   `json:"district"`
	Province               string   `json:"province"`
	PostalCode             string   `json:"postal_code"`
	Latitude               *float64 `json:"latitude,omitempty"`
	Longitude              *float64 `json:"longitude,omitempty"`
	OfficialWebsiteURL     string   `json:"official_website_url"`
	SourceURL              string   `json:"source_url"`
	VerificationStatus     string   `json:"verification_status"`
	AmenityCodes           []string `json:"amenity_codes"`
	ListingCount           int      `json:"listing_count"`
}

var allowedProjectCategories = map[string]bool{
	"housing_estate":     true,
	"condominium":        true,
	"mixed_use":          true,
	"commercial_complex": true,
	"office_campus":      true,
	"industrial_estate":  true,
	"other":              true,
}

func ListPropertyProjects(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		query := strings.TrimSpace(c.Query("q"))
		category := strings.TrimSpace(c.Query("category"))
		if category != "" && !allowedProjectCategories[category] {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid project category"})
		}

		limit, _ := strconv.Atoi(c.Query("limit", "12"))
		if limit < 1 || limit > 50 {
			limit = 12
		}

		ctx, cancel := context.WithTimeout(c.Context(), 5*time.Second)
		defer cancel()

		rows, err := db.QueryContext(ctx, `
			SELECT
				p.public_project_id::text,
				p.slug,
				p.project_category,
				p.name_th,
				COALESCE(p.name_en, ''),
				COALESCE(alias_set.aliases, ARRAY[]::text[]),
				COALESCE(p.developer_name_th, ''),
				COALESCE(p.developer_name_en, ''),
				p.supported_property_types,
				COALESCE(p.description_th, ''),
				COALESCE(p.description_en, ''),
				COALESCE(p.subdistrict_name, ''),
				COALESCE(p.district_name, ''),
				COALESCE(p.province_name, ''),
				COALESCE(p.postal_code, ''),
				p.latitude,
				p.longitude,
				COALESCE(p.official_website_url, ''),
				COALESCE(p.source_url, ''),
				p.verification_status,
				COALESCE(amenity_set.amenity_codes, ARRAY[]::text[]),
				COALESCE(listing_set.listing_count, 0)
			FROM public.property_projects p
			LEFT JOIN LATERAL (
				SELECT array_agg(alias_name ORDER BY
					CASE alias_type WHEN 'official' THEN 0 ELSE 1 END,
					CASE locale WHEN 'th' THEN 0 WHEN 'en' THEN 1 ELSE 2 END,
					alias_name
				) AS aliases
				FROM public.property_project_aliases
				WHERE project_id = p.id AND is_searchable = true
			) alias_set ON true
			LEFT JOIN LATERAL (
				SELECT array_agg(amenity_code ORDER BY amenity_code) AS amenity_codes
				FROM public.property_project_amenities
				WHERE project_id = p.id
			) amenity_set ON true
			LEFT JOIN LATERAL (
				SELECT count(*)::integer AS listing_count
				FROM public.listings listing
				WHERE listing.project_id = p.id
				  AND listing.published_at IS NOT NULL
				  AND listing.deleted_at IS NULL
				  AND listing.is_active = true
				  AND listing.listing_status = 'active'
				  AND listing.moderation_status = 'approved'
				  AND (listing.expires_at IS NULL OR listing.expires_at > now())
			) listing_set ON true
			WHERE p.is_active = true
			  AND p.deleted_at IS NULL
			  AND ($1 = '' OR
				p.search_text ILIKE '%' || lower($1) || '%' OR
				public.normalize_project_search_name(p.name_th) LIKE '%' || public.normalize_project_search_name($1) || '%' OR
				public.normalize_project_search_name(COALESCE(p.name_en, '')) LIKE '%' || public.normalize_project_search_name($1) || '%' OR
				EXISTS (
					SELECT 1 FROM public.property_project_aliases alias
					WHERE alias.project_id = p.id
					  AND alias.is_searchable = true
					  AND (
						lower(alias.alias_name) ILIKE '%' || lower($1) || '%' OR
						alias.normalized_alias LIKE '%' || public.normalize_project_search_name($1) || '%'
					  )
				)
			  )
			  AND ($2 = '' OR p.project_category = $2)
			ORDER BY
				CASE
					WHEN public.normalize_project_search_name(p.name_th) = public.normalize_project_search_name($1) THEN 0
					WHEN public.normalize_project_search_name(COALESCE(p.name_en, '')) = public.normalize_project_search_name($1) THEN 0
					WHEN EXISTS (
						SELECT 1 FROM public.property_project_aliases exact_alias
						WHERE exact_alias.project_id = p.id
						  AND exact_alias.normalized_alias = public.normalize_project_search_name($1)
					) THEN 0
					ELSE 1
				END,
				COALESCE(listing_set.listing_count, 0) DESC,
				p.name_th
			LIMIT $3
		`, query, category, limit)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot list projects"})
		}
		defer rows.Close()

		projects := make([]propertyProjectResponse, 0, limit)
		for rows.Next() {
			project, err := scanPropertyProject(rows)
			if err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read projects"})
			}
			projects = append(projects, project)
		}
		if err := rows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read projects"})
		}

		return c.JSON(fiber.Map{"projects": projects})
	}
}

func GetPropertyProject(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		identifier := strings.TrimSpace(c.Params("identifier"))
		if identifier == "" || len(identifier) > 180 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid project identifier"})
		}

		ctx, cancel := context.WithTimeout(c.Context(), 5*time.Second)
		defer cancel()

		row := db.QueryRowContext(ctx, `
			SELECT
				p.public_project_id::text,
				p.slug,
				p.project_category,
				p.name_th,
				COALESCE(p.name_en, ''),
				COALESCE(alias_set.aliases, ARRAY[]::text[]),
				COALESCE(p.developer_name_th, ''),
				COALESCE(p.developer_name_en, ''),
				p.supported_property_types,
				COALESCE(p.description_th, ''),
				COALESCE(p.description_en, ''),
				COALESCE(p.subdistrict_name, ''),
				COALESCE(p.district_name, ''),
				COALESCE(p.province_name, ''),
				COALESCE(p.postal_code, ''),
				p.latitude,
				p.longitude,
				COALESCE(p.official_website_url, ''),
				COALESCE(p.source_url, ''),
				p.verification_status,
				COALESCE(amenity_set.amenity_codes, ARRAY[]::text[]),
				COALESCE(listing_set.listing_count, 0)
			FROM public.property_projects p
			LEFT JOIN LATERAL (
				SELECT array_agg(alias_name ORDER BY
					CASE alias_type WHEN 'official' THEN 0 ELSE 1 END,
					CASE locale WHEN 'th' THEN 0 WHEN 'en' THEN 1 ELSE 2 END,
					alias_name
				) AS aliases
				FROM public.property_project_aliases
				WHERE project_id = p.id AND is_searchable = true
			) alias_set ON true
			LEFT JOIN LATERAL (
				SELECT array_agg(amenity_code ORDER BY amenity_code) AS amenity_codes
				FROM public.property_project_amenities
				WHERE project_id = p.id
			) amenity_set ON true
			LEFT JOIN LATERAL (
				SELECT count(*)::integer AS listing_count
				FROM public.listings listing
				WHERE listing.project_id = p.id
				  AND listing.published_at IS NOT NULL
				  AND listing.deleted_at IS NULL
				  AND listing.is_active = true
				  AND listing.listing_status = 'active'
				  AND listing.moderation_status = 'approved'
				  AND (listing.expires_at IS NULL OR listing.expires_at > now())
			) listing_set ON true
			WHERE (p.public_project_id::text = $1 OR p.slug = $1)
			  AND p.is_active = true
			  AND p.deleted_at IS NULL
			LIMIT 1
		`, identifier)

		project, err := scanPropertyProject(row)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "project not found"})
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read project"})
		}
		return c.JSON(fiber.Map{"project": project})
	}
}

type projectScanner interface {
	Scan(dest ...any) error
}

func scanPropertyProject(scanner projectScanner) (propertyProjectResponse, error) {
	var project propertyProjectResponse
	var latitude, longitude sql.NullFloat64
	err := scanner.Scan(
		&project.PublicProjectID,
		&project.Slug,
		&project.ProjectCategory,
		&project.NameTH,
		&project.NameEN,
		pq.Array(&project.Aliases),
		&project.DeveloperNameTH,
		&project.DeveloperNameEN,
		pq.Array(&project.SupportedPropertyTypes),
		&project.DescriptionTH,
		&project.DescriptionEN,
		&project.Subdistrict,
		&project.District,
		&project.Province,
		&project.PostalCode,
		&latitude,
		&longitude,
		&project.OfficialWebsiteURL,
		&project.SourceURL,
		&project.VerificationStatus,
		pq.Array(&project.AmenityCodes),
		&project.ListingCount,
	)
	if err != nil {
		return propertyProjectResponse{}, err
	}
	if latitude.Valid {
		project.Latitude = &latitude.Float64
	}
	if longitude.Valid {
		project.Longitude = &longitude.Float64
	}
	if project.Aliases == nil {
		project.Aliases = []string{}
	}
	if project.SupportedPropertyTypes == nil {
		project.SupportedPropertyTypes = []string{}
	}
	if project.AmenityCodes == nil {
		project.AmenityCodes = []string{}
	}
	return project, nil
}
