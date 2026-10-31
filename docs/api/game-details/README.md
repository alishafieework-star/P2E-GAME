# game-details v1

Development contract for one downloadable game (D-122). The schema is
`v1.schema.json`. Fixtures live in `tool/fake_backend/fixtures/games`.

`GET {FAKE_API_BASE}/v1/games/{id}`

- Request headers: `Accept-Language`, optional `If-None-Match`.
- `200` returns the fixture with `ETag`, `Content-Language: en` and
  `Cache-Control: no-cache`. `{{media}}` is replaced with `http://{host}:{FAKE_MEDIA_PORT}`
  so the same file works on the desktop and the emulator.
- `304` when the ETag matches. The body is empty.
- `404` is `{"error":{"code":"game_not_found"}}`.

Numbers, dates and ids are raw. The app formats them. `reviews.total` is the full comment count; `reviews.items` is the preview on this page. See More Comments appears only when `total` is greater than `items` (D-125). Artwork is never bundled;
the media server serves `home/` and `games/` under the snapshot folders.

Persian copy is not in these fixtures. A `fa` request still receives `en`.
