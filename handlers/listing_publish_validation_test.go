package handlers

import (
	"strings"
	"testing"
)

func publishableListingRequest() createListingRequest {
	req := validCurrentWizardListingRequest()
	req.OfferTypes = []string{"rent"}
	req.RentPriceMonthly = "12000"
	req.ContactName = "Owner"
	req.ContactPhone = "0812345678"
	req.ContactRoleCode = "owner"
	req.MediaItems = []listingMediaInput{{URL: "/apix/listing-media/files/12/photo.jpg", MediaType: "image"}}
	req.normalize()
	return req
}

func TestPublishRequiredFields(t *testing.T) {
	for _, tc := range []struct {
		name   string
		change func(*createListingRequest)
		want   string
	}{
		{"empty title", func(r *createListingRequest) { r.Title = "   " }, "title is required"},
		{"long title", func(r *createListingRequest) { r.Title = strings.Repeat("ก", 161) }, "160 characters"},
		{"missing coordinates", func(r *createListingRequest) { r.Latitude = "" }, "latitude and longitude"},
		{"invalid coordinates", func(r *createListingRequest) { r.Longitude = "NaN" }, "latitude and longitude"},
		{"no photo", func(r *createListingRequest) { r.MediaItems = nil }, "photo is required"},
		{"video only", func(r *createListingRequest) {
			r.MediaItems = []listingMediaInput{{URL: "/video.mp4", MediaType: "video"}}
		}, "photo is required"},
		{"panorama only", func(r *createListingRequest) {
			r.MediaItems = []listingMediaInput{{URL: "/pano.jpg", MediaType: "360"}}
		}, "photo is required"},
		{"empty media URL", func(r *createListingRequest) { r.MediaItems = []listingMediaInput{{URL: " ", MediaType: "image"}} }, "photo is required"},
		{"no contact", func(r *createListingRequest) { r.ContactName = " " }, "contact name is required"},
		{"no phone", func(r *createListingRequest) { r.ContactPhone = "" }, "contact phone is required"},
		{"no role", func(r *createListingRequest) { r.ContactRoleCode = "" }, "contact role is required"},
		{"bad email", func(r *createListingRequest) { r.ContactEmail = "invalid@" }, "invalid contact email"},
		{"missing rent", func(r *createListingRequest) { r.RentPriceMonthly = "" }, "monthly rent is required"},
		{"infinite price", func(r *createListingRequest) { r.RentPriceMonthly = "Infinity" }, "invalid monthly rent"},
		{"negative price", func(r *createListingRequest) { r.RentPriceMonthly = "-1" }, "invalid monthly rent"},
		{"infinite area", func(r *createListingRequest) { r.UsableAreaSqm = "Infinity" }, "usable area"},
		{"remove last photo", func(r *createListingRequest) {
			r.EditingPublicListingID = "existing"
			r.ReplaceMedia = true
			r.MediaItems = nil
		}, "photo is required"},
	} {
		t.Run(tc.name, func(t *testing.T) {
			req := publishableListingRequest()
			tc.change(&req)
			req.normalize()
			err := req.validate()
			if err == nil {
				err = req.validatePublishRequirements()
			}
			if err == nil || !strings.Contains(err.Error(), tc.want) {
				t.Fatalf("got %v, want %s", err, tc.want)
			}
		})
	}
}

func TestPublishAllowsPhotoAndRetainsExistingMedia(t *testing.T) {
	req := publishableListingRequest()
	for _, change := range []func(*createListingRequest){
		func(r *createListingRequest) {},
		func(r *createListingRequest) { r.PriceOnRequest = true; r.RentPriceMonthly = "" },
		func(r *createListingRequest) {
			r.EditingPublicListingID = "existing"
			r.ReplaceMedia = false
			r.MediaItems = nil
		},
	} {
		change(&req)
		if err := req.validatePublishRequirements(); err != nil {
			t.Fatal(err)
		}
	}
}
