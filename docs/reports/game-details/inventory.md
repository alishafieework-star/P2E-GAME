# Game Details inventory — 2026-10-25

Read-only source: Figma copy `7PGTHT5CQzbTsWZQnPIQce`, EN page. Evidence is `docs/snapshots/2026-10-25_game-details`. Figma was not modified.

## Reused

| Source | Code |
|---|---|
| App Bar `18526:12001` Downloadable Game | `DownloadableGameAppBar` |
| Navigator `18526:12184` | shell `AppNavigationBar` |
| Medium Fill Tonal, Medium Icon Tonal, Medium Fill Outlined | `AppButton` |
| Games Slider / Pagination | `AppShelf`, `AppPageIndicator` |
| Game Compact Card Detailed `18533:5327` and simple `18530:2967` | `GameCompactCard` |
| Reward overlay | `RewardBadge` |
| Section header geometry | `AppSectionHeader`, now two-tone and optional chevron (E-114) |

## New, games-owned

| Source | Code | componentId |
|---|---|---|
| Game Primary Data `18526:12003` | `GamePrimaryData` | `game.primary-data` |
| Media tile `18526:12049` | `GameMediaTile` | `game.media-tile` |
| About `18526:12068` and facts `18526:12071` | `GameAboutCard`, `GameFactCard` | `game.about-card`, `game.fact-card` |
| Event and Offer Card `18526:11872` | `EventOfferCard` | `game.event-offer-card` |
| Ratings `18526:12105`, AI `18526:12149`, Comment `18526:11914` | `RatingSummary`, `AiSummaryCard`, `ReviewTile`, `StarRating` | `game.rating-summary`, `game.ai-summary`, `game.review` |
| Studio card `18530:1911` | `StudioCard` | `game.studio-card` |

The screen only orders these and binds providers. Empty sections hide. Quests with the same `gameId` are the first events (D-124). See More Comments (`18526:12168`) is omitted when `reviews.total` is not greater than the preview (D-125). A media tap opens a full-screen viewer of the shelf pictures (D-126). The Clash sample pictures for that shelf and for event card `18526:12093` are the Figma fills.

## Data

`GET /v1/games/{id}` and `docs/api/game-details/v1.schema.json`. Sample art reuses the Home snapshot through `{{media}}/home/…`. The client caches the JSON and drops it on sign-out (D-123).
