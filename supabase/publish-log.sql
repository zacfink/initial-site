-- Publish the log (the right-hand rail) to the live row.
-- Supabase dashboard > SQL Editor > New query > paste > Run.
--
-- Writes ONLY the `monthly` key; everything else in the row is preserved.
-- Safe to re-run.

update site_content
set data = data || jsonb_build_object(
    'monthly', '{
  "items": [
    {
      "desc": "A home-screen app for my second brain. Hold to ask it anything out loud, swipe through what''s next, and capture ideas on the go.",
      "href": "https://github.com/zacfink/brain",
      "kind": "Project",
      "month": "2026-10",
      "title": "Brain on my phone"
    },
    {
      "desc": "First public release, with a JSON tree editor for editing nested data without touching raw JSON.",
      "href": "https://github.com/zacfink/SupaBaseFolder",
      "kind": "Project",
      "month": "2026-10",
      "title": "SupaBaseFolder 1.1"
    },
    {
      "desc": "The skills, hooks and habits I use to work with Claude Code, cleaned up so anyone can copy them.",
      "href": "https://github.com/zacfink/claude-code-setup",
      "kind": "Project",
      "month": "2026-10",
      "title": "My Claude Code setup"
    },
    {
      "desc": "A macOS agent that sees the screen and drives the mouse and keyboard, checking each click actually changed something.",
      "href": "https://github.com/zacfink/screen-intelligence",
      "kind": "Project",
      "month": "2026-10",
      "title": "Screen Intelligence"
    },
    {
      "desc": "A menu bar app that keeps Supabase tables live as spreadsheet and JSON files on my Mac, so I (or an AI agent) can edit a backend by saving a file.",
      "href": "https://github.com/zacfink/SupaBaseFolder",
      "kind": "Project",
      "month": "2026-09",
      "title": "SupaBaseFolder"
    },
    {
      "desc": "A plain-markdown second brain for working with Claude Code, with a small local app to browse and act on it.",
      "href": "https://github.com/zacfink/brain",
      "kind": "Project",
      "month": "2026-09",
      "title": "Brain"
    },
    {
      "desc": "Rebuilt and launched the Queen''s Web Development Club site with the club''s dev team.",
      "href": "https://www.qweb.dev",
      "kind": "Project",
      "month": "2026-09",
      "title": "qweb.dev"
    },
    {
      "desc": "A terminal chat assistant that talks only by picking saved sentences, grades its own answers, and asks to be taught when it doesn''t know.",
      "href": "https://github.com/zacfink/jev-reply",
      "kind": "Project",
      "month": "2026-09",
      "title": "Jev-Reply"
    },
    {
      "desc": "Research in progress: a blank neural network grows up in a simulated house with AI caregivers, compared on markers of consciousness.",
      "kind": "Report",
      "month": "2026-09",
      "title": "Raised"
    }
  ],
  "label": "Log"
}'::jsonb
)
where id = 'live';

-- Check it landed:
-- select data->'monthly'->>'label' as label,
--        jsonb_array_length(data->'monthly'->'items') as entries
-- from site_content where id = 'live';
