package handlers

import "github.com/lib/pq"

// Apartment keywords and old links also find buildings now filed under hospitality.
// The channel filter still separates monthly rooms from whole-building businesses.
func propertyTypeSearchPredicate(types []string, arg func(any) string) string {
	predicate := "l.property_type_code = ANY(" + arg(pq.Array(types)) + ")"
	if inSet("apartment", types...) {
		predicate = "(" + predicate + ` OR (l.property_type_code = 'hotel_resort' AND EXISTS (
			SELECT 1 FROM public.listing_category_details apartment_details
			WHERE apartment_details.listing_id = l.id
			  AND apartment_details.details->>'hospitality_property_type' IN ('apartment', 'serviced_residence')
		)))`
	}
	return predicate
}
