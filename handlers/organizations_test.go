package handlers

import "testing"

func TestOrganizationRoleAtLeast(t *testing.T) {
	tests := []struct {
		role     string
		required string
		want     bool
	}{
		{"owner", "admin", true},
		{"admin", "publisher", true},
		{"publisher", "publisher", true},
		{"editor", "publisher", false},
		{"viewer", "editor", false},
		{"", "viewer", false},
	}
	for _, test := range tests {
		if got := organizationRoleAtLeast(test.role, test.required); got != test.want {
			t.Fatalf("organizationRoleAtLeast(%q, %q) = %v, want %v", test.role, test.required, got, test.want)
		}
	}
}

func TestOrganizationSlug(t *testing.T) {
	tests := map[string]string{
		"KKP Propify":           "kkp-propify",
		"  MapxProp & Friends ": "mapxprop-friends",
		"AGENCY---BANGKOK":      "agency-bangkok",
	}
	for input, want := range tests {
		if got := organizationSlug(input); got != want {
			t.Fatalf("organizationSlug(%q) = %q, want %q", input, got, want)
		}
	}
	if got := organizationSlug("องค์กรไทย"); len(got) < len("organization-") {
		t.Fatalf("organizationSlug fallback = %q", got)
	}
}

func TestValidateOrganizationContact(t *testing.T) {
	valid := []organizationContactInput{
		{ChannelType: "phone", ChannelValue: "02-165-5555"},
		{ChannelType: "email", ChannelValue: "team@example.com"},
		{ChannelType: "line", ChannelValue: "@mapxprop"},
		{ChannelType: "website", ChannelValue: "https://example.com/contact"},
	}
	for _, contact := range valid {
		if err := validateOrganizationContact(contact); err != nil {
			t.Fatalf("valid contact %#v returned %v", contact, err)
		}
	}

	invalid := []organizationContactInput{
		{ChannelType: "fax", ChannelValue: "021655555"},
		{ChannelType: "phone", ChannelValue: "123"},
		{ChannelType: "email", ChannelValue: "not-an-email"},
		{ChannelType: "website", ChannelValue: "javascript:alert(1)"},
	}
	for _, contact := range invalid {
		if err := validateOrganizationContact(contact); err == nil {
			t.Fatalf("invalid contact %#v was accepted", contact)
		}
	}
}

func TestNormalizeOrganizationSpecialties(t *testing.T) {
	got, err := normalizeOrganizationSpecialties([]string{" Condo ", "sale", "condo"})
	if err != nil {
		t.Fatal(err)
	}
	if len(got) != 2 || got[0] != "condo" || got[1] != "sale" {
		t.Fatalf("unexpected specialties: %#v", got)
	}
	if _, err := normalizeOrganizationSpecialties([]string{"anything"}); err == nil {
		t.Fatal("unknown specialty was accepted")
	}
}

func TestNormalizeOrganizationIdentifier(t *testing.T) {
	valid := []string{"kkppropify", "bank-npa", "b84e97c5-f08d-49e7-b87e-3dd454e22a6d"}
	for _, input := range valid {
		if _, err := normalizeOrganizationIdentifier(input); err != nil {
			t.Fatalf("valid identifier %q returned %v", input, err)
		}
	}
	invalid := []string{"", "../kkp", "KKP Propify", "องค์กร"}
	for _, input := range invalid {
		if _, err := normalizeOrganizationIdentifier(input); err == nil {
			t.Fatalf("invalid identifier %q was accepted", input)
		}
	}
}
