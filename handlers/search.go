package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"
	"unicode"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
)

type searchAlias struct {
	Phrase      string
	IntentType  string
	IntentValue string
	Locale      string
	Priority    int
}

type searchLocation struct {
	ID       int64    `json:"id"`
	Code     string   `json:"code"`
	NameTH   string   `json:"name_th"`
	NameEN   string   `json:"name_en"`
	Type     string   `json:"type"`
	Aliases  []string `json:"-"`
	Priority int      `json:"-"`
}

type searchChip struct {
	Type  string `json:"type"`
	Value string `json:"value"`
	Label string `json:"label"`
}

type searchIntent struct {
	Query          string           `json:"query"`
	Normalized     string           `json:"normalized_query"`
	Locale         string           `json:"locale"`
	PropertyTypes  []string         `json:"property_types"`
	PropertyGroups []string         `json:"property_groups"`
	UseCases       []string         `json:"use_cases"`
	OfferTypes     []string         `json:"offer_types"`
	Features       []string         `json:"features"`
	Locations      []searchLocation `json:"locations"`
	MinPrice       *float64         `json:"min_price,omitempty"`
	MaxPrice       *float64         `json:"max_price,omitempty"`
	Bedrooms       *int             `json:"bedrooms,omitempty"`
	FreeText       string           `json:"free_text,omitempty"`
	Confidence     float64          `json:"confidence"`
	Chips          []searchChip     `json:"chips"`
}

type searchListing struct {
	ID               int64      `json:"id"`
	PublicListingID  string     `json:"public_listing_id"`
	Slug             string     `json:"slug"`
	Title            string     `json:"title"`
	Description      string     `json:"description"`
	PropertyTypeCode string     `json:"property_type_code"`
	ListingType      string     `json:"listing_type"`
	ProjectName      string     `json:"project_name"`
	Address          string     `json:"address"`
	Province         string     `json:"province"`
	District         string     `json:"district"`
	SalePrice        *float64   `json:"sale_price,omitempty"`
	RentPriceMonthly *float64   `json:"rent_price_monthly,omitempty"`
	BedroomCount     *int       `json:"bedroom_count,omitempty"`
	BathroomCount    *int       `json:"bathroom_count,omitempty"`
	UsableAreaSqm    *float64   `json:"usable_area_sqm,omitempty"`
	PetAllowed       bool       `json:"pet_allowed"`
	Latitude         *float64   `json:"latitude,omitempty"`
	Longitude        *float64   `json:"longitude,omitempty"`
	PublishedAt      *time.Time `json:"published_at,omitempty"`
}

var (
	spacePattern      = regexp.MustCompile(`\s+`)
	priceRangePattern = regexp.MustCompile(`(?i)([0-9]+(?:\.[0-9]+)?)\s*(?:-|–|—|ถึง|to)\s*([0-9]+(?:\.[0-9]+)?)\s*(ล้าน|แสน|หมื่น|พัน|m|k)?`)
	maxPricePattern   = regexp.MustCompile(`(?i)(?:ไม่เกิน|ต่ำกว่า|งบไม่เกิน|ราคาไม่เกิน|under|max(?:imum)?)\s*([0-9]+(?:\.[0-9]+)?)\s*(ล้าน|แสน|หมื่น|พัน|m|k)?`)
	minPricePattern   = regexp.MustCompile(`(?i)(?:ตั้งแต่|มากกว่า|อย่างน้อย|ขั้นต่ำ|from|min(?:imum)?)\s*([0-9]+(?:\.[0-9]+)?)\s*(ล้าน|แสน|หมื่น|พัน|m|k)?`)
	budgetPattern     = regexp.MustCompile(`(?i)(?:งบ|ราคา)\s*([0-9]+(?:\.[0-9]+)?)\s*(ล้าน|แสน|หมื่น|พัน|m|k)?`)
	bedroomPattern    = regexp.MustCompile(`(?i)([0-9]+)\s*(?:ห้องนอน|นอน|bedrooms?|beds?)`)
)

