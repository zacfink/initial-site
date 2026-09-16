// Regenerates the Supabase files from the SITE object shipped in index.html,
// so the row can always be reset to exactly what the page ships.
//
//   node supabase/build-seed.mjs
//
// Writes seed.json, seed.sql (the whole row) and publish-log.sql (only the
// `monthly` key, for updating the log on the live row without touching the rest).
import { readFileSync, writeFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const here = new URL(".", import.meta.url);
const html = readFileSync(new URL("../index.html", here), "utf8");

const start = html.indexOf("let SITE = {");
const end = html.indexOf("\n        };\n", start);
if (start < 0 || end < 0) throw new Error("SITE object not found in index.html");
const literal = html.slice(start + "let SITE = ".length, end + "\n        }".length);
const SITE = runInNewContext(`(${literal})`);

const json = JSON.stringify(SITE, null, 2);
const sqlString = (s) => `'${s.replaceAll("'", "''")}'`;

writeFileSync(new URL("seed.json", here), json + "\n");

writeFileSync(
  new URL("seed.sql", here),
  `-- Load (or reload) the live row with the content shipped in index.html.
-- Run this after schema.sql. Safe to re-run: it overwrites the row.

insert into site_content (id, data)
values (
  'live',
  ${sqlString(json)}::jsonb
)
on conflict (id) do update set data = excluded.data;
`,
);

writeFileSync(
  new URL("publish-log.sql", here),
  `-- Publish the log (the right-hand rail) to the live row.
-- Supabase dashboard > SQL Editor > New query > paste > Run.
--
-- Writes ONLY the \`monthly\` key; everything else in the row is preserved.
-- Safe to re-run.

update site_content
set data = data || jsonb_build_object(
    'monthly', ${sqlString(JSON.stringify(SITE.monthly, null, 2))}::jsonb
)
where id = 'live';

-- Check it landed:
-- select data->'monthly'->>'label' as label,
--        jsonb_array_length(data->'monthly'->'items') as entries
-- from site_content where id = 'live';
`,
);

console.log("wrote seed.json, seed.sql, publish-log.sql");
