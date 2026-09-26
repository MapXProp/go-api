package handlers

import (
	"fmt"
	"math"
	"regexp"
	"strconv"
	"strings"
)

var listingPublishEmailPattern = regexp.MustCompile(`^[^\s@]+@[^\s@]+\.[^\s@]+$`)

// Publishing enforces these requirements even when the wizard is bypassed.
// Drafts remain saveable without completing the required fields.
func (req createListingRequest) validatePublishRequirements() error {
	if len([]rune(req.Title)) > 160 {
		return fmt.Errorf("listing title must not exceed 160 characters")
	}
	// An edit that does not replace media retains its previously stored images.
	if req.EditingPublicListingID == "" || req.ReplaceMedia {
		hasPhoto := false
		for _, media := range req.MediaItems {
			if media.MediaType == "image" && strings.TrimSpace(media.URL) != "" {
				hasPhoto = true
				break
			}
		}
		if !hasPhoto {
			return fmt.Errorf("at least one property photo is required")
		}
	}
	if req.ContactName == "" {
		return fmt.Errorf("contact name is required")
	}
	if req.ContactPhone == "" {
		return fmt.Errorf("contact phone is required")
	}
	if req.ContactRoleCode == "" {
		return fmt.Errorf("contact role is required")
	}
	if req.ContactEmail != "" && !listingPublishEmailPattern.MatchString(req.ContactEmail) {
		return fmt.Errorf("invalid contact email")
	}
	if !req.PriceOnRequest {
		for _, field := range []struct {
			name     string
			value    string
			required bool
		}{
			{"sale price", req.SalePrice, inSet("sale", req.OfferTypes...)},
			{"monthly rent", req.RentPriceMonthly, !req.isRetailSpace() && (inSet("rent", req.OfferTypes...) || inSet("sublease", req.OfferTypes...))},
			{"transfer price", req.KeyMoneyAmount, inSet("business_transfer", req.OfferTypes...)},
			{"daily rent", req.RentPriceDaily, false},
			{"service fee", req.ServiceFeeMonthly, false},
		} {
			if strings.TrimSpace(field.value) == "" {
				if field.required {
					return fmt.Errorf("%s is required", field.name)
				}
				continue
			}
			parsed, err := strconv.ParseFloat(strings.TrimSpace(strings.ReplaceAll(field.value, ",", "")), 64)
			if err != nil || math.IsInf(parsed, 0) || math.IsNaN(parsed) || parsed < 0 {
				return fmt.Errorf("invalid %s", field.name)
			}
		}
	}
	return nil
}
