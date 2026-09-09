-- Publish the current copy to the live row.
-- Supabase dashboard > SQL Editor > New query > paste > Run.
--
-- Writes ONLY these keys: about, work, now, stack, thoughts, monthly, footer.
-- `data || jsonb_build_object(...)` is a shallow merge of exactly those keys,
-- so everything else in the row is preserved.
-- Safe to re-run: it overwrites those keys with the same values.

update site_content
set data = data || jsonb_build_object(
    'about', '{
  "eyebrow": "01 — About",
  "heading": "Fast, clean, easy to work with.",
  "paragraphs": [
    "I''m a computer science student at Queen''s, specializing in cognitive science, and these days my focus is putting AI to work where it actually earns its keep. At RBC Dominion Securities I work with an advisor''s desk to find the slow, repetitive parts of their day and rebuild them with AI — cutting the busywork so they can move faster on what matters.",
    "I''m also co-chair of Queen''s Web Development, where I''m building the club itself: setting up how it runs, growing the team and its programs, and expanding the community around learning to build for the web.",
    "Outside of that, I''m always building something. I work across AI and software, I move quickly, and I care about the details most people skip. I''m confident with the hard problems — and easy to work with on them."
  ],
  "facts": [
    {
      "label": "Based in",
      "value": "Kingston, Ontario · from Toronto"
    },
    {
      "label": "Studying",
      "value": "Computer Science (Cognitive Science) · Queen''s ''28"
    },
    {
      "label": "Consulting",
      "value": "AI @ RBC Dominion Securities"
    },
    {
      "label": "Leading",
      "value": "Co-chair, Queen''s Web Dev"
    }
  ]
}'::jsonb,
    'work', '{
  "eyebrow": "02 — Work",
  "heading": "Things I''ve built.",
  "featured": [
    {
      "tags": [
        "Web",
        "Club"
      ],
      "title": "Queen''s Web Dev",
      "desc": "The club''s new site, shipped this term while co-chairing it. The place the curriculum and the events now live.",
      "repo": "https://www.qweb.dev",
      "linkLabel": "Visit"
    },
    {
      "tags": [
        "AI",
        "Automation"
      ],
      "title": "Screen Intelligence",
      "desc": "A macOS agent that reads the screen and drives the mouse and keyboard, with managed action history and recovery.",
      "meta": "macOS · Python",
      "repo": "https://github.com/zacfink/screen-intelligence"
    },
    {
      "tags": [
        "AI",
        "Audio"
      ],
      "title": "News Podcast",
      "desc": "Turns the day''s news into a generated audio podcast — automated sourcing, scripting, and text-to-speech.",
      "meta": "Python",
      "repo": "https://github.com/zacfink/news-podcast"
    },
    {
      "tags": [
        "AI",
        "Video"
      ],
      "title": "Video Auto Maker",
      "desc": "Turns a written script into a finished presentation video: a voice model reads it, and the tool cuts the visuals to the narration."
    }
  ]
}'::jsonb,
    'now', '{
  "eyebrow": "03 — Now",
  "heading": "What I''m up to.",
  "roles": [
    {
      "role": "AI Consultant",
      "org": "RBC Dominion Securities",
      "desc": "Finding the slow, manual parts of an advisor''s desk and rebuilding them with AI. Full-time over the summer, part-time through term."
    },
    {
      "role": "Co-chair",
      "org": "Queen''s Web Dev",
      "desc": "Running the club and growing it. This term: shipped the new site, started the curriculum, and got first-years building at their first event."
    }
  ]
}'::jsonb,
    'stack', '{
  "eyebrow": "04 — Tools",
  "heading": "What I reach for.",
  "groups": [
    {
      "label": "Build",
      "items": [
        "TypeScript",
        "Python",
        "React",
        "React Native",
        "Node.js",
        "AWS"
      ]
    },
    {
      "label": "AI",
      "items": [
        "Prompt engineering",
        "RAG",
        "AI agents"
      ]
    },
    {
      "label": "Working style",
      "items": [
        "Teamwork",
        "Communication",
        "Leadership",
        "Collaboration"
      ]
    }
  ]
}'::jsonb,
    'thoughts', '{
  "eyebrow": "05 — Thoughts",
  "heading": "How I build.",
  "items": [
    {
      "n": "01",
      "text": "Go deep on what the job actually requires. Not what it looks like it requires from outside."
    },
    {
      "n": "02",
      "text": "Then find every way to do it. All of them, before you fall for the first one."
    },
    {
      "n": "03",
      "text": "Then pick the best one you can actually build. A solution you can''t ship isn''t one."
    }
  ]
}'::jsonb,
    'monthly', '{
  "label": "Monthly",
  "items": [
    {
      "month": "2026-09",
      "kind": "Report",
      "title": "A summer at an RBC DS desk.",
      "desc": "Four people, almost two decades of records, and the discovery that the real cost was never the searching. It was who got interrupted.",
      "body": [
        "It is one advisor and three associates, a desk inside a branch big enough to get lost in. Behind the four of them sat close to two decades of records, piled up faster than anyone had time to organise them, because organising them was never actually anybody''s job.",
        "The cost of that was not really the searching. When something could not be found, the question went to the advisor. Every one of those interruptions landed on the person the desk exists to keep free, and they happened often enough to be part of the rhythm of the day. Nobody had ever counted them. They just happened.",
        "I spent four months on it, remote at first and then in the office from July. Most of that went into getting the records into a state where the people who needed them could actually search them. The rest went into agents for the work that kept coming back around: drafting email, editing documents both client-facing and internal, and taking the first pass at company and financial research.",
        "What changed is quiet. The associates answer their own questions now, so the advisor gets asked fewer of them. That is the whole result. No launch, no dashboard, just fewer interruptions landing on the person who could least afford them.",
        "The part worth writing down is what I got wrong. There was a tool sitting right there that I wrote off in the first ten minutes, because it was new and I did not enjoy using it, so I built around it with my own setup instead. Months later I found out it could have made those agents itself, from the start.",
        "So the lesson is not about AI. I skipped something because it was boring, and the thing I needed was behind it. Reading past the dull part is the habit that would have caught it, and it is the one I am taking out of the summer."
      ]
    }
  ]
}'::jsonb,
    'footer', '{
  "left": "© 2026 Zac",
  "right": "Open to conversations"
}'::jsonb
)
where id = 'live';

-- Check it landed:
-- select jsonb_array_length(data->'work'->'featured') as projects,
--        data->'footer'->>'right' as availability,
--        data->'monthly'->'items'->0->>'title' as report
-- from site_content where id = 'live';
