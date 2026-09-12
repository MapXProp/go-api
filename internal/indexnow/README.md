# IndexNow delivery

The API starts the durable worker only when `FRONTEND_URL` is exactly
`https://mapxprop.com` (an optional trailing slash is accepted). Localhost and
preview deployments stay disabled. Set `INDEXNOW_ENABLED=false` to pause delivery;
committed notifications remain queued. No search-engine account credentials are
needed. The public ownership key is in the matching frontend `public/*.txt` file.
Keep that file deployed. Do not rotate it without changing both repositories.

Migration 0155 installs transactional triggers for listing publication, edits,
prices, photos, public related details, slug changes and withdrawals/deletions.
Drafts and unapproved records are excluded; formerly public removal URLs are
included. A separate schedule handles expiry without relying on a user save.
Direct SQL imports use the same triggers, unless an importer explicitly disables
database triggers. The API save path makes no IndexNow HTTP requests.

The worker checks once a minute, coalesces each URL for five minutes and sends at
most 100 URLs per batch. It checks the published ownership file first. Network
failures, rate limits and service errors retry with backoff and `Retry-After`.
Malformed URL/key errors are retained with a 24-hour retry. A PostgreSQL advisory
lock coordinates multiple API processes. Network requests hold no listing/outbox
row locks; acknowledgement only covers the revision actually sent, so concurrent
edits remain pending. Accepted queue rows retain delivery evidence.

The initial migration queues only `/homes` and `/real-estate-categories/all`,
which changed in the current SEO release. It does not resubmit all old inventory.
Sitemaps continue to provide complete discovery for Google and Bing. IndexNow
notifies participating engines through one endpoint; it does not guarantee
crawling, indexing or rankings, and is not a Google indexing API.

## Read-only operations

```sql
SELECT path, revision, delivered_revision, last_status, accepted_at,
       attempts, next_attempt_at, last_error
FROM public.indexnow_outbox ORDER BY changed_at DESC LIMIT 100;

SELECT count(*) AS pending FROM public.indexnow_outbox
WHERE revision > delivered_revision;
```

HTTP 200 means received; 202 means received with key validation pending. Both are
accepted notifications, not indexed pages. Look for `[indexnow]` in API logs and
the IndexNow report in Bing Webmaster Tools. A pending queue with no attempts can
mean the worker is disabled, the ownership file is unavailable, or the debounce
has not elapsed.

## Tests

`go test ./internal/indexnow ./...` verifies HTTP protocol, URL allowlisting,
deployment gating, ownership proof, cancellations and retry behavior.

`migration.test.mjs` runs the actual migration and worker SQL in an isolated,
in-memory PostgreSQL engine. Install `@electric-sql/pglite` in a temporary folder,
set `PGLITE_MODULE_PATH` to its `dist/index.js`, then run
`node --test internal/indexnow/migration.test.mjs`. It never reads `.env`, starts a
server or connects to production. It covers private drafts, every related-table
trigger, rollback, renames, withdrawals, concurrent edits during delivery,
debouncing, retry persistence, expiry and deletion.

Protocol: https://www.indexnow.org/documentation
Publishing guidance: https://www.indexnow.org/faq