func normalizeSearchText(value string) string {
	value = strings.ReplaceAll(value, ",", "")
	value = strings.Map(func(r rune) rune {
		switch r {
		case '๐':
			return '0'
		case '๑':
			return '1'
		case '๒':
			return '2'
		case '๓':
			return '3'
		case '๔':
			return '4'
		case '๕':
			return '5'
		case '๖':
			return '6'
		case '๗':
			return '7'
		case '๘':
			return '8'
		case '๙':
			return '9'
		}
		if unicode.IsPunct(r) && r != '-' && r != '–' && r != '—' && r != '.' {
			return ' '
		}
		return unicode.ToLower(r)
	}, strings.TrimSpace(value))
	return spacePattern.ReplaceAllString(value, " ")
}

func searchLocale(value string) string {
	for _, r := range value {
		if r >= '\u0E00' && r <= '\u0E7F' {
			return "th"
		}
	}
	return "en"
}

func parseScaledAmount(number, unit string) (float64, bool) {
	value, err := strconv.ParseFloat(number, 64)
	if err != nil {
		return 0, false
	}
	switch strings.ToLower(unit) {
	case "ล้าน", "m":
		value *= 1_000_000
	case "แสน":
		value *= 100_000
	case "หมื่น":
		value *= 10_000
	case "พัน", "k":
		value *= 1_000
	}
	return value, true
}

func appendUnique(items []string, value string) []string {
	for _, item := range items {
		if item == value {
			return items
		}
	}
	return append(items, value)
}

