// Writes assets/top-artists.json from Spotify's /v1/me/top/artists.
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

// medium_term = roughly the last 6 months
const res = await fetch("https://api.spotify.com/v1/me/top/artists?time_range=medium_term&limit=8", {
  headers: { Authorization: `Bearer ${access_token}` },
});
if (!res.ok) throw new Error(`top artists ${res.status}: ${await res.text()}`);
const { items } = await res.json();

const artists = items.map((a) => {
  // images come largest first; take the smallest one that still looks sharp at 72px
  const img = [...(a.images || [])].reverse().find((i) => (i.width || 0) >= 120) || (a.images || [])[0];
  return {
    name: a.name,
    genre: (a.genres || [])[0] || "",
    image: img ? img.url : "",
    url: (a.external_urls || {}).spotify || "",
  };
});
if (!artists.length) throw new Error("Spotify returned no artists; keeping the old file");

writeFileSync(
  new URL("../assets/top-artists.json", import.meta.url),
  JSON.stringify({ artists }, null, 2) + "\n",
);
console.log(artists.map((a) => a.name).join(", "));
