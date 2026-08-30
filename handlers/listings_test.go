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

func TestCreateListingValidateRejectsMoreThanTwoSpaceTypes(t *testing.T) {
	req := createListingRequest{
		PropertyGroupCode: "commercial",
		PropertyTypeCode:  "retail_space",
		ListingScope:      "space_slot",
		UsageType:         "business",
		ListingType:       "rent",
		Title:             "Retail space",
		ProvinceName:      "Bangkok",
		Latitude:          "13.7563",
		Longitude:         "100.5018",
		SpaceTypeCodes: []string{
			"mall_kiosk",
			"event_booth",
			"market_stall",
		},
	}

	if err := req.validate(); err == nil {
		t.Fatal("expected more than two space types to be rejected")
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
		ProvinceName:      "Bangkok",
		Latitude:          "13.7563",
		Longitude:         "100.5018",
	}

	if err := req.validate(); err != nil {
		t.Fatalf("unexpected validation error: %v", err)
	}
}

func TestCreateListingNormalizeKeepsTypedMediaAndContactChannels(t *testing.T) {
	req := createListingRequest{
		PropertyTypeCode: "condo",
		Title:            "Condo near transit",
		InstagramHandle:  "https://www.instagram.com/MapX.Prop/",
		MediaItems: []listingMediaInput{
			{URL: "/apix/listing-media/files/12/cover.jpg", MediaType: "image"},
			{URL: "/apix/listing-media/files/12/tour.mp4", MediaType: "video"},
			{URL: "/apix/listing-media/files/12/room.webp", MediaType: "360"},
			{URL: "https://example.com/not-owned.jpg", MediaType: "image"},
		},
	}

	req.normalize()

	if req.InstagramHandle != "mapx.prop" {
		t.Fatalf("Instagram handle: %q", req.InstagramHandle)
	}
	if len(req.MediaItems) != 3 {
		t.Fatalf("media items: %#v", req.MediaItems)
	}
}

func TestCreateListingValidateRejectsMoreThanFourVideos(t *testing.T) {
	req := createListingRequest{
		PropertyGroupCode: "residential",
		PropertyTypeCode:  "condo",
		ListingScope:      "single_unit",
		UsageType:         "residence",
		ListingType:       "rent",
		Title:             "Condo",
		ProvinceName:      "Bangkok",
		Latitude:          "13.7563",
		Longitude:         "100.5018",
	}
	for index := 0; index < 5; index++ {
		req.MediaItems = append(req.MediaItems, listingMediaInput{
			URL:       "/apix/listing-media/files/12/video-" + string(rune('a'+index)) + ".mp4",
			MediaType: "video",
		})
	}

	if err := req.validate(); err == nil {
		t.Fatal("expected more than four videos to be rejected")
	}
}
