package handlers

import "testing"

const validListingDescription = "A complete property description with access, highlights, condition, and important terms."

func TestCreateListingRequiresIdempotencyKeyForNewListings(t *testing.T) {
	if err := (createListingRequest{}).validateSubmissionIdentity(); err == nil {
		t.Fatal("expected a new listing without a submission key to be rejected")
	}
	if err := (createListingRequest{SubmissionKey: "new-listing-request-123"}).validateSubmissionIdentity(); err != nil {
		t.Fatalf("submission key should allow a new listing: %v", err)
	}
	if err := (createListingRequest{EditingPublicListingID: "existing-listing-id"}).validateSubmissionIdentity(); err != nil {
		t.Fatalf("an explicit edit should not require a client submission key: %v", err)
	}
}

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
		Description:       validListingDescription,
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
		Description:       validListingDescription,
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
		Currency:         " thb ",
		Amenities:        []string{"Parking", "air-conditioning", "parking"},
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
	if req.Currency != "THB" {
		t.Fatalf("currency: %q", req.Currency)
	}
	wantAmenities := []string{"parking", "air_conditioning"}
	if len(req.Amenities) != len(wantAmenities) {
		t.Fatalf("amenities: %#v", req.Amenities)
	}
	for index := range wantAmenities {
		if req.Amenities[index] != wantAmenities[index] {
			t.Fatalf("amenities: %#v", req.Amenities)
		}
	}
}

func TestCreateListingNormalizeClearsStaleAmountsForPriceOnRequest(t *testing.T) {
	req := createListingRequest{
		SalePrice:         "9,250,000",
		RentPriceMonthly:  "25,000",
		RentPriceDaily:    "2,000",
		KeyMoneyAmount:    "1,250,000",
		EventBookingPrice: "5,000",
		ServiceFeeMonthly: "1,500",
		PriceNegotiable:   true,
		PriceOnRequest:    true,
		CategoryDetails:   map[string]any{},
	}

	req.normalize()

	if req.SalePrice != "" || req.RentPriceMonthly != "" || req.RentPriceDaily != "" || req.KeyMoneyAmount != "" || req.EventBookingPrice != "" || req.ServiceFeeMonthly != "" {
		t.Fatalf("price-on-request retained stale amounts: %#v", req)
	}
	if req.PriceNegotiable {
		t.Fatal("price-on-request must disable negotiable pricing")
	}
}

func TestCreateListingValidateAcceptsSupportedContactRoles(t *testing.T) {
	cases := []struct {
		role         string
		authority    string
		organization string
	}{
		{role: "owner", authority: "self"},
		{role: "owner_representative", authority: "property_owner"},
		{role: "independent_broker", authority: "co_broker"},
		{role: "agency_broker", authority: "brokerage_company", organization: "MapXProp Realty"},
		{role: "developer_investor_representative", authority: "investor_asset_holder", organization: "MapXProp Capital"},
		{role: "property_manager", authority: "property_management_company"},
	}

	for _, testCase := range cases {
		t.Run(testCase.role, func(t *testing.T) {
			req := validContactRoleListingRequest()
			req.ContactRoleCode = testCase.role
			req.ContactAuthorityCode = testCase.authority
			req.ContactOrganizationName = testCase.organization
			if err := req.validate(); err != nil {
				t.Fatalf("unexpected validation error: %v", err)
			}
		})
	}
}

func TestCreateListingValidateRejectsUnverifiedContactClaimsWithInvalidShape(t *testing.T) {
	req := validContactRoleListingRequest()
	req.ContactRoleCode = "agency_broker"
	req.ContactAuthorityCode = "brokerage_company"
	if err := req.validate(); err == nil {
		t.Fatal("expected agency broker without an organization to be rejected")
	}

	req.ContactRoleCode = "owner_representative"
	req.ContactAuthorityCode = "self"
	if err := req.validate(); err == nil {
		t.Fatal("expected a non-owner self-authority claim to be rejected")
	}

	req.ContactRoleCode = "verified_owner"
	req.ContactAuthorityCode = "property_owner"
	if err := req.validate(); err == nil {
		t.Fatal("expected a client-supplied verified role to be rejected")
	}
}

