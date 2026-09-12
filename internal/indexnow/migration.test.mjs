// Isolated PostgreSQL-engine checks; never reads .env or connects to a server.
// npm install --no-save @electric-sql/pglite in a temporary directory, then set
// PGLITE_MODULE_PATH to its node_modules/@electric-sql/pglite/dist/index.js.
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';
import test from 'node:test';

const { PGlite } = process.env.PGLITE_MODULE_PATH
  ? await import(pathToFileURL(process.env.PGLITE_MODULE_PATH).href)
  : await import('@electric-sql/pglite');
const migration = await readFile(new URL('../../database/migrations/0155_indexnow_outbox.sql', import.meta.url), 'utf8');
const goSource = await readFile(new URL('./indexnow.go', import.meta.url), 'utf8');
const workerSQL = [...goSource.matchAll(/`([^`]+)`/g)].map((match) => match[1]);
const statement = (fragment) => {
  const matches = workerSQL.filter((sql) => sql.includes(fragment));
  assert.equal(matches.length, 1, `worker SQL: ${fragment}`);
  return matches[0];
};

test('durable public lifecycle and actual worker SQL on isolated PostgreSQL', async (t) => {
  const db = new PGlite();
  t.after(() => db.close());
  await db.exec(`CREATE TABLE public.listings (
    id bigserial PRIMARY KEY, slug text, title text, description text,
    published_at timestamptz, deleted_at timestamptz, expires_at timestamptz,
    is_active boolean NOT NULL DEFAULT true, listing_status text DEFAULT 'active',
    moderation_status text DEFAULT 'approved', updated_at timestamptz DEFAULT now(),
    view_count integer DEFAULT 0, sale_price numeric
  );`);
  const detailTables = ['listing_offers','listing_media','listing_category_details',
    'listing_contact_profiles','listing_space_types','listing_amenities','listing_use_cases',
    'listing_business_details','listing_event_details','listing_event_rounds'];
  for (const name of detailTables) {
    await db.exec(`CREATE TABLE public.${name} (id bigserial PRIMARY KEY,
      listing_id bigint REFERENCES public.listings(id) ON DELETE CASCADE,
      value text, updated_at timestamptz DEFAULT now());`);
  }
  await db.exec(migration);
  const rows = async (sql, params = []) => (await db.query(sql, params)).rows;
  const count = async () => Number((await rows('SELECT count(*) AS n FROM indexnow_outbox'))[0].n);
  const queued = async (slug) => (await rows('SELECT * FROM indexnow_outbox WHERE path=$1', ['/real-estate-listings/'+slug]))[0];
  const insert = async (slug, publicPage = true) => (await rows(`INSERT INTO listings(slug,title,published_at)
    VALUES($1,'Original',CASE WHEN $2 THEN now() ELSE NULL END) RETURNING id`, [slug, publicPage]))[0].id;

  await t.test('only the two recently changed collection pages bootstrap, with deployment grace', async () => {
    assert.deepEqual((await rows('SELECT path FROM indexnow_outbox ORDER BY path')).map(r=>r.path), ['/homes','/real-estate-categories/all']);
    assert.equal((await rows("SELECT count(*)::int AS n FROM indexnow_outbox WHERE next_attempt_at>now()+interval '1 minute'"))[0].n, 2);
    await db.exec('TRUNCATE indexnow_outbox');
  });

  let draftID;
  await t.test('drafts and unapproved/private listings never enqueue', async () => {
    draftID = await insert('draft-private', false);
    await db.query('UPDATE listings SET title=$1 WHERE id=$2', ['Private details',draftID]);
    await db.query('INSERT INTO listing_offers(listing_id,value) VALUES($1,$2)', [draftID,'private price']);
    await db.exec("INSERT INTO listings(slug,published_at,moderation_status) VALUES('rejected',now(),'rejected');");
    assert.equal(await count(), 0);
  });

  let publicID;
  await t.test('publishing, slug assignment and all related public tables deduplicate', async () => {
    publicID = await insert(null);
    assert.equal(await count(), 0);
    await db.query("UPDATE listings SET slug='public-house' WHERE id=$1",[publicID]);
    for (const name of detailTables) {
      await db.query(`INSERT INTO ${name}(listing_id,value) VALUES($1,$2)`,[publicID,'actual public content']);
    }
    assert.equal(await count(),1);
    assert.equal(Number((await queued('public-house')).revision), 1+detailTables.length);
    const before = await queued('public-house');
    await db.query('UPDATE listings SET updated_at=now(),view_count=view_count+1 WHERE id=$1',[publicID]);
    assert.equal(Number((await queued('public-house')).revision), Number(before.revision));
    await db.query("UPDATE listing_offers SET updated_at=now() WHERE listing_id=$1",[publicID]);
    assert.equal(Number((await queued('public-house')).revision), Number(before.revision));
  });

  await t.test('failed saves roll back queue changes with listing changes', async () => {
    const before = await queued('public-house');
    await db.exec('BEGIN');
    await db.query("UPDATE listings SET title='Rolled back' WHERE id=$1",[publicID]);
    await db.exec('ROLLBACK');
    assert.equal(Number((await queued('public-house')).revision),Number(before.revision));
    assert.equal((await rows('SELECT title FROM listings WHERE id=$1',[publicID]))[0].title,'Original');
  });

  await t.test('old and new slugs, withdrawal and re-publication are all retained', async () => {
    await db.query("UPDATE listings SET slug='renamed-house' WHERE id=$1",[publicID]);
    assert.ok(await queued('public-house'));
    assert.ok(await queued('renamed-house'));
    await db.query("UPDATE listings SET published_at=NULL,moderation_status='rejected' WHERE id=$1",[publicID]);
    const removed = await queued('renamed-house');
    await db.query("UPDATE listings SET title='Still private' WHERE id=$1",[publicID]);
    assert.equal(Number((await queued('renamed-house')).revision),Number(removed.revision));
    await db.query("UPDATE listings SET published_at=now(),moderation_status='approved' WHERE id=$1",[publicID]);
    assert.equal(Number((await queued('renamed-house')).revision),Number(removed.revision)+1);
  });

  await t.test('a concurrent edit remains pending after acknowledging the captured revision', async () => {
    await db.exec("UPDATE indexnow_outbox SET next_attempt_at=now()-interval '1 minute'");
    const captured = (await rows(statement('SELECT path, revision, attempts'),[100])).find(r=>r.path.endsWith('/renamed-house'));
    assert.ok(captured);
    await db.query(statement('SET last_attempt_at=now()'),[captured.path]);
    await db.query('UPDATE listings SET sale_price=123456 WHERE id=$1',[publicID]);
    await db.query(statement('delivered_revision=GREATEST'),[captured.path,captured.revision,200]);
    const after = await queued('renamed-house');
    assert.equal(Number(after.delivered_revision),Number(captured.revision));
    assert.ok(Number(after.revision)>Number(after.delivered_revision));
    assert.equal(after.last_status,200);
    // An immediate retry does not violate the five-minute same-URL debounce.
    assert.ok(!(await rows(statement('SELECT path, revision, attempts'),[100])).some(r=>r.path===captured.path));
    await db.query(statement('attempts=attempts+1'),[captured.path,429,'IndexNow HTTP 429',900]);
    assert.equal((await queued('renamed-house')).attempts,1);
    assert.ok((await queued('renamed-house')).last_error.includes('429'));
  });

  await t.test('expiry scheduling, extending and automatic removal notification', async () => {
    await db.query("UPDATE listings SET expires_at=now()+interval '1 hour' WHERE id=$1",[publicID]);
    const scheduled = (await rows('SELECT * FROM indexnow_expirations WHERE listing_id=$1',[publicID]))[0];
    assert.ok(scheduled);
    await db.query("UPDATE listings SET expires_at=now()+interval '2 hours' WHERE id=$1",[publicID]);
    const extended = (await rows('SELECT * FROM indexnow_expirations WHERE listing_id=$1',[publicID]))[0];
    assert.ok(extended.expires_at>scheduled.expires_at);
    const before = await queued('renamed-house');
    // Move the isolated scheduler's clock fixture, then execute the real worker SQL.
    await db.query("UPDATE indexnow_expirations SET expires_at=now()-interval '1 minute' WHERE listing_id=$1",[publicID]);
    await db.exec(statement('WITH due AS'));
    assert.equal(Number((await queued('renamed-house')).revision),Number(before.revision)+1);
    assert.equal((await rows('SELECT * FROM indexnow_expirations')).length,0);
    await db.exec(statement('WITH due AS'));
    assert.equal(Number((await queued('renamed-house')).revision),Number(before.revision)+1);
  });

  await t.test('soft/hard deletion keeps the public removal URL; deleting drafts does not', async () => {
    const before = await queued('renamed-house');
    await db.query('UPDATE listings SET deleted_at=now() WHERE id=$1',[publicID]);
    assert.equal(Number((await queued('renamed-house')).revision),Number(before.revision)+1);
    const hardID = await insert('hard-delete');
    await db.query('DELETE FROM listings WHERE id=$1',[hardID]);
    assert.equal(Number((await queued('hard-delete')).revision),2);
    await db.query('DELETE FROM listings WHERE id=$1',[draftID]);
    assert.equal(await queued('draft-private'),undefined);
  });
});
