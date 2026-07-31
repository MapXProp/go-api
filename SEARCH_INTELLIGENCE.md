# MapXProp Search Intelligence

The public search accepts one natural-language query. The UI never requires a
buyer to choose offer type, property type or budget before seeing results.

## API

- `GET /apix/search/suggestions?q=คอน` — autocomplete and popular searches
- `GET /apix/search/interpret?q=คอนโดอารีย์` — inspect the parsed intent
- `GET /apix/properties/search?q=คอนโดอารีย์` — interpreted intent and listings

The search response includes `intent.chips`, which is the user-facing explanation
of what the parser understood. If no offer intent is found, results include every
offer type. The result page may then offer lightweight Buy, Rent and Transfer
refinements.

## Database

- `search_locations` stores provinces, districts, neighborhoods, transit and projects.
- `search_aliases` maps natural phrases to canonical taxonomy codes.
- `listings.search_text` is refreshed by a trigger and indexed with `pg_trgm`.
- `search_query_events` records parsed searches and zero-result queries for tuning.
- `schema_migrations` records embedded migrations applied by the Go API at startup.

Add aliases and locations in a new migration. Never edit an already deployed
migration as a way to update production data.

## Parser strategy

The deterministic parser handles Thai/English aliases, Thai digits, locations,
offer types, price ranges, bedrooms and selected features. This layer remains
available even if an AI service is unavailable. A future AI fallback should only
handle low-confidence queries and must return the same intent contract.