func validContactRoleListingRequest() createListingRequest {
	return createListingRequest{
		PropertyGroupCode: "residential",
		PropertyTypeCode:  "condo",
		ListingScope:      "single_unit",
		UsageType:         "residence",
		ListingType:       "rent",
		Title:             "Condo with identified contact",
		Description:       validListingDescription,
		ProvinceName:      "Bangkok",
		Latitude:          "13.7563",
		Longitude:         "100.5018",
	}
}

func TestCreateListingValidateRejectsUnknownAmenityAndInvalidCurrency(t *testing.T) {
	base := createListingRequest{
		PropertyGroupCode: "residential",
		PropertyTypeCode:  "condo",
		ListingScope:      "single_unit",
		UsageType:         "residence",
		ListingType:       "rent",
		Title:             "Condo",
		Description:       validListingDescription,
		ProvinceName:      "Bangkok",
		Latitude:          "13.7563",
		Longitude:         "100.5018",
		Currency:          "THB",
		Amenities:         []string{"private_spaceship"},
	}
	if err := base.validate(); err == nil {
		t.Fatal("expected unknown amenity to be rejected")
	}

	base.Amenities = []string{"parking"}
	base.Currency = "BAHT"
	if err := base.validate(); err == nil {
		t.Fatal("expected invalid currency to be rejected")
	}

	base.Currency = "EUR"
	if err := base.validate(); err == nil {
		t.Fatal("expected unsupported currency to be rejected")
	}

	base.Currency = "USD"
	if err := base.validate(); err != nil {
		t.Fatalf("expected USD to be accepted: %v", err)
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
		Description:       validListingDescription,
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

func TestCreateListingValidateAllowsTenImagesAndRejectsEleven(t *testing.T) {
	req := createListingRequest{
		PropertyGroupCode: "residential",
		PropertyTypeCode:  "condo",
		ListingScope:      "single_unit",
		UsageType:         "residence",
		ListingType:       "rent",
		Title:             "Condo",
		Description:       validListingDescription,
		ProvinceName:      "Bangkok",
		Latitude:          "13.7563",
		Longitude:         "100.5018",
	}
	for index := 0; index < maxListingImages; index++ {
		req.MediaItems = append(req.MediaItems, listingMediaInput{
			URL:       "/apix/listing-media/files/12/image-" + string(rune('a'+index)) + ".jpg",
			MediaType: "image",
		})
	}

	if err := req.validate(); err != nil {
		t.Fatalf("expected ten images to be accepted: %v", err)
	}

	req.MediaItems = append(req.MediaItems, listingMediaInput{
		URL:       "/apix/listing-media/files/12/image-k.jpg",
		MediaType: "image",
	})
	if err := req.validate(); err == nil {
		t.Fatal("expected more than ten images to be rejected")
	}
}

func TestCreateListingValidateRequiresDescriptionWithoutAMinimumLength(t *testing.T) {
	req := validCurrentWizardListingRequest()
	req.Description = ""
	if err := req.validate(); err == nil {
		t.Fatal("expected an empty listing description to be rejected")
	}

	req.Description = "สั้น"
	if err := req.validate(); err != nil {
		t.Fatalf("expected a short non-empty listing description to be accepted: %v", err)
	}

	req.Description = validListingDescription
	if err := req.validate(); err != nil {
		t.Fatalf("expected a useful listing description to be accepted: %v", err)
	}
}

func TestCreateListingValidateAllowsEmptyCoreDetails(t *testing.T) {
	req := validCurrentWizardListingRequest()
	req.LandAreaSqm = ""
	req.UsableAreaSqm = ""
	req.BedroomCount = ""
	req.BathroomCount = ""
	req.ParkingCount = ""
	req.FloorNo = ""
	req.TotalFloors = ""
	req.FurnishingStatus = ""

	if err := req.validate(); err != nil {
		t.Fatalf("expected all core-detail fields to be optional: %v", err)
	}
}

func validCurrentWizardListingRequest() createListingRequest {
	return createListingRequest{
		DiscoveryChannelCode: "homes",
		PropertyGroupCode:    "residential",
		PropertyTypeCode:     "condo",
		ListingScope:         "single_unit",
		UsageType:            "residence",
		ListingType:          "rent",
		Title:                "Condo near transit",
		Description:          validListingDescription,
		UsableAreaSqm:        "48.5",
		BedroomCount:         "0",
		BathroomCount:        "1",
		FloorNo:              "5",
		FurnishingStatus:     "unfurnished",
		ProvinceName:         "Bangkok",
		Latitude:             "13.7563",
		Longitude:            "100.5018",
	}
}
