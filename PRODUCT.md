# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Primary: prospective clients evaluating whether Zac can solve a specific
problem for them. They usually arrive from a referral or a link someone sent
them, and they are deciding whether to start a conversation.

Secondary: recruiters and hiring managers screening for internships, who need
to reach a yes or no quickly and are scanning rather than reading.

## Product Purpose

A personal site for Zac Finkelstein that turns a visitor into a conversation.
Success is an email or an outreach, not time on page.

## Positioning

Zac builds the work and builds the teams around it. Engineering depth (AI
systems in daily use inside a bank, an on-device retrieval chatbot) sits
alongside organizational work (co-chair of Queen's Web Dev, growing the club's
team, programs, and community). Neither half alone describes him, and that
pairing is the claim a neighbouring student portfolio cannot truthfully copy.

## Operating Context

Visitors land on a single static page served from GitHub Pages at
zacfinkelstein.ca, frequently on a phone, frequently from a link in a message
or an application. Copy is edited at runtime through a Supabase row and
re-rendered client side; the copy shipped inside index.html is the fallback
that renders first and stands if the request fails.

## Capabilities and Constraints

- One self-contained HTML file. No build step, no framework, no dependencies,
  no external requests except the content row. Deployed by GitHub Pages.
- The page renders from a single content object whose sections are brand, nav,
  hero, about, work, now, stack, thoughts, contact, footer. That structure is
  preserved.
- Copy is editable at runtime from a Supabase jsonb row. New fields added
  inside an existing section require re-seeding that row before deploy.
- `assets/resume.pdf` is the only binary asset in the project.
- Existing behaviour honours `prefers-reduced-motion`.

## Brand Commitments

Goes by Zac. Domain zacfinkelstein.ca. The established voice is plain, direct,
and a little blunt: "I find the slow, manual work and kill it." Contact points
are email, GitHub (zacfink), LinkedIn, and the résumé.

## Evidence on Hand

- Three real projects: Screen Intelligence and News Podcast with public repos,
  rbcDocClient private.
- A résumé PDF.
- No screenshots, screen recordings, demo videos, product imagery, logos,
  testimonials, client names, or measured outcome numbers exist. The user
  asked that the design not depend on such assets. None may be invented, and
  no metric may be stated that he cannot stand behind.

## Product Principles

1. The page exists to earn a conversation, not to describe a person.
2. Both halves of the claim, building things and building teams, stay legible.
   Dropping either misrepresents him.
3. The design carries itself through type, layout, colour, and motion, because
   there is no imagery to lean on and none will be fabricated.
4. Content stays data. Nothing distinctive may be hard-coded in a way that
   breaks rendering the page from the content object.
5. Self-containment and instant paint are features, not incidental.

## Accessibility & Inclusion

No product-specific standard was established. The incumbent implementation
honours reduced-motion preferences and that behaviour is preserved.
