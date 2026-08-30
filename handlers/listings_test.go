package handlers

import "testing"

func TestCreateListingNormalizeKeepsPrimarySpaceTypeFirst(t *testing.T) {
	req := createListingRequest{
		PropertyTypeCode: "retail_space",
		Title:            "Event booth in a mall",
		SpaceTypeCode:    "event_booth",
		SpaceTypeCodes:   []string{"mall_kiosk", "event_booth", "mall_kiosk"},
	}

	req.normalize()

	want := []string{"event_booth", "mall_kiosk"}
	if len(req.SpaceTypeCodes) != len(want) {
		t.Fatalf("space types: %#v", req.SpaceTypeCodes)
	}
	for index := range want {
		if req.SpaceTypeCodes[index] != want[index] {
			t.Fatalf("space types: %#v", req.SpaceTypeCodes)
		}
	}
}

func TestCreateListingValidateRejectsMoreThanThreeSpaceTypes(t *testing.T) {
	req := createListingRequest{
		PropertyGroupCode: "commercial",
		PropertyTypeCode:  "retail_space",
		ListingScope:      "space_slot",
		UsageType:         "business",
		ListingType:       "rent",
		Title:             "Retail space",
		SpaceTypeCodes: []string{
			"mall_kiosk",
			"event_booth",
			"market_stall",
			"standalone_shop",
		},
	}

	if err := req.validate(); err == nil {
		t.Fatal("expected more than three space types to be rejected")
	}
}

func TestCreateListingValidateAcceptsOverlappingRetailSpaceTypes(t *testing.T) {
	req := createListingRequest{
		PropertyGroupCode: "commercial",
		PropertyTypeCode:  "retail_space",
		ListingScope:      "space_slot",
		UsageType:         "business",
		ListingType:       "event_booking",
		Title:             "Event booth in a mall",
		UseCaseCodes:      []string{"retail"},
		OfferTypes:        []string{"event_booking"},
		SpaceTypeCode:     "mall_kiosk",
		SpaceTypeCodes:    []string{"mall_kiosk", "event_booth"},
	}

	if err := req.validate(); err != nil {
		t.Fatalf("unexpected validation error: %v", err)
	}
}
