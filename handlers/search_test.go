package handlers

import "testing"

func TestInterpretSearchThaiNaturalLanguage(t *testing.T) {
	aliases := []searchAlias{
		{Phrase: "ร้าน", IntentType: "property_type", IntentValue: "retail_space"},
		{Phrase: "เช่า", IntentType: "offer_type", IntentValue: "rent"},
	}
	locations := []searchLocation{{ID: 1, Code: "neighborhood-siam", NameTH: "สยาม", NameEN: "Siam", Aliases: []string{"siam"}}}
	intent := interpretSearch("ร้านให้เช่าสยามไม่เกิน 50,000", aliases, locations)
	if len(intent.PropertyTypes) != 1 || intent.PropertyTypes[0] != "retail_space" {
		t.Fatalf("property type: %#v", intent.PropertyTypes)
	}
	if len(intent.OfferTypes) != 1 || intent.OfferTypes[0] != "rent" {
		t.Fatalf("offer type: %#v", intent.OfferTypes)
	}
	if len(intent.Locations) != 1 || intent.Locations[0].Code != "neighborhood-siam" {
		t.Fatalf("locations: %#v", intent.Locations)
	}
	if intent.MaxPrice == nil || *intent.MaxPrice != 50000 {
		t.Fatalf("max price: %#v", intent.MaxPrice)
	}
}

func TestInterpretSearchPriceRangeAndThaiDigits(t *testing.T) {
	aliases := []searchAlias{{Phrase: "คอนโด", IntentType: "property_type", IntentValue: "condo"}}
	intent := interpretSearch("คอนโด ๒ ห้องนอน งบ 3-5 ล้าน", aliases, nil)
	if intent.Bedrooms == nil || *intent.Bedrooms != 2 {
		t.Fatalf("bedrooms: %#v", intent.Bedrooms)
	}
	if intent.MinPrice == nil || *intent.MinPrice != 3000000 {
		t.Fatalf("min: %#v", intent.MinPrice)
	}
	if intent.MaxPrice == nil || *intent.MaxPrice != 5000000 {
		t.Fatalf("max: %#v", intent.MaxPrice)
	}
}

func TestInterpretSearchUsesQueryLanguageForChips(t *testing.T) {
	aliases := []searchAlias{
		{Phrase: "โกดัง", IntentType: "property_type", IntentValue: "warehouse", Locale: "th", Priority: 100},
		{Phrase: "warehouse", IntentType: "property_type", IntentValue: "warehouse", Locale: "en", Priority: 100},
	}
	locations := []searchLocation{{ID: 1, Code: "neighborhood-bang-na", NameTH: "บางนา", NameEN: "Bang Na", Aliases: []string{"bang na"}}}
	intent := interpretSearch("warehouse Bang Na", aliases, locations)
	if intent.Locale != "en" {
		t.Fatalf("locale: %s", intent.Locale)
	}
	if len(intent.Chips) < 2 || intent.Chips[0].Label != "warehouse" || intent.Chips[1].Label != "Bang Na" {
		t.Fatalf("chips: %#v", intent.Chips)
	}
}

func TestInterpretSearchMarketStallAndMultiplePropertyTypes(t *testing.T) {
	aliases := []searchAlias{
		{Phrase: "ล็อกในตลาด", IntentType: "space_type", IntentValue: "market_stall", Locale: "th", Priority: 110},
		{Phrase: "คอนโด", IntentType: "property_type", IntentValue: "condo", Locale: "th", Priority: 100},
		{Phrase: "โกดัง", IntentType: "property_type", IntentValue: "warehouse", Locale: "th", Priority: 100},
	}
	intent := interpretSearch("ล็อกในตลาด คอนโด โกดัง", aliases, nil)
	if len(intent.SpaceTypes) != 1 || intent.SpaceTypes[0] != "market_stall" {
		t.Fatalf("space types: %#v", intent.SpaceTypes)
	}
	if len(intent.PropertyTypes) != 2 || intent.PropertyTypes[0] != "condo" || intent.PropertyTypes[1] != "warehouse" {
		t.Fatalf("property types: %#v", intent.PropertyTypes)
	}
	if intent.FreeText != "" {
		t.Fatalf("free text: %q", intent.FreeText)
	}
}

func TestInterpretSearchDiscoveryChannel(t *testing.T) {
	aliases := []searchAlias{
		{Phrase: "ห้องเช่ารายเดือน", IntentType: "discovery_channel", IntentValue: "rooms", Locale: "th", Priority: 110},
		{Phrase: "หอพัก", IntentType: "property_type", IntentValue: "dormitory", Locale: "th", Priority: 100},
	}
	intent := interpretSearch("ห้องเช่ารายเดือน หอพัก", aliases, nil)
	if len(intent.DiscoveryChannels) != 1 || intent.DiscoveryChannels[0] != "rooms" {
		t.Fatalf("discovery channels: %#v", intent.DiscoveryChannels)
	}
	if len(intent.PropertyTypes) != 1 || intent.PropertyTypes[0] != "dormitory" {
		t.Fatalf("property types: %#v", intent.PropertyTypes)
	}
	if intent.FreeText != "" {
		t.Fatalf("free text: %q", intent.FreeText)
	}
}
