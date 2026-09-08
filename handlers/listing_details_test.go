package handlers

import "testing"

func TestHideInternalListingMetadata(t *testing.T) {
	details := map[string]any{
		"bedrooms":              3,
		"source_property_id":    "TP2206058",
		"source_agent_verified": true,
		"data_provenance":       "private import metadata",
	}

	hideInternalListingMetadata(details)

	if _, ok := details["source_property_id"]; ok {
		t.Fatal("source_property_id must not be public")
	}
	if _, ok := details["source_agent_verified"]; ok {
		t.Fatal("source_agent_verified must not be public")
	}
	if _, ok := details["data_provenance"]; ok {
		t.Fatal("data_provenance must not be public")
	}
	if details["bedrooms"] != 3 {
		t.Fatalf("public listing detail was removed: %#v", details)
	}
}
