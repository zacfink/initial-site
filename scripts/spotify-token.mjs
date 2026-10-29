// One-time: get a Spotify refresh token with the user-top-read scope.
//
//   SPOTIFY_CLIENT_ID=... SPOTIFY_CLIENT_SECRET=... node scripts/spotify-token.mjs
//
// The Spotify app's Redirect URI must be exactly http://127.0.0.1:8888/callback
import { createServer } from "node:http";
import { randomBytes } from "node:crypto";

const { SPOTIFY_CLIENT_ID: id, SPOTIFY_CLIENT_SECRET: secret } = process.env;
if (!id || !secret) throw new Error("set SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET");
const redirect = "http://127.0.0.1:8888/callback";
const state = randomBytes(12).toString("hex");

const server = createServer(async (req, res) => {
  const q = new URL(req.url, redirect).searchParams;
  if (!req.url.startsWith("/callback")) return res.end();
  if (q.get("state") !== state || !q.get("code")) {
    res.end("Login failed or was cancelled.");
    return server.close();
  }
  const r = await fetch("https://accounts.spotify.com/api/token", {
    method: "POST",
    headers: {
      Authorization: "Basic " + Buffer.from(`${id}:${secret}`).toString("base64"),
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({ grant_type: "authorization_code", code: q.get("code"), redirect_uri: redirect }),
  });
  const body = await r.json();
  res.end(r.ok ? "Done. The refresh token is in your terminal." : "Token exchange failed, see terminal.");
  console.log(r.ok ? `\nSPOTIFY_REFRESH_TOKEN=${body.refresh_token}\n` : body);
  server.close();
});

server.listen(8888, "127.0.0.1", () => {
  const auth = new URL("https://accounts.spotify.com/authorize");
  auth.search = new URLSearchParams({ client_id: id, response_type: "code", redirect_uri: redirect, scope: "user-top-read", state });
  console.log("Open this and log in:\n\n" + auth + "\n");
});