func loadSearchAliases(ctx context.Context, db *sql.DB) ([]searchAlias, error) {
	rows, err := db.QueryContext(ctx, `SELECT phrase, intent_type, intent_value, locale, priority
		FROM public.search_aliases WHERE is_active = true
		ORDER BY length(normalized_phrase) DESC, priority DESC`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	aliases := make([]searchAlias, 0, 64)
	for rows.Next() {
		var alias searchAlias
		if err := rows.Scan(&alias.Phrase, &alias.IntentType, &alias.IntentValue, &alias.Locale, &alias.Priority); err != nil {
			return nil, err
		}
		aliases = append(aliases, alias)
	}
	return aliases, rows.Err()
}

func loadSearchLocations(ctx context.Context, db *sql.DB) ([]searchLocation, error) {
	rows, err := db.QueryContext(ctx, `SELECT id, code, name_th, name_en, location_type, aliases, priority
		FROM public.search_locations WHERE is_active = true
		ORDER BY priority DESC, length(name_th) DESC`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	locations := make([]searchLocation, 0, 32)
	for rows.Next() {
		var location searchLocation
		if err := rows.Scan(&location.ID, &location.Code, &location.NameTH, &location.NameEN, &location.Type, pq.Array(&location.Aliases), &location.Priority); err != nil {
			return nil, err
		}
		locations = append(locations, location)
	}
	return locations, rows.Err()
}

func interpretSearch(query string, aliases []searchAlias, locations []searchLocation) searchIntent {
	normalized := normalizeSearchText(query)
	intent := searchIntent{Query: strings.TrimSpace(query), Normalized: normalized, Locale: searchLocale(query), Confidence: 0.15}
	remaining := normalized

	for _, alias := range aliases {
		phrase := normalizeSearchText(alias.Phrase)
		if phrase == "" || !strings.Contains(remaining, phrase) {
			continue
		}
		switch alias.IntentType {
		case "property_type":
			intent.PropertyTypes = appendUnique(intent.PropertyTypes, alias.IntentValue)
		case "property_group":
			intent.PropertyGroups = appendUnique(intent.PropertyGroups, alias.IntentValue)
		case "use_case":
			intent.UseCases = appendUnique(intent.UseCases, alias.IntentValue)
		case "offer_type":
			intent.OfferTypes = appendUnique(intent.OfferTypes, alias.IntentValue)
		case "feature":
			intent.Features = appendUnique(intent.Features, alias.IntentValue)
		}
		remaining = strings.ReplaceAll(remaining, phrase, " ")
	}

	for _, location := range locations {
		terms := append([]string{location.NameTH, location.NameEN}, location.Aliases...)
		matched := ""
		for _, term := range terms {
			term = normalizeSearchText(term)
			if term != "" && strings.Contains(remaining, term) && len(term) > len(matched) {
				matched = term
			}
		}
		if matched == "" {
			continue
		}
		intent.Locations = append(intent.Locations, location)
		remaining = strings.ReplaceAll(remaining, matched, " ")
		break
	}

	if match := priceRangePattern.FindStringSubmatch(normalized); len(match) > 0 {
		unit := match[3]
		if min, ok := parseScaledAmount(match[1], unit); ok {
			intent.MinPrice = &min
		}
		if max, ok := parseScaledAmount(match[2], unit); ok {
			intent.MaxPrice = &max
		}
		remaining = strings.ReplaceAll(remaining, match[0], " ")
	} else {
		if match := maxPricePattern.FindStringSubmatch(normalized); len(match) > 0 {
			if value, ok := parseScaledAmount(match[1], match[2]); ok {
				intent.MaxPrice = &value
			}
			remaining = strings.ReplaceAll(remaining, match[0], " ")
		}
		if match := minPricePattern.FindStringSubmatch(normalized); len(match) > 0 {
			if value, ok := parseScaledAmount(match[1], match[2]); ok {
				intent.MinPrice = &value
			}
			remaining = strings.ReplaceAll(remaining, match[0], " ")
		}
		if intent.MinPrice == nil && intent.MaxPrice == nil {
			if match := budgetPattern.FindStringSubmatch(normalized); len(match) > 0 {
				if value, ok := parseScaledAmount(match[1], match[2]); ok {
					intent.MaxPrice = &value
				}
				remaining = strings.ReplaceAll(remaining, match[0], " ")
			}
		}
	}
	if match := bedroomPattern.FindStringSubmatch(normalized); len(match) > 0 {
		if value, err := strconv.Atoi(match[1]); err == nil {
			intent.Bedrooms = &value
		}
		remaining = strings.ReplaceAll(remaining, match[0], " ")
	}

	for _, stopWord := range []string{"อยากหา", "กำลังหา", "ค้นหา", "ต้องการ", "หา", "แถว", "ย่าน", "ใน", "ที่", "หน่อย", "ครับ", "ค่ะ"} {
		remaining = strings.ReplaceAll(remaining, stopWord, " ")
	}
	intent.FreeText = strings.TrimSpace(spacePattern.ReplaceAllString(remaining, " "))

	understood := len(intent.PropertyTypes) + len(intent.PropertyGroups) + len(intent.UseCases) + len(intent.OfferTypes) + len(intent.Features) + len(intent.Locations)
	if intent.MinPrice != nil || intent.MaxPrice != nil {
		understood++
	}
	if intent.Bedrooms != nil {
		understood++
	}
	intent.Confidence = float64(understood) * 0.18
	if intent.FreeText != "" {
		intent.Confidence += 0.12
	}
	if intent.Confidence > 0.98 {
		intent.Confidence = 0.98
	}
	intent.Chips = buildSearchChips(intent, aliases)
	return intent
}

func buildSearchChips(intent searchIntent, aliases []searchAlias) []searchChip {
	labels := map[string]string{}
	labelPriorities := map[string]int{}
	collectLabels := func(localeOnly bool) {
		for _, alias := range aliases {
			if localeOnly && alias.Locale != intent.Locale {
				continue
			}
			key := alias.IntentType + ":" + alias.IntentValue
			if !localeOnly && labels[key] != "" {
				continue
			}
			if labels[key] != "" && labelPriorities[key] > alias.Priority {
				continue
			}
			if labels[key] == "" || alias.Priority > labelPriorities[key] || len([]rune(alias.Phrase)) < len([]rune(labels[key])) {
				labels[key] = alias.Phrase
				labelPriorities[key] = alias.Priority
			}
		}
	}
	collectLabels(true)
	collectLabels(false)
	chips := make([]searchChip, 0, 8)
	appendValues := func(kind string, values []string) {
		for _, value := range values {
			label := labels[kind+":"+value]
			if label == "" {
				label = value
			}
			chips = append(chips, searchChip{Type: kind, Value: value, Label: label})
		}
	}
	appendValues("property_type", intent.PropertyTypes)
	appendValues("property_group", intent.PropertyGroups)
	appendValues("use_case", intent.UseCases)
	appendValues("offer_type", intent.OfferTypes)
	for _, location := range intent.Locations {
		label := location.NameTH
		if intent.Locale == "en" {
			label = location.NameEN
		}
		chips = append(chips, searchChip{Type: "location", Value: location.Code, Label: label})
	}
	if intent.MinPrice != nil || intent.MaxPrice != nil {
		label := budgetChipLabel(intent)
		chips = append(chips, searchChip{Type: "price", Value: label, Label: label})
	}
	if intent.Bedrooms != nil {
		label := fmt.Sprintf("%d ห้องนอน", *intent.Bedrooms)
		if intent.Locale == "en" {
			label = fmt.Sprintf("%d bedrooms", *intent.Bedrooms)
		}
		chips = append(chips, searchChip{Type: "bedrooms", Value: strconv.Itoa(*intent.Bedrooms), Label: label})
	}
	return chips
}

func budgetChipLabel(intent searchIntent) string {
	if intent.Locale == "en" {
		label := "Selected budget"
		if intent.MaxPrice != nil {
			label = "Up to ฿" + formatNumber(*intent.MaxPrice)
		}
		if intent.MinPrice != nil && intent.MaxPrice != nil {
			label = "฿" + formatNumber(*intent.MinPrice) + "–฿" + formatNumber(*intent.MaxPrice)
		} else if intent.MinPrice != nil {
			label = "From ฿" + formatNumber(*intent.MinPrice)
		}
		return label
	}

	label := "ตามงบที่ระบุ"
	if intent.MaxPrice != nil {
		label = "ไม่เกิน " + compactTHB(*intent.MaxPrice)
	}
	if intent.MinPrice != nil && intent.MaxPrice != nil {
		label = compactTHB(*intent.MinPrice) + "–" + compactTHB(*intent.MaxPrice)
	} else if intent.MinPrice != nil {
		label = "ตั้งแต่ " + compactTHB(*intent.MinPrice)
	}
	return label
}

func compactTHB(value float64) string {
	if value >= 1_000_000 {
		return strconv.FormatFloat(value/1_000_000, 'f', -1, 64) + " ล้านบาท"
	}
	return formatNumber(value) + " บาท"
}

func formatNumber(value float64) string {
	raw := strconv.FormatFloat(value, 'f', -1, 64)
	parts := strings.SplitN(raw, ".", 2)
	integer := parts[0]
	for i := len(integer) - 3; i > 0; i -= 3 {
		integer = integer[:i] + "," + integer[i:]
	}
	if len(parts) == 2 {
		return integer + "." + parts[1]
	}
	return integer
}

func parseIntentFromDB(ctx context.Context, db *sql.DB, query string) (searchIntent, error) {
	aliases, err := loadSearchAliases(ctx, db)
	if err != nil {
		return searchIntent{}, err
	}
	locations, err := loadSearchLocations(ctx, db)
	if err != nil {
		return searchIntent{}, err
	}
	return interpretSearch(query, aliases, locations), nil
}

func InterpretPropertySearch(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		query := strings.TrimSpace(c.Query("q"))
		if query == "" {
			return c.Status(400).JSON(fiber.Map{"error": "q is required"})
		}
		ctx, cancel := context.WithTimeout(c.Context(), 3*time.Second)
		defer cancel()
		intent, err := parseIntentFromDB(ctx, db, query)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot interpret search"})
		}
		return c.JSON(fiber.Map{"intent": intent})
	}
}

