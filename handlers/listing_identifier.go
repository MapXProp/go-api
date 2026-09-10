package handlers

import "github.com/google/uuid"

// Match either the canonical slug or a stable public ID without casting the
// indexed database UUID column to text. Internal numeric IDs are not permalinks.
func listingIdentifierPredicate(identifier string, arg func(any) string) string {
	slugArg := arg(identifier)
	if publicID, err := uuid.Parse(identifier); err == nil {
		return "(l.slug = " + slugArg + " OR l.public_listing_id = " + arg(publicID.String()) + "::uuid)"
	}
	return "l.slug = " + slugArg
}
