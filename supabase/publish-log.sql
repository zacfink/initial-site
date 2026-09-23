-- Publish the log (the right-hand rail) to the live row.
-- Supabase dashboard > SQL Editor > New query > paste > Run.
--
-- Writes ONLY the `monthly` key; everything else in the row is preserved.
-- Safe to re-run.

update site_content
set data = data || jsonb_build_object(
    'monthly', '{
  "label": "Log",
  "items": [
    {
      "month": "2026-09",
      "kind": "Project",
      "title": "SupaBaseFolder",
      "desc": "A menu bar app that keeps Supabase tables live as spreadsheet and JSON files on my Mac, so I (or an AI agent) can edit a backend by saving a file.",
      "href": "https://github.com/zacfink/SupaBaseFolder"
    },
    {
      "month": "2026-09",
      "kind": "Project",
      "title": "Brain",
      "desc": "A plain-markdown second brain for working with Claude Code, with a small local app to browse and act on it.",
      "href": "https://github.com/zacfink/brain"
    },
    {
      "month": "2026-09",
      "kind": "Project",
      "title": "qweb.dev",
      "desc": "Rebuilt and launched the Queen''s Web Development Club site with the club''s dev team.",
      "href": "https://www.qweb.dev"
    }
  ]
}'::jsonb
)
where id = 'live';

-- Check it landed:
-- select data->'monthly'->>'label' as label,
--        jsonb_array_length(data->'monthly'->'items') as entries
-- from site_content where id = 'live';
