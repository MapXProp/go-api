package handlers

import (
	"strings"
	"testing"
)

func TestValidateAccountPassword(t *testing.T) {
	valid := []string{"MapxProp!2026", "รหัสAa1!ผ่าน"}
	for _, password := range valid {
		if err := validateAccountPassword(password); err != nil {
			t.Fatalf("expected %q to be valid, got %v", password, err)
		}
	}

	invalid := []string{"Sho1!x", "alllowercase1!", "ALLUPPERCASE1!", "NoNumber!", "NoSpecial1"}
	for _, password := range invalid {
		if err := validateAccountPassword(password); err == nil {
			t.Fatalf("expected %q to be invalid", password)
		}
	}
}

func TestValidateProfileName(t *testing.T) {
	if err := validateProfileName(strings.Repeat("a", 120), "name"); err != nil {
		t.Fatalf("120-character name should be valid: %v", err)
	}
	if err := validateProfileName(strings.Repeat("a", 121), "name"); err == nil {
		t.Fatal("121-character name should be rejected")
	}
}
