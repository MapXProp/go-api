package handlers

import (
	"strings"
	"unicode"
)

// Catalogue keywords are literal text, not inferred property/price/location filters.
// Match all supplied words anywhere in the public document, ignoring formatting.
func listingKeywordPatterns(query string) []string {
	result := []string{}
	seen := map[string]bool{}
	for _, word := range strings.Fields(query) {
		word = strings.Map(func(r rune) rune {
			if r >= '๐' && r <= '๙' {
				return '0' + r - '๐'
			}
			if unicode.IsSpace(r) || unicode.IsPunct(r) || unicode.Is(unicode.Cf, r) {
				return -1
			}
			return unicode.ToLower(r)
		}, word)
		if word != "" && !seen[word] {
			seen[word] = true
			// Escape LIKE operators even when they are Unicode symbols rather than punctuation.
			word = strings.NewReplacer(`\`, `\\`, `%`, `\%`, `_`, `\_`).Replace(word)
			result = append(result, "%"+word+"%")
		}
	}
	return result
}

// This deliberately selects public fields rather than serializing database rows.
// Never index verification notes, registration evidence, auth-user data or import
// provenance: a match itself would disclose information omitted from the detail API.
var listingKeywordDocumentSQL = `regexp_replace(lower(translate(
 regexp_replace(concat_ws(' ',
  l.title, l.description, l.slug, l.public_listing_id::text,
  l.custom_project_name, l.custom_project_name_en, l.custom_building_name,
  l.address_line1, l.address_line2, l.road, l.province_name, l.district_name,
  l.subdistrict_name, l.postal_code, l.latitude, l.longitude,
  l.contact_name, l.contact_phone, l.contact_phone_secondary, l.contact_email, l.line_id, l.instagram_handle,
  l.property_type_code, l.accommodation_model, l.usage_type, l.listing_type,
  l.furnishing_status, l.property_condition, l.occupancy_status,
  (` + listingKeywordLabelsSQL + `)->>l.furnishing_status,
  (` + listingKeywordLabelsSQL + `)->>l.property_condition,
  (` + listingKeywordLabelsSQL + `)->>l.occupancy_status,
  l.sale_price, l.rent_price_monthly, l.usable_area_sqm, l.land_area_sqm, l.land_area_sqm / 4, l.land_area_sqm / 1600,
  CASE WHEN l.usable_area_sqm IS NOT NULL THEN concat(l.usable_area_sqm, ' ตารางเมตร ตร.ม. sqm') END,
  CASE WHEN l.land_area_sqm IS NOT NULL THEN concat(l.land_area_sqm / 4, ' ตารางวา ตร.ว. ', l.land_area_sqm / 1600, ' ไร่ rai') END,
  CASE WHEN l.bedroom_count IS NOT NULL THEN concat(l.bedroom_count, ' ห้องนอน ', l.bedroom_count, ' bedrooms') END,
  CASE WHEN l.bathroom_count IS NOT NULL THEN concat(l.bathroom_count, ' ห้องน้ำ ', l.bathroom_count, ' bathrooms') END,
  CASE WHEN l.parking_count > 0 THEN concat(l.parking_count, ' ที่จอดรถ parking') END,
  CASE WHEN l.total_floors IS NOT NULL THEN concat(l.total_floors, ' ชั้น floors') END,
  l.floor_no,
  CASE WHEN l.pet_allowed THEN 'เลี้ยงสัตว์ได้ อนุญาตสัตว์เลี้ยง pet friendly pets allowed' END,
  CASE WHEN l.is_verified THEN 'ตรวจสอบแล้ว verified' END,
  (SELECT concat_ws(' ', pt.name_th, pt.name_en) FROM public.property_types pt WHERE pt.code=l.property_type_code),
  (SELECT string_agg(concat_ws(' ', t.title, t.description, t.address_line1, t.address_line2,
    t.province_name, t.district_name, t.subdistrict_name, t.road), ' ')
   FROM public.listing_translations t WHERE t.listing_id=l.id AND t.translation_status='published' AND t.deleted_at IS NULL),
  project.name_th, project.name_en, project.description_th, project.description_en,
  project.developer_name_th, project.developer_name_en, project.address_line1, project.road,
  project.slug, project.public_project_id::text,
  project.subdistrict_name, project.district_name, project.province_name, project.postal_code,
  (SELECT string_agg(a.alias_name, ' ') FROM public.property_project_aliases a
   WHERE a.project_id=project.id AND a.is_searchable),
  (SELECT string_agg(concat_ws(' ', b.heading_th, b.heading_en, b.body_th, b.body_en,
    jsonb_path_query_array(b.content, '$.** ? (@.type() == "string" || @.type() == "number")')::text), ' ')
   FROM public.listing_content_blocks b WHERE b.listing_id=l.id AND b.is_visible),
  (SELECT string_agg(concat_ws(' ',
    jsonb_path_query_array(d.value, '$.** ? (@.type() == "string" || @.type() == "number")')::text,
    (SELECT string_agg((` + listingKeywordLabelsSQL + `)->>(v #>> '{}'), ' ')
     FROM jsonb_path_query(d.value, '$.** ? (@.type() == "string")') v),
    CASE WHEN d.value IN ('true'::jsonb, '"true"'::jsonb, '"yes"'::jsonb)
     THEN (` + listingKeywordLabelsSQL + `)->>d.key END), ' ')
   FROM jsonb_each(COALESCE(lcd.details, '{}'::jsonb)) d
   WHERE d.key <> 'data_provenance' AND left(d.key, 7) <> 'source_'),
  (SELECT string_agg(concat_ws(' ', n.place_name_th, n.place_name_en, n.distance_meters, n.travel_time_minutes), ' ')
   FROM public.listing_nearby_places n WHERE n.listing_id=l.id AND n.is_highlight),
  (SELECT string_agg(concat_ws(' ', t.label_th, t.label_en, t.value_th, t.value_en, t.numeric_value, t.unit_code), ' ')
   FROM public.listing_transaction_terms t WHERE t.listing_id=l.id),
  (SELECT string_agg(concat_ws(' ', m.title, m.alt_text), ' ') FROM public.listing_media m
   WHERE m.listing_id=l.id AND m.is_active AND m.deleted_at IS NULL),
  (SELECT string_agg(concat_ws(' ', o.offer_type, o.amount, o.currency_code, o.price_unit,
    CASE WHEN o.currency_code='THB' THEN 'บาท baht' END,
    CASE o.price_unit WHEN 'monthly' THEN 'ต่อเดือน เดือน month monthly'
     WHEN 'daily' THEN 'ต่อวัน วัน day daily' WHEN 'sqm_monthly' THEN 'ต่อตารางเมตรต่อเดือน ตร.ม. เดือน sqm month' END,
    o.deposit_amount, o.advance_amount, o.minimum_contract_months, o.service_fee_monthly,
    CASE o.offer_type WHEN 'sale' THEN 'ขาย ซื้อ sale buy' WHEN 'rent' THEN 'เช่า rent rental'
     WHEN 'sublease' THEN 'เช่าช่วง sublease' WHEN 'business_transfer' THEN 'เซ้ง business transfer'
     WHEN 'event_booking' THEN 'เช่าบูธ จองบูธ event booking' END,
    CASE WHEN o.is_negotiable THEN 'ต่อรองได้ negotiable' END), ' ')
   FROM public.listing_offers o WHERE o.listing_id=l.id),
  (SELECT string_agg(concat_ws(' ', s.code, s.name_th, s.name_en), ' ')
   FROM public.listing_space_types x JOIN public.business_space_types s ON s.code=x.space_type_code WHERE x.listing_id=l.id),
  (SELECT string_agg(concat_ws(' ', code, (` + listingKeywordLabelsSQL + `)->>code), ' ')
   FROM public.listing_business_details b, unnest(b.allowed_business_types) code WHERE b.listing_id=l.id),
  (SELECT string_agg(concat_ws(' ', u.code, u.name_th, u.name_en), ' ')
   FROM public.listing_use_cases x JOIN public.use_cases u ON u.code=x.use_case_code WHERE x.listing_id=l.id),
  (SELECT string_agg(concat_ws(' ', a.amenity_code, CASE a.amenity_code
    WHEN 'air_conditioning' THEN 'แอร์ เครื่องปรับอากาศ air conditioning'
    WHEN 'parking' THEN 'ที่จอดรถ parking' WHEN 'elevator' THEN 'ลิฟต์ elevator lift'
    WHEN 'security' THEN 'รักษาความปลอดภัย รปภ security'
    WHEN 'swimming_pool' THEN 'สระว่ายน้ำ swimming pool'
    WHEN 'fitness' THEN 'ฟิตเนส ห้องออกกำลังกาย fitness gym'
    WHEN 'wifi' THEN 'ไวไฟ อินเทอร์เน็ต wifi internet'
    WHEN 'pet_friendly' THEN 'เลี้ยงสัตว์ได้ อนุญาตสัตว์เลี้ยง pet friendly pets allowed'
    WHEN 'pet_area' THEN 'พื้นที่สำหรับสัตว์เลี้ยง pet area' END), ' ')
   FROM public.listing_amenities a WHERE a.listing_id=l.id),
  (SELECT concat_ws(' ', c.organization_name, CASE c.role_code
    WHEN 'owner' THEN 'เจ้าของทรัพย์ เจ้าของขายเอง เจ้าของโดยตรง owner direct'
    WHEN 'owner_representative' THEN 'ผู้รับมอบอำนาจจากเจ้าของ owner representative'
    WHEN 'developer_investor_representative' THEN 'ตัวแทนโครงการ นักลงทุน developer investor representative'
    WHEN 'independent_broker' THEN 'นายหน้า broker' WHEN 'agency_broker' THEN 'นายหน้า เอเจนซี่ agency broker'
    WHEN 'property_manager' THEN 'ผู้จัดการทรัพย์ property manager' END)
   FROM public.listing_contact_profiles c WHERE c.listing_id=l.id),
  (SELECT concat_ws(' ', o.display_name, o.website_url) FROM public.organizations o WHERE o.id=l.organization_id AND o.is_active AND o.deleted_at IS NULL),
  led.event_name, led.organizer_name, led.venue_name, led.venue_floor_label,
  array_to_string(led.audience_segments, ' '), array_to_string(led.accepted_product_categories, ' '), led.application_instructions,
  CASE WHEN led.price_on_request THEN 'สอบถามราคา price on request' END,
  CASE WHEN led.booth_size_on_request THEN 'สอบถามขนาดบูธ booth size on request' END,
  (SELECT concat_ws(' ', o.display_name, o.website_url) FROM public.listing_organizers o WHERE o.id=led.organizer_id),
  (SELECT string_agg(concat_ws(' ', r.round_label, r.starts_on, r.ends_on, r.price_amount, r.notes), ' ')
   FROM public.listing_event_rounds r WHERE r.listing_id=l.id)
 ), '<[^>]*>', ' ', 'g'), '๐๑๒๓๔๕๖๗๘๙', '0123456789')), '` + strings.ReplaceAll(listingKeywordIgnoredPattern(), "'", "''") + `', '', 'g')`

// PostgreSQL POSIX [:punct:] can classify Thai tone/vowel marks as punctuation,
// depending on the database locale. Use the exact same Unicode tables as Go.
func listingKeywordIgnoredPattern() string {
	var chars strings.Builder
	for _, table := range []*unicode.RangeTable{unicode.Punct, unicode.White_Space, unicode.Cf} {
		for _, span := range table.R16 {
			for r := uint32(span.Lo); r <= uint32(span.Hi); r += uint32(span.Stride) {
				chars.WriteRune(rune(r))
			}
		}
		for _, span := range table.R32 {
			for r := span.Lo; r <= span.Hi; r += span.Stride {
				chars.WriteRune(rune(r))
			}
		}
	}
	return "[" + strings.NewReplacer(`\`, `\\`, `]`, `\]`, `[`, `\[`, `^`, `\^`, `-`, `\-`).Replace(chars.String()) + "]+"
}

// Display labels for structured values. Only values actually present in a public
// field contribute these words; false/no feature flags never add positive labels.
const listingKeywordLabelsSQL = `'{
 "fully_furnished":"เฟอร์นิเจอร์ครบ พร้อมเฟอร์นิเจอร์ ครบ พร้อมอยู่ fully furnished",
 "partly_furnished":"เฟอร์นิเจอร์บางส่วน partly furnished",
 "unfurnished":"ไม่มีเฟอร์นิเจอร์ unfurnished",
 "new":"ใหม่ สร้างเสร็จใหม่ newly completed", "like_new":"สภาพเหมือนใหม่ like new",
 "good":"สภาพดี พร้อมใช้งาน good ready to use", "needs_renovation":"ควรปรับปรุง needs renovation",
 "under_construction":"อยู่ระหว่างก่อสร้าง under construction",
 "vacant":"ว่าง พร้อมใช้งาน vacant", "owner_operated":"เจ้าของใช้งานอยู่ owner operated",
 "tenant_occupied":"มีผู้เช่าอยู่ tenant occupied", "business_operating":"มีกิจการดำเนินงานอยู่ business operating",
 "freehold":"กรรมสิทธิ์ freehold", "leasehold":"สิทธิการเช่า leasehold", "sublease_right":"สิทธิการเช่าช่วง sublease right",
 "bare_shell":"พื้นที่เปล่า bare shell", "partly_fitted":"ตกแต่งบางส่วน partly fitted",
 "fully_fitted":"ตกแต่งพร้อมใช้ fully fitted", "as_is":"ตามสภาพ as is",
 "retail":"ร้านค้าปลีก retail", "restaurant":"ร้านอาหาร ห้องอาหาร restaurant",
 "cafe":"คาเฟ่ เครื่องดื่ม cafe beverages", "services":"ธุรกิจบริการ services",
 "beauty":"ความงาม ร้านทำผม beauty salon", "clinic":"คลินิก clinic",
 "showroom":"โชว์รูม showroom", "education":"สถาบันสอน กวดวิชา education tutoring",
 "swimming_pool":"สระว่ายน้ำ swimming pool", "fitness":"ฟิตเนส ห้องออกกำลังกาย fitness gym",
 "meeting_room":"ห้องประชุม meeting room", "spa":"สปา spa", "parking":"ที่จอดรถ parking",
 "laundry":"ซักรีด laundry", "shuttle":"รถรับส่ง shuttle", "wifi":"ไวไฟ อินเทอร์เน็ต wifi internet",
 "air_conditioning":"เครื่องปรับอากาศ แอร์ air conditioning", "security":"ระบบรักษาความปลอดภัย รปภ security",
 "elevator":"ลิฟต์ elevator", "has_elevator":"มีลิฟต์ elevator", "has_mezzanine":"มีชั้นลอย mezzanine",
 "signage_space":"พื้นที่ติดป้าย signage", "three_phase_power":"ไฟฟ้า 3 เฟส three phase power",
 "has_pantry":"มีห้องครัว pantry", "electricity_available":"มีไฟฟ้า electricity available",
 "water_available":"มีน้ำประปา water available", "drainage_available":"มีระบบระบายน้ำ drainage available",
 "utilities_included":"รวมค่าน้ำค่าไฟ utilities included", "laundry_available":"มีบริการซักรีด laundry",
 "foreign_tenant_allowed":"รับผู้เช่าต่างชาติ foreign tenants allowed", "private_entrance":"ทางเข้าส่วนตัว private entrance",
 "owner_lives_on_site":"เจ้าของพักอาศัยอยู่ด้วย owner lives on site", "rights_transfer_allowed":"โอนสิทธิ์ได้ rights transfer allowed",
 "common_fee_included":"รวมค่าส่วนกลาง common fee included", "commercial_use_allowed":"อนุญาตใช้เชิงพาณิชย์ commercial use allowed",
 "separate_entrance":"ทางเข้าแยก separate entrance", "cooking_allowed":"ทำอาหารได้ cooking allowed",
 "exhaust_duct_available":"มีท่อดูดควัน exhaust duct", "grease_trap_available":"มีบ่อดักไขมัน grease trap",
 "reception_area":"มีพื้นที่ต้อนรับ reception area", "server_room":"มีห้องเซิร์ฟเวอร์ server room",
 "central_air_conditioning":"แอร์ส่วนกลาง central air conditioning", "raised_floor":"พื้นยก raised floor",
 "access_control":"ระบบควบคุมการเข้าออก access control", "backup_generator":"เครื่องปั่นไฟสำรอง backup generator",
 "freight_elevator":"ลิฟต์ขนสินค้า freight elevator", "water_connection":"จุดต่อน้ำ water connection",
 "fire_sprinkler":"ระบบดับเพลิง สปริงเกลอร์ fire sprinkler", "temperature_controlled":"ควบคุมอุณหภูมิ temperature controlled",
 "wastewater_treatment":"ระบบบำบัดน้ำเสีย wastewater treatment", "air_emission_system":"ระบบบำบัดอากาศ air emission system",
 "hazardous_materials_allowed":"รองรับวัตถุอันตราย hazardous materials allowed",
 "price_on_request":"สอบถามราคา price on request", "booth_size_on_request":"สอบถามขนาดบูธ booth size on request"
}'::jsonb`
