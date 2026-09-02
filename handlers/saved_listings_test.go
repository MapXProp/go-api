package handlers

import "testing"

func TestCleanSavedListingIdentifier(t *testing.T) {
	tests := []struct {
		name  string
		value string
		want  string
	}{
		{name: "slug", value: "  house-near-bts  ", want: "house-near-bts"},
		{name: "public id", value: "5bb82e76-589f-4ae5-af88-26289f43d841", want: "5bb82e76-589f-4ae5-af88-26289f43d841"},
		{name: "empty", value: "   ", want: ""},
		{name: "path", value: "house/secret", want: ""},
		{name: "too long", value: string(make([]byte, 161)), want: ""},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if got := cleanSavedListingIdentifier(test.value); got != test.want {
				t.Fatalf("cleanSavedListingIdentifier(%q) = %q, want %q", test.value, got, test.want)
			}
		})
	}
}

func TestCleanSavedListingIdentifiersDeduplicates(t *testing.T) {
	got := cleanSavedListingIdentifiers([]string{
		" first-listing ",
		"second-listing",
		"first-listing",
		"bad/path",
		"",
	})
	want := []string{"first-listing", "second-listing"}

	if len(got) != len(want) {
		t.Fatalf("got %v, want %v", got, want)
	}
	for index := range want {
		if got[index] != want[index] {
			t.Fatalf("got %v, want %v", got, want)
		}
	}
}
