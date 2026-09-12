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
	Query             string           `json:"query"`
	Normalized        string           `json:"normalized_query"`
	Locale            string           `json:"locale"`
	PropertyTypes     []string         `json:"property_types"`
	PropertyGroups    []string         `json:"property_groups"`
	DiscoveryChannels []string         `json:"discovery_channels"`
	UseCases          []string         `json:"use_cases"`
	OfferTypes        []string         `json:"offer_types"`
	SpaceTypes        []string         `json:"space_types"`
	Features          []string         `json:"features"`
	Locations         []searchLocation `json:"locations"`
	MinPrice          *float64         `json:"min_price,omitempty"`
	MaxPrice          *float64         `json:"max_price,omitempty"`
	Bedrooms          *int             `json:"bedrooms,omitempty"`
	FreeText          string           `json:"free_text,omitempty"`
	Confidence        float64          `json:"confidence"`
	Chips             []searchChip     `json:"chips"`
}

type searchListing struct {
	ID                 int64      `json:"id"`
	PublicListingID    string     `json:"public_listing_id"`
	Slug               string     `json:"slug"`
	Title              string     `json:"title"`
	TitleEN            string     `json:"title_en,omitempty"`
	Description        string     `json:"description"`
	DescriptionEN      string     `json:"description_en,omitempty"`
	PropertyTypeCode   string     `json:"property_type_code"`
	AccommodationModel string     `json:"accommodation_model"`
	UsageType          string     `json:"usage_type"`
	ListingType        string     `json:"listing_type"`
	ProjectName        string     `json:"project_name"`
	ProjectPublicID    string     `json:"project_public_id,omitempty"`
	ProjectSlug        string     `json:"project_slug,omitempty"`
	ProjectNameEN      string     `json:"project_name_en,omitempty"`
	ProjectCategory    string     `json:"project_category,omitempty"`
	Address            string     `json:"address"`
	AddressEN          string     `json:"address_en,omitempty"`
	Province           string     `json:"province"`
	ProvinceEN         string     `json:"province_en,omitempty"`
	District           string     `json:"district"`
	DistrictEN         string     `json:"district_en,omitempty"`
	SubdistrictEN      string     `json:"subdistrict_en,omitempty"`
	RoadEN             string     `json:"road_en,omitempty"`
	SalePrice          *float64   `json:"sale_price,omitempty"`
	RentPriceMonthly   *float64   `json:"rent_price_monthly,omitempty"`
	Currency           string     `json:"currency"`
	BedroomCount       *int       `json:"bedroom_count,omitempty"`
	BathroomCount      *int       `json:"bathroom_count,omitempty"`
	UsableAreaSqm      *float64   `json:"usable_area_sqm,omitempty"`
	LandAreaSqm        *float64   `json:"land_area_sqm,omitempty"`
	PetAllowed         bool       `json:"pet_allowed"`
	Latitude           *float64   `json:"latitude,omitempty"`
	Longitude          *float64   `json:"longitude,omitempty"`
	PublishedAt        *time.Time `json:"published_at,omitempty"`
	UpdatedAt          *time.Time `json:"updated_at,omitempty"`
	SpaceTypeCode      string     `json:"space_type_code"`
	SpaceTypeCodes     []string   `json:"space_type_codes"`
	PrimaryImageURL    string     `json:"primary_image_url"`
	ImageURLs          []string   `json:"image_urls"`
	EventName          string     `json:"event_name"`
	EventFloorLabel    string     `json:"event_floor_label"`
	EventRoundCount    int        `json:"event_round_count"`
	EventStartsOn      *time.Time `json:"event_starts_on,omitempty"`
	EventEndsOn        *time.Time `json:"event_ends_on,omitempty"`
	PriceOnRequest     bool       `json:"price_on_request"`
	OfferType          string     `json:"offer_type"`
	OfferAmount        *float64   `json:"offer_amount,omitempty"`
	OfferPriceUnit     string     `json:"offer_price_unit"`
	TemporarySpaceDays *int       `json:"temporary_space_duration_days,omitempty"`
	IsVerified         bool       `json:"is_verified"`
	SourceType         string     `json:"source_type"`
	MapPromotionTier   string     `json:"map_promotion_tier"`
	MapPriorityWeight  int        `json:"map_priority_weight"`
	IsMapPromoted      bool       `json:"is_map_promoted"`
}

type searchBounds struct {
	MinLat float64 `json:"min_lat"`
	MinLon float64 `json:"min_lon"`
	MaxLat float64 `json:"max_lat"`
	MaxLon float64 `json:"max_lon"`
}

