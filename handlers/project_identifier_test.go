package handlers

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestProjectIdentifierUsesExactParameterizedMembership(t *testing.T) {
	for _, id := range []string{"the-address-sathorn", "17736F55-F29A-4A58-8EB6-72B363B2641C", "x' OR true --"} {
		args := []any{}
		predicate := projectIdentifierPredicate(id, func(value any) string { args = append(args, value); return fmt.Sprintf("$%d", len(args)) })
		if args[0] != id || strings.Contains(predicate, id) || !strings.Contains(predicate, "project.slug = $1") {
			t.Fatalf("unsafe or broad predicate: %s %#v", predicate, args)
		}
		if len(args) == 2 && (args[1] != "17736f55-f29a-4a58-8eb6-72b363b2641c" || !strings.Contains(predicate, "project.public_project_id = $2::uuid")) {
			t.Fatalf("UUID mismatch: %s %#v", predicate, args)
		}
	}
}

func TestEmptyProjectNeverFallsBackToAllListings(t *testing.T) {
	app := fiber.New()
	app.Get("/search", SearchProperties(nil))
	for _, value := range []string{"", "%20", strings.Repeat("x", 201)} {
		response, err := app.Test(httptest.NewRequest("GET", "/search?project="+value, nil))
		if err != nil || response.StatusCode != 400 {
			t.Fatalf("empty/invalid project was not rejected: %#v %v", response, err)
		}
		response.Body.Close()
	}
}
