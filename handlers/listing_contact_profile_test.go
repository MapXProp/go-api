package handlers

import "testing"

func TestListingContactProfileNormalizePreservesChannelsWhenRoleChanges(t *testing.T) {
	req := listingContactProfileRequest{
		ContactName:         "  Mapx Prop  ",
		ContactPhone:        " 081-234-5678 ",
		ContactEmail:        " contact@example.com ",
		InstagramHandle:     " @mapxprop ",
		RoleCode:            " OWNER_REPRESENTATIVE ",
		AuthoritySourceCode: " PROPERTY_OWNER ",
	}
	req.normalize()

	if req.ContactName != "Mapx Prop" || req.ContactPhone != "081-234-5678" || req.ContactEmail != "contact@example.com" {
		t.Fatalf("contact channels changed unexpectedly: %+v", req)
	}
	if req.RoleCode != "owner_representative" || req.AuthoritySourceCode != "property_owner" {
		t.Fatalf("contact role normalization mismatch: %+v", req)
	}
	if req.InstagramHandle != "mapxprop" {
		t.Fatalf("Instagram normalization mismatch: %q", req.InstagramHandle)
	}
	if err := req.validate(); err != nil {
		t.Fatalf("expected valid contact profile: %v", err)
	}
}

func TestListingContactProfileOwnerAlwaysUsesSelfAuthority(t *testing.T) {
	req := listingContactProfileRequest{
		ContactName:         "Owner",
		ContactPhone:        "0812345678",
		RoleCode:            "owner",
		AuthoritySourceCode: "property_owner",
	}
	req.normalize()
	if req.AuthoritySourceCode != "self" {
		t.Fatalf("owner authority mismatch: %q", req.AuthoritySourceCode)
	}
	if err := req.validate(); err != nil {
		t.Fatalf("expected valid owner contact profile: %v", err)
	}
}

func TestListingContactProfileRejectsMissingRequiredOrganization(t *testing.T) {
	req := listingContactProfileRequest{
		ContactName:         "Agent",
		ContactPhone:        "0812345678",
		RoleCode:            "agency_broker",
		AuthoritySourceCode: "brokerage_company",
	}
	req.normalize()
	if err := req.validate(); err == nil {
		t.Fatal("expected agency broker without organization to be rejected")
	}
}