func parseSearchBounds(c *fiber.Ctx) (*searchBounds, error) {
	values := []string{c.Query("min_lat"), c.Query("min_lon"), c.Query("max_lat"), c.Query("max_lon")}
	provided := 0
	for _, value := range values {
		if strings.TrimSpace(value) != "" {
			provided++
		}
	}
	if provided == 0 {
		return nil, nil
	}
	if provided != len(values) {
		return nil, fmt.Errorf("all map bounds are required")
	}

	parsed := make([]float64, len(values))
	for index, value := range values {
		number, err := strconv.ParseFloat(value, 64)
		if err != nil {
			return nil, fmt.Errorf("invalid map bounds")
		}
		parsed[index] = number
	}
	bounds := &searchBounds{MinLat: parsed[0], MinLon: parsed[1], MaxLat: parsed[2], MaxLon: parsed[3]}
	if bounds.MinLat < -90 || bounds.MaxLat > 90 || bounds.MinLon < -180 || bounds.MaxLon > 180 || bounds.MinLat >= bounds.MaxLat || bounds.MinLon >= bounds.MaxLon {
		return nil, fmt.Errorf("invalid map bounds")
	}
	return bounds, nil
}

var searchablePropertyTypes = map[string]bool{
	"detached_house": true, "semi_detached_house": true, "townhouse": true, "condo": true,
	"apartment": true, "dormitory": true, "rental_room": true, "flat": true, "monthly_hotel": true,
	"shophouse": true, "home_office": true, "office": true, "retail_space": true, "warehouse": true,
	"factory": true, "hotel_resort": true, "land": true,
}

var searchableSpaceTypes = map[string]bool{
	"standalone_shop": true, "market_stall": true, "mall_kiosk": true, "mall_shop": true,
	"food_court_counter": true, "school_canteen": true, "office_canteen": true, "dormitory_shop": true,
	"street_food_space": true, "shophouse_ground_floor": true, "event_booth": true,
}

var searchableOfferTypes = map[string]bool{
	"sale": true, "rent": true, "sublease": true, "business_transfer": true,
}

func allowedQueryValues(c *fiber.Ctx, key string, allowed map[string]bool) []string {
	seen := map[string]bool{}
	result := []string{}
	for _, raw := range c.Context().QueryArgs().PeekMulti(key) {
		for _, part := range strings.Split(string(raw), ",") {
			value := strings.TrimSpace(part)
			if allowed[value] && !seen[value] {
				seen[value] = true
				result = append(result, value)
			}
		}
	}
	return result
}

