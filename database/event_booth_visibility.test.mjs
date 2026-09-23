// Isolated PostgreSQL-engine checks; never reads .env or connects to a server.
// Set PGLITE_MODULE_PATH to an installed @electric-sql/pglite/dist/index.js.
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';
import test from 'node:test';

const { PGlite } = process.env.PGLITE_MODULE_PATH
  ? await import(pathToFileURL(process.env.PGLITE_MODULE_PATH).href)
  : await import('@electric-sql/pglite');
const migration = await readFile(new URL('./migrations/0175_keep_existing_event_booths_visible.sql', import.meta.url), 'utf8');
const searchSource = await readFile(new URL('../handlers/search.go', import.meta.url), 'utf8');

test('existing approved events remain visible while schedules and other listing states are preserved', async () => {
  const db = new PGlite();
  try {
    await db.exec(`CREATE TABLE listings (
      id integer PRIMARY KEY, slug text NOT NULL, property_type_code text DEFAULT 'retail_space',
      space_type_code text DEFAULT 'event_booth', published_at timestamptz DEFAULT '2026-08-18',
      deleted_at timestamptz, is_active boolean DEFAULT true, listing_status text DEFAULT 'active',
      moderation_status text DEFAULT 'approved', expires_at timestamptz DEFAULT '2020-01-01',
      updated_at timestamptz DEFAULT '2026-09-15'
    );
    CREATE TABLE listing_event_rounds (
      listing_id integer, starts_on date, ends_on date, availability_status text
    );
    INSERT INTO listings (id,slug) VALUES
      (1,'local-favorites-emsphere-2026'), (2,'food-o-clock-the-empire-tower-2026'),
      (3,'unrelated-event'), (4,'expired-house');
    UPDATE listings SET expires_at='2099-01-01' WHERE id=2;
    UPDATE listings SET property_type_code='detached_house',space_type_code=NULL WHERE id=4;
    INSERT INTO listing_event_rounds VALUES
      (1,'2026-09-11','2026-09-22','closed'), (2,'2026-09-28','2026-10-02','open');`);

    // The same target slug must not override any independent visibility guard.
    const guarded = [
      ['published_at', 'NULL'], ['deleted_at', "'2026-09-01'"], ['is_active', 'false'],
      ['listing_status', "'pending'"], ['moderation_status', "'rejected'"],
      ['property_type_code', "'office'"], ['space_type_code', "'mall_kiosk'"],
    ];
    for (const [index, [column, value]] of guarded.entries()) {
      await db.exec(`INSERT INTO listings (id,slug,${column}) VALUES (${index+10},'local-favorites-emsphere-2026',${value})`);
    }
    const before = (await db.query('SELECT * FROM listings ORDER BY id')).rows;
    const rounds = (await db.query('SELECT * FROM listing_event_rounds ORDER BY listing_id')).rows;
    await db.exec(migration);
    const after = (await db.query('SELECT * FROM listings ORDER BY id')).rows;
    assert.deepEqual(after, before.map(row => [1,2].includes(row.id) ? { ...row, expires_at: null } : row));
    assert.deepEqual((await db.query('SELECT * FROM listing_event_rounds ORDER BY listing_id')).rows, rounds);
    assert.deepEqual((await db.query(`SELECT id FROM listings WHERE published_at IS NOT NULL
      AND deleted_at IS NULL AND is_active AND listing_status='active' AND moderation_status='approved'
      AND (expires_at IS NULL OR expires_at>now()) ORDER BY id`)).rows.map(row => row.id), [1,2]);
    await db.exec(migration);
    assert.deepEqual((await db.query('SELECT * FROM listings ORDER BY id')).rows, after, 'Reapplying is harmless');
  } finally {
    await db.close();
  }
});

test('search summaries include past rounds when automatic expiry is disabled', async () => {
  const db = new PGlite();
  try {
    await db.exec(`CREATE TABLE listings (id integer, expires_at timestamptz);
      CREATE TABLE listing_event_rounds (listing_id integer, starts_on date, ends_on date, availability_status text);
      INSERT INTO listings VALUES (1,NULL),(2,now()+interval '30 days');
      INSERT INTO listing_event_rounds
        SELECT id, CURRENT_DATE-10, CURRENT_DATE-5, 'open' FROM listings;
      INSERT INTO listing_event_rounds
        SELECT id, CURRENT_DATE+1, CURRENT_DATE+5, 'open' FROM listings;
      INSERT INTO listing_event_rounds
        SELECT id, CURRENT_DATE-20, CURRENT_DATE-15, 'closed' FROM listings;`);
    const summary = searchSource.match(/(SELECT count\(\*\)::integer AS round_count, min\(starts_on\) AS starts_on, max\(ends_on\) AS ends_on\s+FROM public\.listing_event_rounds\s+WHERE listing_id = l\.id[\s\S]*?)\s*\) er ON true/);
    assert.ok(summary, 'Extract the actual search aggregate');
    const result = await db.query(`SELECT l.id, er.round_count,
      er.starts_on = CURRENT_DATE-10 AS includes_past,
      er.ends_on = CURRENT_DATE+5 AS keeps_future
      FROM listings l LEFT JOIN LATERAL (${summary[1]}) er ON true ORDER BY l.id`);
    assert.deepEqual(result.rows, [
      { id:1, round_count:2, includes_past:true, keeps_future:true },
      { id:2, round_count:1, includes_past:false, keeps_future:true },
    ]);
  } finally {
    await db.close();
  }
});