func PropertySearchSuggestions(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		query := normalizeSearchText(c.Query("q"))
		limit, _ := strconv.Atoi(c.Query("limit", "8"))
		if limit < 1 || limit > 12 {
			limit = 8
		}
		ctx, cancel := context.WithTimeout(c.Context(), 3*time.Second)
		defer cancel()
		type suggestion struct {
			Type        string `json:"type"`
			Label       string `json:"label"`
			Description string `json:"description"`
			Query       string `json:"query"`
		}
		result := make([]suggestion, 0, limit)
		if query == "" {
			return c.JSON(fiber.Map{"suggestions": []suggestion{
				{Type: "popular", Label: "คอนโดอารีย์", Description: "คอนโด · อารีย์", Query: "คอนโดอารีย์"},
				{Type: "popular", Label: "โกดังบางนา", Description: "โกดัง · บางนา", Query: "โกดังบางนา"},
				{Type: "popular", Label: "ที่ดินเชียงใหม่", Description: "ที่ดิน · เชียงใหม่", Query: "ที่ดินเชียงใหม่"},
				{Type: "popular", Label: "ร้านให้เช่าสยามไม่เกิน 50,000", Description: "ร้านค้า · เช่า · สยาม", Query: "ร้านให้เช่าสยามไม่เกิน 50000"},
			}})
		}
		rows, err := db.QueryContext(ctx, `
			SELECT kind, label, description, suggested_query FROM (
				SELECT 'location' AS kind, name_th AS label, location_type AS description,
					name_th AS suggested_query, priority,
					greatest(similarity(lower(name_th), $1), similarity(lower(name_en), $1)) AS score
				FROM public.search_locations
			WHERE is_active AND (lower(name_th) ILIKE '%' || $1 || '%' OR lower(name_en) ILIKE '%' || $1 || '%' OR EXISTS (
				SELECT 1 FROM unnest(aliases) alias WHERE lower(alias) ILIKE '%' || $1 || '%'
			))
				UNION ALL
				SELECT intent_type, phrase, intent_value, phrase, priority,
					similarity(normalized_phrase, $1)
				FROM public.search_aliases
				WHERE is_active AND normalized_phrase ILIKE '%' || $1 || '%'
			) s ORDER BY score DESC, priority DESC LIMIT $2`, query, limit)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot load suggestions"})
		}
		defer rows.Close()
		for rows.Next() {
			var item suggestion
			if err := rows.Scan(&item.Type, &item.Label, &item.Description, &item.Query); err != nil {
				return c.Status(500).JSON(fiber.Map{"error": "cannot read suggestions"})
			}
			result = append(result, item)
		}
		return c.JSON(fiber.Map{"suggestions": result})
	}
}