func optionalPositiveNumber(value string) *float64 {
	value = strings.ReplaceAll(strings.TrimSpace(value), ",", "")
	if value == "" {
		return nil
	}
	number, err := strconv.ParseFloat(value, 64)
	if err != nil || number < 0 {
		return nil
	}
	return &number
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

		// One phrase can intentionally describe overlapping facets. For example,
		// "บูธในห้าง" is both a mall space and an event booth. Apply every alias
		// with the same phrase before consuming the phrase from the query.
		for _, matchingAlias := range aliases {
			if normalizeSearchText(matchingAlias.Phrase) == phrase {
				applySearchAlias(&intent, matchingAlias)
			}
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

	understood := len(intent.PropertyTypes) + len(intent.PropertyGroups) + len(intent.DiscoveryChannels) + len(intent.UseCases) + len(intent.OfferTypes) + len(intent.SpaceTypes) + len(intent.Features) + len(intent.Locations)
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

func applySearchAlias(intent *searchIntent, alias searchAlias) {
	switch alias.IntentType {
	case "property_type":
		intent.PropertyTypes = appendUnique(intent.PropertyTypes, alias.IntentValue)
	case "property_group":
		intent.PropertyGroups = appendUnique(intent.PropertyGroups, alias.IntentValue)
	case "discovery_channel":
		intent.DiscoveryChannels = appendUnique(intent.DiscoveryChannels, alias.IntentValue)
	case "use_case":
		intent.UseCases = appendUnique(intent.UseCases, alias.IntentValue)
	case "offer_type":
		intent.OfferTypes = appendUnique(intent.OfferTypes, alias.IntentValue)
	case "space_type":
		intent.SpaceTypes = appendUnique(intent.SpaceTypes, alias.IntentValue)
	case "feature":
		intent.Features = appendUnique(intent.Features, alias.IntentValue)
	}
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
	appendValues("discovery_channel", intent.DiscoveryChannels)
	appendValues("use_case", intent.UseCases)
	appendValues("offer_type", intent.OfferTypes)
	appendValues("space_type", intent.SpaceTypes)
	appendValues("feature", intent.Features)
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
		scope := strings.TrimSpace(c.Query("scope", "all"))
		if scope != "all" && scope != "location" {
			return c.Status(400).JSON(fiber.Map{"error": "invalid suggestion scope"})
		}
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
		locale := searchLocale(query)
		rows, err := db.QueryContext(ctx, `
			SELECT kind, label, description, suggested_query FROM (
				SELECT 'location' AS kind,
					CASE WHEN $3 = 'en' THEN name_en ELSE name_th END AS label,
					location_type AS description,
					name_th AS suggested_query,
					priority,
					greatest(similarity(lower(name_th), $1), similarity(lower(name_en), $1)) AS score,
					CASE
						WHEN lower(name_th) = $1 OR lower(name_en) = $1 THEN 4
						WHEN lower(name_th) LIKE $1 || '%' OR lower(name_en) LIKE $1 || '%' THEN 3
						ELSE 1
					END AS match_rank
				FROM public.search_locations
				WHERE is_active
				  AND location_type IN ('country', 'neighborhood', 'transit', 'project')
				  AND (lower(name_th) ILIKE '%' || $1 || '%' OR lower(name_en) ILIKE '%' || $1 || '%' OR EXISTS (
					SELECT 1 FROM unnest(aliases) alias WHERE lower(alias) ILIKE '%' || $1 || '%'
				  ))

				UNION ALL
				SELECT 'location',
					CASE WHEN $3 = 'en' THEN p.name_en ELSE p.name_th END,
					'province',
					p.name_th,
					100,
					greatest(similarity(lower(p.name_th), $1), similarity(lower(p.name_en), $1)),
					CASE
						WHEN lower(p.name_th) = $1 OR lower(p.name_en) = $1 THEN 4
						WHEN lower(p.name_th) LIKE $1 || '%' OR lower(p.name_en) LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.location_provinces p
				WHERE lower(p.name_th) ILIKE '%' || $1 || '%' OR lower(p.name_en) ILIKE '%' || $1 || '%'

				UNION ALL
				SELECT 'location',
					CASE WHEN $3 = 'en'
						THEN d.name_en || ' · ' || p.name_en
						ELSE d.name_th || ' · ' || p.name_th
					END,
					'district',
					p.name_th || ' ' || regexp_replace(d.name_th, '^(เขต|อำเภอ|กิ่งอำเภอ)\s*', ''),
					80,
					greatest(similarity(lower(d.name_th), $1), similarity(lower(d.name_en), $1)),
					CASE
						WHEN lower(d.name_th) = $1 OR lower(d.name_en) = $1 THEN 4
						WHEN lower(d.name_th) LIKE $1 || '%' OR lower(d.name_en) LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.location_districts d
				JOIN public.location_provinces p ON p.id = d.province_id
				WHERE lower(d.name_th) ILIKE '%' || $1 || '%' OR lower(d.name_en) ILIKE '%' || $1 || '%'

				UNION ALL
				SELECT 'location',
					CASE WHEN $3 = 'en'
						THEN s.name_en || ' · ' || d.name_en || ' · ' || p.name_en
						ELSE s.name_th || ' · ' || d.name_th || ' · ' || p.name_th
					END,
					'subdistrict',
					p.name_th || ' ' || regexp_replace(d.name_th, '^(เขต|อำเภอ|กิ่งอำเภอ)\s*', '') || ' ' || s.name_th,
					70,
					greatest(similarity(lower(s.name_th), $1), similarity(lower(s.name_en), $1)),
					CASE
						WHEN lower(s.name_th) = $1 OR lower(s.name_en) = $1 THEN 4
						WHEN lower(s.name_th) LIKE $1 || '%' OR lower(s.name_en) LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.location_subdistricts s
				JOIN public.location_districts d ON d.id = s.district_id
				JOIN public.location_provinces p ON p.id = d.province_id
				WHERE lower(s.name_th) ILIKE '%' || $1 || '%' OR lower(s.name_en) ILIKE '%' || $1 || '%'

				UNION ALL
				SELECT 'project',
					CASE WHEN $3 = 'en' AND NULLIF(p.name_en, '') IS NOT NULL THEN p.name_en ELSE p.name_th END,
					p.project_category,
					CASE WHEN $3 = 'en' AND NULLIF(p.name_en, '') IS NOT NULL THEN p.name_en ELSE p.name_th END,
					110,
					greatest(
						similarity(lower(p.name_th), $1),
						similarity(lower(COALESCE(p.name_en, '')), $1),
						COALESCE(alias_score.score, 0::real)
					),
					CASE
						WHEN public.normalize_project_search_name(p.name_th) = public.normalize_project_search_name($1)
						  OR public.normalize_project_search_name(COALESCE(p.name_en, '')) = public.normalize_project_search_name($1)
						  OR EXISTS (
							SELECT 1 FROM public.property_project_aliases exact_alias
							WHERE exact_alias.project_id = p.id
							  AND exact_alias.is_searchable = true
							  AND exact_alias.normalized_alias = public.normalize_project_search_name($1)
						  ) THEN 4
						WHEN lower(p.name_th) LIKE $1 || '%'
						  OR lower(COALESCE(p.name_en, '')) LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.property_projects p
				LEFT JOIN LATERAL (
					SELECT max(greatest(
						similarity(lower(alias.alias_name), $1),
						similarity(alias.normalized_alias, public.normalize_project_search_name($1))
					)) AS score
					FROM public.property_project_aliases alias
					WHERE alias.project_id = p.id AND alias.is_searchable = true
				) alias_score ON true
				WHERE p.is_active = true
				  AND p.deleted_at IS NULL
				  AND (
					lower(p.name_th) ILIKE '%' || $1 || '%' OR
					lower(COALESCE(p.name_en, '')) ILIKE '%' || $1 || '%' OR
					public.normalize_project_search_name(p.name_th) LIKE '%' || public.normalize_project_search_name($1) || '%' OR
					public.normalize_project_search_name(COALESCE(p.name_en, '')) LIKE '%' || public.normalize_project_search_name($1) || '%' OR
					EXISTS (
						SELECT 1 FROM public.property_project_aliases alias
						WHERE alias.project_id = p.id
						  AND alias.is_searchable = true
						  AND (
							lower(alias.alias_name) ILIKE '%' || $1 || '%' OR
							alias.normalized_alias LIKE '%' || public.normalize_project_search_name($1) || '%'
						  )
					)
				  )

				UNION ALL
				SELECT 'location', place.name, place.kind, place.name, place.priority,
					similarity(lower(place.name), $1),
					CASE
						WHEN lower(place.name) = $1 THEN 4
						WHEN lower(place.name) LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.listings l
				CROSS JOIN LATERAL (
					VALUES
						(NULLIF(trim(l.custom_project_name), ''), 'project', 96),
						(NULLIF(trim(l.custom_building_name), ''), 'building', 94)
				) AS place(name, kind, priority)
				WHERE place.name IS NOT NULL
				  AND l.published_at IS NOT NULL
				  AND l.deleted_at IS NULL
				  AND l.is_active = true
				  AND l.listing_status = 'active'
				  AND l.moderation_status = 'approved'
				  AND (l.expires_at IS NULL OR l.expires_at > now())
				  AND lower(place.name) ILIKE '%' || $1 || '%'
				GROUP BY place.name, place.kind, place.priority

				UNION ALL
				SELECT 'listing', l.title, 'listing', l.title, 90,
					similarity(lower(l.title), $1),
					CASE
						WHEN lower(l.title) = $1 THEN 4
						WHEN lower(l.title) LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.listings l
				WHERE $4 <> 'location'
				  AND l.published_at IS NOT NULL
				  AND l.deleted_at IS NULL
				  AND l.is_active = true
				  AND l.listing_status = 'active'
				  AND l.moderation_status = 'approved'
				  AND (l.expires_at IS NULL OR l.expires_at > now())
				  AND lower(l.title) ILIKE '%' || $1 || '%'
				GROUP BY l.title

				UNION ALL
				SELECT 'listing', translation.title, 'listing', translation.title, 90,
					similarity(lower(translation.title), $1),
					CASE
						WHEN lower(translation.title) = $1 THEN 4
						WHEN lower(translation.title) LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.listing_translations translation
				JOIN public.listings l ON l.id = translation.listing_id
				WHERE $4 <> 'location'
				  AND translation.language_code = 'en'
				  AND translation.translation_status = 'published'
				  AND translation.deleted_at IS NULL
				  AND l.published_at IS NOT NULL
				  AND l.deleted_at IS NULL
				  AND l.is_active = true
				  AND l.listing_status = 'active'
				  AND l.moderation_status = 'approved'
				  AND (l.expires_at IS NULL OR l.expires_at > now())
				  AND lower(translation.title) ILIKE '%' || $1 || '%'
				GROUP BY translation.title

				UNION ALL
				SELECT sa.intent_type,
					CASE
						WHEN sa.intent_type = 'property_type' AND sa.locale = 'th' THEN COALESCE(pt.name_th, sa.phrase)
						WHEN sa.intent_type = 'property_type' THEN COALESCE(pt.name_en, sa.phrase)
						ELSE sa.phrase
					END,
					sa.intent_value, sa.phrase, sa.priority,
					similarity(sa.normalized_phrase, $1),
					CASE
						WHEN sa.normalized_phrase = $1 THEN 4
						WHEN sa.normalized_phrase LIKE $1 || '%' THEN 3
						ELSE 1
					END
				FROM public.search_aliases sa
				LEFT JOIN public.property_types pt
					ON sa.intent_type = 'property_type' AND pt.code = sa.intent_value
				WHERE $4 <> 'location' AND sa.is_active AND sa.normalized_phrase ILIKE '%' || $1 || '%'
			) s
			ORDER BY match_rank DESC, score DESC, priority DESC, length(label)
			LIMIT $2`, query, limit, locale, scope)
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
		mapView := c.Query("view") == "map"
		identifier := strings.TrimSpace(c.Query("identifier"))
		if c.Context().QueryArgs().Has("identifier") && identifier == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "listing identifier is required"})
		}
		bounds, boundsErr := parseSearchBounds(c)
		if boundsErr != nil {
			return c.Status(400).JSON(fiber.Map{"error": boundsErr.Error()})
		}
		// An empty query is the public catalogue view. It intentionally returns
		// only published records, so the web UI never needs to fall back to demo
		// listings when a visitor opens a category or the map for the first time.
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
		intent := searchIntent{Query: query, Normalized: normalizeSearchText(query), Locale: searchLocale(query)}
		if query != "" {
			var err error
			intent, err = parseIntentFromDB(ctx, db, query)
			if err != nil {
				return c.Status(500).JSON(fiber.Map{"error": "cannot interpret search"})
			}
		}

		where := []string{
			"l.published_at IS NOT NULL",
			"l.deleted_at IS NULL",
			"l.is_active = true",
			"l.listing_status = 'active'",
			"l.moderation_status = 'approved'",
			"(l.expires_at IS NULL OR l.expires_at > now())",
		}
		args := []any{}
		arg := func(value any) string { args = append(args, value); return fmt.Sprintf("$%d", len(args)) }
		// A permalink lookup must select its listing before pagination. Loading
		// a recent catalogue page and searching it hides older published listings.
		if identifier != "" {
			where = append(where, listingIdentifierPredicate(identifier, arg))
		}
		directPropertyTypes := allowedQueryValues(c, "property_type", searchablePropertyTypes)
		for _, propertyType := range directPropertyTypes {
			if propertyType == "detached_house" {
				// Published listings created before the taxonomy migration use house.
				directPropertyTypes = append(directPropertyTypes, "house")
				break
			}
		}
		directSpaceTypes := allowedQueryValues(c, "space_type", searchableSpaceTypes)
		directOfferTypes := allowedQueryValues(c, "offer_type", searchableOfferTypes)
		discoveryChannel := strings.TrimSpace(c.Query("channel"))
		if discoveryChannel != "" {
			validChannels := map[string]bool{"homes": true, "rooms": true, "business": true}
			if !validChannels[discoveryChannel] {
				return c.Status(400).JSON(fiber.Map{"error": "invalid discovery channel"})
			}

			// Discovery channel is deliberately an AND filter. Editorial or manual
			// channel curation takes precedence over the broad property-type mapping;
			// the mapping remains a fallback for listings without explicit curation.
			channelArg := arg(discoveryChannel)
			where = append(where, `(EXISTS (
				SELECT 1 FROM public.listing_discovery_channels ldc
				WHERE ldc.listing_id=l.id AND ldc.channel_code = `+channelArg+`
			) OR (NOT EXISTS (
				SELECT 1 FROM public.listing_discovery_channels explicit_ldc
				WHERE explicit_ldc.listing_id=l.id
				  AND explicit_ldc.source IN ('editorial', 'manual')
			) AND EXISTS (
				SELECT 1 FROM public.discovery_channel_property_types dcpt
				WHERE dcpt.channel_code = `+channelArg+`
				  AND dcpt.property_type_code=l.property_type_code
				  AND (cardinality(dcpt.allowed_offer_types)=0 OR EXISTS (
					SELECT 1 FROM public.listing_offers dlo
					WHERE dlo.listing_id=l.id AND dlo.offer_type = ANY(dcpt.allowed_offer_types)
				  ))
			)) OR (l.usage_type = 'mixed' AND `+channelArg+` IN ('homes', 'business')))`)
		}
		categoryFilters := []string{}
		if len(intent.PropertyTypes) > 0 {
			categoryFilters = append(categoryFilters, "l.property_type_code = ANY("+arg(pq.Array(intent.PropertyTypes))+")")
		}
		if len(intent.PropertyGroups) > 0 {
			categoryFilters = append(categoryFilters, "EXISTS (SELECT 1 FROM public.property_types pt WHERE pt.code=l.property_type_code AND pt.group_code = ANY("+arg(pq.Array(intent.PropertyGroups))+"))")
		}
		if len(intent.DiscoveryChannels) > 0 {
			channelsArg := arg(pq.Array(intent.DiscoveryChannels))
			categoryFilters = append(categoryFilters, `(EXISTS (
				SELECT 1 FROM public.listing_discovery_channels ldc
				WHERE ldc.listing_id=l.id AND ldc.channel_code = ANY(`+channelsArg+`)
			) OR (NOT EXISTS (
				SELECT 1 FROM public.listing_discovery_channels explicit_ldc
				WHERE explicit_ldc.listing_id=l.id
				  AND explicit_ldc.source IN ('editorial', 'manual')
			) AND EXISTS (
				SELECT 1 FROM public.discovery_channel_property_types dcpt
				WHERE dcpt.channel_code = ANY(`+channelsArg+`)
				  AND dcpt.property_type_code=l.property_type_code
				  AND (cardinality(dcpt.allowed_offer_types)=0 OR EXISTS (
					SELECT 1 FROM public.listing_offers dlo
					WHERE dlo.listing_id=l.id AND dlo.offer_type = ANY(dcpt.allowed_offer_types)
				  ))
			)) OR (l.usage_type = 'mixed' AND ARRAY['homes','business']::text[] && `+channelsArg+`))`)
		}
		if len(intent.SpaceTypes) > 0 {
			spaceTypesArg := arg(pq.Array(intent.SpaceTypes))
			categoryFilters = append(categoryFilters, `(EXISTS (
				SELECT 1 FROM public.listing_space_types lst
				WHERE lst.listing_id=l.id AND lst.space_type_code = ANY(`+spaceTypesArg+`)
			) OR EXISTS (
				SELECT 1 FROM public.listing_business_details lbd
				WHERE lbd.listing_id=l.id AND lbd.venue_type_code = ANY(`+spaceTypesArg+`)
			))`)
		}
		if len(categoryFilters) > 0 {
			where = append(where, "("+strings.Join(categoryFilters, " OR ")+")")
		}
		directCategoryFilters := []string{}
		if len(directPropertyTypes) > 0 {
			directCategoryFilters = append(directCategoryFilters, "l.property_type_code = ANY("+arg(pq.Array(directPropertyTypes))+")")
		}
		if len(directSpaceTypes) > 0 {
			spaceTypesArg := arg(pq.Array(directSpaceTypes))
			directCategoryFilters = append(directCategoryFilters, `(EXISTS (
				SELECT 1 FROM public.listing_space_types lst
				WHERE lst.listing_id=l.id AND lst.space_type_code = ANY(`+spaceTypesArg+`)
			) OR EXISTS (
				SELECT 1 FROM public.listing_business_details lbd
				WHERE lbd.listing_id=l.id AND lbd.venue_type_code = ANY(`+spaceTypesArg+`)
			))`)
		}
		if len(directCategoryFilters) > 0 {
			where = append(where, "("+strings.Join(directCategoryFilters, " OR ")+")")
		}
		if len(intent.UseCases) > 0 {
			where = append(where, "EXISTS (SELECT 1 FROM public.listing_use_cases luc WHERE luc.listing_id=l.id AND luc.use_case_code = ANY("+arg(pq.Array(intent.UseCases))+"))")
		}
		if len(intent.OfferTypes) > 0 {
			where = append(where, "EXISTS (SELECT 1 FROM public.listing_offers lo WHERE lo.listing_id=l.id AND lo.offer_type = ANY("+arg(pq.Array(intent.OfferTypes))+"))")
		}
		if len(directOfferTypes) > 0 {
			where = append(where, "EXISTS (SELECT 1 FROM public.listing_offers lo WHERE lo.listing_id=l.id AND lo.offer_type = ANY("+arg(pq.Array(directOfferTypes))+"))")
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
			} else if feature == "serviced" {
				where = append(where, "l.accommodation_model = 'serviced'")
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
		directMinPrice := optionalPositiveNumber(c.Query("price_min"))
		directMaxPrice := optionalPositiveNumber(c.Query("price_max"))
		if directMinPrice != nil || directMaxPrice != nil {
			parts := []string{"lo.listing_id=l.id", "lo.amount IS NOT NULL"}
			if len(directOfferTypes) > 0 {
				parts = append(parts, "lo.offer_type = ANY("+arg(pq.Array(directOfferTypes))+")")
			}
			if directMinPrice != nil {
				parts = append(parts, "lo.amount >= "+arg(*directMinPrice))
			}
			if directMaxPrice != nil {
				parts = append(parts, "lo.amount <= "+arg(*directMaxPrice))
			}
			where = append(where, "EXISTS (SELECT 1 FROM public.listing_offers lo WHERE "+strings.Join(parts, " AND ")+")")
		}
		if intent.FreeText != "" {
			freeTextPatternArg := arg("%" + intent.FreeText + "%")
			freeTextArg := arg(intent.FreeText)
			where = append(where, `(l.search_text ILIKE `+freeTextPatternArg+` OR EXISTS (
				SELECT 1
				FROM public.listing_translations translation
				WHERE translation.listing_id = l.id
				  AND translation.translation_status = 'published'
				  AND translation.deleted_at IS NULL
				  AND translation.search_text ILIKE `+freeTextPatternArg+`
			) OR EXISTS (
				SELECT 1
				FROM public.property_projects project
				WHERE project.id = l.project_id
				  AND project.is_active = true
				  AND project.deleted_at IS NULL
				  AND (
					project.search_text ILIKE `+freeTextPatternArg+` OR
					public.normalize_project_search_name(project.name_th) LIKE '%' || public.normalize_project_search_name(`+freeTextArg+`) || '%' OR
					public.normalize_project_search_name(COALESCE(project.name_en, '')) LIKE '%' || public.normalize_project_search_name(`+freeTextArg+`) || '%' OR
					EXISTS (
						SELECT 1 FROM public.property_project_aliases alias
						WHERE alias.project_id = project.id
						  AND alias.is_searchable = true
						  AND (
							lower(alias.alias_name) ILIKE `+freeTextPatternArg+` OR
							alias.normalized_alias LIKE '%' || public.normalize_project_search_name(`+freeTextArg+`) || '%'
						  )
					)
				  )
			))`)
		}
		if bounds != nil {
			where = append(where,
				"l.latitude IS NOT NULL",
				"l.longitude IS NOT NULL",
				"l.latitude BETWEEN "+arg(bounds.MinLat)+" AND "+arg(bounds.MaxLat),
				"l.longitude BETWEEN "+arg(bounds.MinLon)+" AND "+arg(bounds.MaxLon),
			)
		}

		limitArg := arg(limit)
		offsetArg := arg(offset)
		orderBy := "l.published_at DESC"
		if intent.Normalized != "" {
			queryArg := arg(intent.Normalized)
			orderBy = `greatest(
				similarity(l.search_text, ` + queryArg + `),
				COALESCE(similarity(lt_en.search_text, ` + queryArg + `), 0::real),
				COALESCE(similarity(project.search_text, ` + queryArg + `), 0::real),
				COALESCE((
					SELECT max(greatest(
						similarity(lower(project_alias.alias_name), ` + queryArg + `),
						similarity(project_alias.normalized_alias, public.normalize_project_search_name(` + queryArg + `))
					))
					FROM public.property_project_aliases project_alias
					WHERE project_alias.project_id = l.project_id AND project_alias.is_searchable = true
				), 0::real)
			) DESC, l.published_at DESC`
		}
		promotionOrderBy := `CASE COALESCE(mp.tier, 'free')
			WHEN 'premium' THEN 2
			WHEN 'boosted' THEN 1
			ELSE 0
		END DESC, COALESCE(mp.priority_weight, 0) DESC`
		// Map cards need one image and no rich-text description. Keep the same
		// public visibility and filter predicates, while avoiding full detail payloads.
		descriptionColumns := "COALESCE(l.description,''), COALESCE(lt_en.description,'')"
		galleryLimit := "4"
		if mapView {
			descriptionColumns = "''::text, ''::text"
			galleryLimit = "1"
		}
		offerPreference := ""
		if len(directOfferTypes) > 0 {
			offerPreference = "CASE WHEN offer_type = ANY(" + arg(pq.Array(directOfferTypes)) + ") THEN 0 ELSE 1 END, "
		}
		sqlQuery := `SELECT l.id, l.public_listing_id::text, COALESCE(l.slug,''), l.title,
			COALESCE(lt_en.title,''), ` + descriptionColumns + `,
			l.property_type_code, COALESCE(l.accommodation_model,''), COALESCE(l.usage_type,''), l.listing_type,
			COALESCE(project.name_th,l.custom_project_name,''),
			COALESCE(project.public_project_id::text,''), COALESCE(project.slug,''),
			COALESCE(project.name_en,''), COALESCE(project.project_category,''),
			trim(concat_ws(' ',l.address_line1,l.address_line2)),
			trim(concat_ws(' ',lt_en.address_line1,lt_en.address_line2)),
			COALESCE(l.province_name,''), COALESCE(lt_en.province_name,''),
			COALESCE(l.district_name,''), COALESCE(lt_en.district_name,''),
			COALESCE(lt_en.subdistrict_name,''), COALESCE(lt_en.road,''),
			l.sale_price, l.rent_price_monthly, l.bedroom_count, l.bathroom_count,
			l.usable_area_sqm, l.land_area_sqm, l.pet_allowed, l.latitude, l.longitude, l.published_at, l.updated_at,
			COALESCE(l.space_type_code,''),
			COALESCE(lst.space_type_codes, CASE WHEN NULLIF(l.space_type_code, '') IS NULL THEN ARRAY[]::text[] ELSE ARRAY[l.space_type_code] END),
			COALESCE(pm.media_url,''),
			COALESCE(pm.image_urls, ARRAY[]::text[]),
			COALESCE(led.event_name,''), COALESCE(led.venue_floor_label,''),
			COALESCE(er.round_count,0), er.starts_on, er.ends_on,
			COALESCE((lcd.details->>'price_on_request')::boolean, led.price_on_request, false),
			COALESCE(so.offer_type,''), so.amount, COALESCE(so.price_unit,''), COALESCE(so.currency_code,'THB'),
			CASE WHEN COALESCE(lcd.details->>'temporary_space_duration_days','') ~ '^[1-9][0-9]*$'
				THEN (lcd.details->>'temporary_space_duration_days')::integer END,
			l.is_verified, COALESCE(ls.source_type,''),
			COALESCE(mp.tier, 'free'), COALESCE(mp.priority_weight, 0), (mp.id IS NOT NULL),
			count(*) OVER() AS total_count
		FROM public.listings l
		LEFT JOIN public.listing_translations lt_en
			ON lt_en.listing_id = l.id
			AND lt_en.language_code = 'en'
			AND lt_en.translation_status = 'published'
			AND lt_en.deleted_at IS NULL
		LEFT JOIN public.property_projects project ON project.id = l.project_id AND project.is_active = true AND project.deleted_at IS NULL
		LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
		LEFT JOIN public.listing_event_details led ON led.listing_id = l.id
		LEFT JOIN LATERAL (
			SELECT array_agg(space_type_code ORDER BY is_primary DESC, sort_order, space_type_code) AS space_type_codes
			FROM public.listing_space_types
			WHERE listing_id = l.id
		) lst ON true
		LEFT JOIN LATERAL (
			SELECT count(*)::integer AS round_count, min(starts_on) AS starts_on, max(ends_on) AS ends_on
			FROM public.listing_event_rounds
			WHERE listing_id = l.id
			  AND availability_status IN ('open','limited','waitlist')
			  AND ends_on >= CURRENT_DATE
		) er ON true
		LEFT JOIN LATERAL (
			SELECT
				COALESCE(gallery.image_urls[1], '') AS media_url,
				COALESCE(gallery.image_urls, ARRAY[]::text[]) AS image_urls
			FROM (
				SELECT array_agg(media_url ORDER BY is_primary DESC, sort_order, id) AS image_urls
				FROM (
					SELECT
						COALESCE(NULLIF(large_url,''), NULLIF(medium_url,''), NULLIF(file_url,''), NULLIF(original_url,''), '') AS media_url,
						is_primary,
						sort_order,
						id
					FROM public.listing_media
					WHERE listing_id = l.id
						AND is_active = true
						AND deleted_at IS NULL
						AND media_type = 'image'
						AND COALESCE(NULLIF(large_url,''), NULLIF(medium_url,''), NULLIF(file_url,''), NULLIF(original_url,''), '') <> ''
					ORDER BY is_primary DESC, sort_order, id
					LIMIT ` + galleryLimit + `
				) gallery_images
			) gallery
		) pm ON true
		LEFT JOIN LATERAL (
			SELECT offer_type, amount, price_unit, currency_code
			FROM public.listing_offers
			WHERE listing_id = l.id
			ORDER BY ` + offerPreference + `CASE offer_type
				WHEN 'rent' THEN 1
				WHEN 'sublease' THEN 2
				ELSE 3
			END, id
			LIMIT 1
		) so ON true
		LEFT JOIN LATERAL (
			SELECT source_type
			FROM public.listing_sources
			WHERE listing_id = l.id
			ORDER BY CASE source_type WHEN 'owner' THEN 0 ELSE 1 END, id
			LIMIT 1
		) ls ON true
		LEFT JOIN LATERAL (
			SELECT promotion.id, promotion.tier, promotion.priority_weight
			FROM public.listing_promotion_campaigns promotion
			WHERE promotion.listing_id = l.id
			  AND promotion.placement = 'map'
			  AND promotion.status = 'active'
			  AND promotion.starts_at <= now()
			  AND (promotion.ends_at IS NULL OR promotion.ends_at > now())
			ORDER BY CASE promotion.tier WHEN 'premium' THEN 2 WHEN 'boosted' THEN 1 ELSE 0 END DESC,
				promotion.priority_weight DESC,
				promotion.starts_at DESC,
				promotion.id DESC
			LIMIT 1
		) mp ON true
		WHERE ` + strings.Join(where, " AND ") + `
		ORDER BY ` + promotionOrderBy + `, ` + orderBy + `, l.id DESC
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
			var sale, rent, area, landArea, lat, lng, offerAmount sql.NullFloat64
			var beds, baths, temporarySpaceDays sql.NullInt64
			var published, updated, eventStartsOn, eventEndsOn sql.NullTime
			if err := rows.Scan(&item.ID, &item.PublicListingID, &item.Slug, &item.Title, &item.TitleEN, &item.Description, &item.DescriptionEN, &item.PropertyTypeCode, &item.AccommodationModel, &item.UsageType, &item.ListingType, &item.ProjectName, &item.ProjectPublicID, &item.ProjectSlug, &item.ProjectNameEN, &item.ProjectCategory, &item.Address, &item.AddressEN, &item.Province, &item.ProvinceEN, &item.District, &item.DistrictEN, &item.SubdistrictEN, &item.RoadEN, &sale, &rent, &beds, &baths, &area, &landArea, &item.PetAllowed, &lat, &lng, &published, &updated, &item.SpaceTypeCode, pq.Array(&item.SpaceTypeCodes), &item.PrimaryImageURL, pq.Array(&item.ImageURLs), &item.EventName, &item.EventFloorLabel, &item.EventRoundCount, &eventStartsOn, &eventEndsOn, &item.PriceOnRequest, &item.OfferType, &offerAmount, &item.OfferPriceUnit, &item.Currency, &temporarySpaceDays, &item.IsVerified, &item.SourceType, &item.MapPromotionTier, &item.MapPriorityWeight, &item.IsMapPromoted, &total); err != nil {
				return c.Status(500).JSON(fiber.Map{"error": "cannot read properties"})
			}
			if sale.Valid {
				item.SalePrice = &sale.Float64
			}
			if rent.Valid {
				item.RentPriceMonthly = &rent.Float64
			}
			if offerAmount.Valid {
				item.OfferAmount = &offerAmount.Float64
			}
			if temporarySpaceDays.Valid {
				value := int(temporarySpaceDays.Int64)
				item.TemporarySpaceDays = &value
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
			if landArea.Valid {
				item.LandAreaSqm = &landArea.Float64
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
			if updated.Valid {
				item.UpdatedAt = &updated.Time
			}
			if eventStartsOn.Valid {
				item.EventStartsOn = &eventStartsOn.Time
			}
			if eventEndsOn.Valid {
				item.EventEndsOn = &eventEndsOn.Time
			}
			listings = append(listings, item)
		}
		if err := rows.Err(); err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot finish reading properties"})
		}
		if identifier == "" && !mapView {
			intentJSON, _ := json.Marshal(intent)
			_, _ = db.ExecContext(context.Background(), `INSERT INTO public.search_query_events(query_text,normalized_query,parsed_intent,result_count,source) VALUES($1,$2,$3,$4,'web')`, query, intent.Normalized, intentJSON, total)
		}
		return c.JSON(fiber.Map{"query": query, "bounds": bounds, "intent": intent, "listings": listings, "total": total, "limit": limit, "offset": offset})
	}
}

// Keep deterministic output in tests and future cache keys.
func sortIntent(intent *searchIntent) {
	sort.Strings(intent.PropertyTypes)
	sort.Strings(intent.PropertyGroups)
	sort.Strings(intent.UseCases)
	sort.Strings(intent.OfferTypes)
	sort.Strings(intent.SpaceTypes)
	sort.Strings(intent.Features)
}
