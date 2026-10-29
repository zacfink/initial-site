// Writes assets/top-artists.json from Spotify's /v1/me/top/artists
// for all three time ranges:
//   { ranges: { short_term|medium_term|long_term: { artists: [] } } }
// short_term ≈ last 4 weeks, medium_term ≈ 6 months, long_term ≈ all time.
// Run by .github/workflows/top-artists.yml; needs SPOTIFY_CLIENT_ID,
// SPOTIFY_CLIENT_SECRET and SPOTIFY_REFRESH_TOKEN (see scripts/spotify-token.mjs).
import { writeFileSync } from "node:fs";

const { SPOTIFY_CLIENT_ID: id, SPOTIFY_CLIENT_SECRET: secret, SPOTIFY_REFRESH_TOKEN: refresh } = process.env;
if (!id || !secret || !refresh) throw new Error("Spotify secrets are not set");

const tok = await fetch("https://accounts.spotify.com/api/token", {
  method: "POST",
  headers: {
    Authorization: "Basic " + Buffer.from(`${id}:${secret}`).toString("base64"),
    "Content-Type": "application/x-www-form-urlencoded",
  },
  body: new URLSearchParams({ grant_type: "refresh_token", refresh_token: refresh }),
});
if (!tok.ok) throw new Error(`token ${tok.status}: ${await tok.text()}`);
const { access_token } = await tok.json();

async function top(type, range) {
  const res = await fetch(`https://api.spotify.com/v1/me/top/${type}?time_range=${range}&limit=8`, {
    headers: { Authorization: `Bearer ${access_token}` },
  });
  if (!res.ok) throw new Error(`top ${type} ${range} ${res.status}: ${await res.text()}`);
  return ((await res.json()).items || []).filter(Boolean);
}

// images come largest first; take the smallest one that still looks sharp at 72px
const image = (imgs) => {
  const img = [...(imgs || [])].reverse().find((i) => (i.width || 0) >= 120) || (imgs || [])[0];
  return img ? img.url : "";
};

const ranges = {};
for (const range of ["short_term", "medium_term", "long_term"]) {
  ranges[range] = {
    artists: (await top("artists", range)).map((a) => ({
      name: a.name,
      genre: (a.genres || [])[0] || "",
      image: image(a.images),
      url: (a.external_urls || {}).spotify || "",
    })),
  };
}
// one empty range is fine (the page says so); nothing anywhere means a bad response
if (Object.values(ranges).every((v) => !v.artists.length))
  throw new Error("Spotify returned nothing; keeping the old file");

writeFileSync(
  new URL("../assets/top-artists.json", import.meta.url),
  JSON.stringify({ ranges }, null, 2) + "\n",
);
for (const [r, v] of Object.entries(ranges)) console.log(`${r}: ${v.artists.length} artists`);