func SearchProperties(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		query := strings.TrimSpace(c.Query("q"))
		if query == "" {
			return c.Status(400).JSON(fiber.Map{"error": "q is required"})
		}
		limit, _ := strconv.Atoi(c.Query("limit", "24"))
		if limit < 1 || limit > 60 {
			limit = 24
		}
		offset, _ := strconv.Atoi(c.Query("offset", "0"))
		if offset < 0 {
			offset = 0
		}
		ctx, cancel := context.WithTimeout(c.Context(), 8*time.Second)
		defer cancel()
		intent, err := parseIntentFromDB(ctx, db, query)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot interpret search"})
		}

		where := []string{"l.published_at IS NOT NULL"}
		args := []any{}
		arg := func(value any) string { args = append(args, value); return fmt.Sprintf("$%d", len(args)) }
		if len(intent.PropertyTypes) > 0 {
			where = append(where, "l.property_type_code = ANY("+arg(pq.Array(intent.PropertyTypes))+")")
		}
		if len(intent.PropertyGroups) > 0 {
			where = append(where, "EXISTS (SELECT 1 FROM public.property_types pt WHERE pt.code=l.property_type_code AND pt.group_code = ANY("+arg(pq.Array(intent.PropertyGroups))+"))")
		}
		if len(intent.UseCases) > 0 {
			where = append(where, "EXISTS (SELECT 1 FROM public.listing_use_cases luc WHERE luc.listing_id=l.id AND luc.use_case_code = ANY("+arg(pq.Array(intent.UseCases))+"))")
		}
		if len(intent.OfferTypes) > 0 {
			where = append(where, "EXISTS (SELECT 1 FROM public.listing_offers lo WHERE lo.listing_id=l.id AND lo.offer_type = ANY("+arg(pq.Array(intent.OfferTypes))+"))")
		}
		if len(intent.Locations) > 0 {
			location := intent.Locations[0]
			terms := append([]string{location.NameTH, location.NameEN}, location.Aliases...)
			patterns := make([]string, 0, len(terms))
			for _, term := range terms {
				patterns = append(patterns, "%"+normalizeSearchText(term)+"%")
			}
			where = append(where, "(l.location_id = "+arg(location.ID)+" OR l.search_text ILIKE ANY("+arg(pq.Array(patterns))+"))")
		}
		if intent.Bedrooms != nil {
			where = append(where, "l.bedroom_count >= "+arg(*intent.Bedrooms))
		}
		for _, feature := range intent.Features {
			if feature == "pet_allowed" {
				where = append(where, "l.pet_allowed = true")
			}
		}
		if intent.MinPrice != nil || intent.MaxPrice != nil {
			parts := []string{"lo.listing_id=l.id", "lo.amount IS NOT NULL"}
			if len(intent.OfferTypes) > 0 {
				parts = append(parts, "lo.offer_type = ANY("+arg(pq.Array(intent.OfferTypes))+")")
			}
			if intent.MinPrice != nil {
				parts = append(parts, "lo.amount >= "+arg(*intent.MinPrice))
			}
			if intent.MaxPrice != nil {
				parts = append(parts, "lo.amount <= "+arg(*intent.MaxPrice))
			}
			where = append(where, "EXISTS (SELECT 1 FROM public.listing_offers lo WHERE "+strings.Join(parts, " AND ")+")")
		}
		if intent.FreeText != "" {
			where = append(where, "l.search_text ILIKE "+arg("%"+intent.FreeText+"%"))
		}

		queryArg := arg(intent.Normalized)
		limitArg := arg(limit)
		offsetArg := arg(offset)
		sqlQuery := `SELECT l.id, l.public_listing_id::text, COALESCE(l.slug,''), l.title,
			COALESCE(l.description,''), l.property_type_code, l.listing_type,
			COALESCE(l.custom_project_name,''), trim(concat_ws(' ',l.address_line1,l.address_line2)),
			COALESCE(l.province_name,''), COALESCE(l.district_name,''),
			l.sale_price, l.rent_price_monthly, l.bedroom_count, l.bathroom_count,
			l.usable_area_sqm, l.pet_allowed, l.latitude, l.longitude, l.published_at,
			count(*) OVER() AS total_count
		FROM public.listings l WHERE ` + strings.Join(where, " AND ") + `
		ORDER BY similarity(l.search_text, ` + queryArg + `) DESC, l.published_at DESC
		LIMIT ` + limitArg + ` OFFSET ` + offsetArg
		rows, err := db.QueryContext(ctx, sqlQuery, args...)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot search properties"})
		}
		defer rows.Close()
		listings := make([]searchListing, 0, limit)
		total := 0
		for rows.Next() {
			var item searchListing
			var sale, rent, area, lat, lng sql.NullFloat64
			var beds, baths sql.NullInt64
			var published sql.NullTime
			if err := rows.Scan(&item.ID, &item.PublicListingID, &item.Slug, &item.Title, &item.Description, &item.PropertyTypeCode, &item.ListingType, &item.ProjectName, &item.Address, &item.Province, &item.District, &sale, &rent, &beds, &baths, &area, &item.PetAllowed, &lat, &lng, &published, &total); err != nil {
				return c.Status(500).JSON(fiber.Map{"error": "cannot read properties"})
			}
			if sale.Valid {
				item.SalePrice = &sale.Float64
			}
			if rent.Valid {
				item.RentPriceMonthly = &rent.Float64
			}
			if beds.Valid {
				v := int(beds.Int64)
				item.BedroomCount = &v
			}
			if baths.Valid {
				v := int(baths.Int64)
				item.BathroomCount = &v
			}
			if area.Valid {
				item.UsableAreaSqm = &area.Float64
			}
			if lat.Valid {
				item.Latitude = &lat.Float64
			}
			if lng.Valid {
				item.Longitude = &lng.Float64
			}
			if published.Valid {
				item.PublishedAt = &published.Time
			}
			listings = append(listings, item)
		}
		intentJSON, _ := json.Marshal(intent)
		_, _ = db.ExecContext(context.Background(), `INSERT INTO public.search_query_events(query_text,normalized_query,parsed_intent,result_count,source) VALUES($1,$2,$3,$4,'web')`, query, intent.Normalized, intentJSON, total)
		return c.JSON(fiber.Map{"query": query, "intent": intent, "listings": listings, "total": total, "limit": limit, "offset": offset})
	}
}

// Keep deterministic output in tests and future cache keys.
func sortIntent(intent *searchIntent) {
	sort.Strings(intent.PropertyTypes)
	sort.Strings(intent.PropertyGroups)
	sort.Strings(intent.UseCases)
	sort.Strings(intent.OfferTypes)
	sort.Strings(intent.Features)
}
