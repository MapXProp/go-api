// Executes the production migration/function on isolated PostgreSQL (PGlite).
// Set PGLITE_MODULE_PATH to an installed @electric-sql/pglite/dist/index.js.
import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';
import test from 'node:test';
const { PGlite } = await import(pathToFileURL(process.env.PGLITE_MODULE_PATH).href);

test('public opening counts persist, refreshes count, and retries are idempotent', async (t) => {
  const db = new PGlite();
  t.after(() => db.close());
  await db.exec(`CREATE TABLE public.listings (
    id bigserial PRIMARY KEY, public_listing_id uuid UNIQUE NOT NULL,
    published_at timestamptz DEFAULT now(), is_active boolean DEFAULT true,
    deleted_at timestamptz, listing_status text DEFAULT 'active',
    moderation_status text DEFAULT 'approved', expires_at timestamptz,
    updated_at timestamptz DEFAULT '2026-09-01T00:00:00Z'
  );`);
  await db.exec(await readFile(new URL('../database/migrations/0156_listing_views.sql', import.meta.url), 'utf8'));
  const listing = randomUUID();
  const second = randomUUID();
  await db.query('INSERT INTO listings(public_listing_id) VALUES($1),($2)', [listing, second]);
  const open = async (id, event = randomUUID(), source = 'listing_page') =>
    (await db.query('SELECT * FROM record_listing_view($1,$2,$3)', [id, event, source])).rows;

  assert.equal(Number((await db.query('SELECT view_count FROM listings WHERE public_listing_id=$1',[listing])).rows[0].view_count), 0);
  const event = randomUUID();
  assert.deepEqual(await open(listing, event, 'map_preview'), [{ view_count: 1, counted: true }]);
  assert.deepEqual(await open(listing, event, 'map_preview'), [{ view_count: 1, counted: false }]);
  assert.deepEqual(await open(listing), [{ view_count: 2, counted: true }]);
  assert.deepEqual(await open(listing), [{ view_count: 3, counted: true }]);
  assert.deepEqual(await open(listing, randomUUID(), 'map_modal'), [{ view_count: 4, counted: true }]);
  assert.deepEqual(await open(second), [{ view_count: 1, counted: true }]);
  assert.equal((await db.query('SELECT count(*)::int n FROM listing_view_events')).rows[0].n, 5);
  assert.equal(new Date((await db.query('SELECT updated_at FROM listings LIMIT 1')).rows[0].updated_at).toISOString(), '2026-09-01T00:00:00.000Z');

  await db.exec('BEGIN');
  await open(listing);
  await db.exec('ROLLBACK');
  assert.equal(Number((await db.query('SELECT view_count FROM listings WHERE public_listing_id=$1',[listing])).rows[0].view_count), 4);

  for (const state of ["published_at=NULL", "is_active=false", "deleted_at=now()", "listing_status='inactive'", "moderation_status='rejected'", "expires_at=now()-interval '1 second'"]) {
    await db.exec('BEGIN');
    await db.query(`UPDATE listings SET ${state} WHERE public_listing_id=$1`, [listing]);
    assert.deepEqual(await open(listing), [], state);
    await db.exec('ROLLBACK');
  }
  assert.deepEqual(await open(randomUUID()), []);
  await assert.rejects(open(listing, randomUUID(), 'card'));
  await assert.rejects(open(listing, '00000000-0000-0000-0000-000000000000'));
  await db.query('DELETE FROM listings WHERE public_listing_id=$1', [listing]);
  assert.equal((await db.query('SELECT count(*)::int n FROM listing_view_events')).rows[0].n, 1);
});
