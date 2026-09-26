package handlers

import "testing"

func TestNormalizeApartmentBuildingAndMonthlyRooms(t *testing.T) {
	for _, test := range []struct {
		name, propertyType, channel, scope, model, wantType, wantModel, wantSubtype string
	}{
		{"legacy business", "apartment", "business", "whole_property", "standard", "hotel_resort", "", "apartment"},
		{"building without channel", "apartment", "", "whole_property", "standard", "hotel_resort", "", "apartment"},
		{"serviced building", "serviced_apartment", "business", "whole_property", "", "hotel_resort", "", "serviced_residence"},
		{"monthly room", "apartment", "rooms", "single_unit", "standard", "apartment", "standard", ""},
		{"monthly portfolio", "apartment", "rooms", "multi_unit", "standard", "apartment", "standard", ""},
		{"serviced monthly room", "serviced_apartment", "rooms", "single_unit", "", "apartment", "serviced", ""},
		{"room without explicit scope", "apartment", "rooms", "", "standard", "apartment", "standard", ""},
	} {
		t.Run(test.name, func(t *testing.T) {
			req := createListingRequest{PropertyTypeCode: test.propertyType, DiscoveryChannelCode: test.channel,
				PropertyGroupCode: "residential", ListingScope: test.scope, AccommodationModel: test.model,
				UsageType: "residence", UseCaseCodes: []string{"residential"}, Title: "Existing title", SalePrice: "1000000",
				CategoryDetails: map[string]any{"total_units": "20", "source_note": "keep me"}}
			req.normalize()
			if req.PropertyTypeCode != test.wantType || req.AccommodationModel != test.wantModel {
				t.Fatalf("classification: type=%q model=%q", req.PropertyTypeCode, req.AccommodationModel)
			}
			if test.wantSubtype != "" && (req.CategoryDetails["hospitality_property_type"] != test.wantSubtype ||
				req.DiscoveryChannelCode != "business" || req.PropertyGroupCode != "commercial" ||
				req.UsageType != "business" || len(req.UseCaseCodes) != 1 || req.UseCaseCodes[0] != "hospitality") {
				t.Fatalf("incomplete hospitality conversion: %+v", req)
			}
			if test.wantSubtype == "" && req.CategoryDetails["hospitality_property_type"] != nil {
				t.Fatal("monthly room was converted to a business")
			}
			if req.Title != "Existing title" || req.SalePrice != "1000000" || req.CategoryDetails["source_note"] != "keep me" || req.CategoryDetails["total_units"] != "20" {
				t.Fatal("conversion changed unrelated listing data")
			}
		})
	}
}
