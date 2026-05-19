## Problem Statement

Jersey collectors have no dedicated space to catalog, showcase, and share their physical kit collections. Today they resort to phone photo galleries (unstructured), Instagram posts (no metadata, lost in the feed), or spreadsheets (no social layer). There is no product that combines structured cataloging, AI-powered visual transformation, and a social showcase experience built specifically for the kit collector community.

## Solution

KitLocker is a Flutter mobile app (iOS + Android) where users photograph their jerseys, have them automatically identified via AI, and display them in a beautiful digital Locker. The defining feature is **Ghost Mannequin visualization** — a flat jersey photo is transformed into a render that makes the garment appear to be worn by an invisible human body, giving every piece in a collection a premium, showcase-ready look. A lightweight social layer lets collectors follow each other and discover collections by team and community.

## User Stories

### Onboarding & Auth
1. As a new user, I want to register with Apple, Google, or email/password, so that I can create my KitLocker profile.
2. As a new user, I want to be taken straight to the camera after registration, so that I experience the WOW moment before leaving the app.
3. As a returning user, I want to log in quickly with the same provider I registered with, so that I can access my collection without friction.
4. As a new user, I want to choose a unique username during signup, so that my Showcase URL is personalised.
5. As a user, I want the app to appear in Turkish when my device language is Turkish and in English otherwise, so that I use the app in my natural language without manually switching.

### Kit Ingestion
6. As a collector, I want to photograph my jersey directly in the app, so that I can add it to my Locker without leaving.
7. As a collector, I want the app to automatically identify the team, season, player name, and number from my jersey photo, so that I do not have to type metadata manually.
8. As a collector, I want to review and confirm the auto-detected kit details before saving, so that I can correct any AI errors.
9. As a collector, I want to search the Kit Catalog directly when recognition fails, so that I can find the correct kit entry by typing team and season.
10. As a collector, I want to manually enter or edit kit details (team, season, player, number, condition, notes) at any time, so that every kit in my Locker is accurate.
11. As a collector, I want to add multiple photos of the same jersey (front, back, detail), so that my Locker entry is complete.
12. As a collector, I want to assign a condition rating (mint, excellent, good, worn) to each kit, so that my collection reflects real-world state.
13. As a collector, I want my flat jersey photo to be displayed immediately after saving, so that my kit is visible right away while the Ghost Mannequin render is being generated.

### Ghost Mannequin Visualization
14. As a collector, I want my flat jersey photo to be automatically transformed into a Ghost Mannequin render after I add a kit, so that my showcase looks premium and three-dimensional.
15. As a collector, I want a push notification when my Ghost Mannequin render is ready, so that I can immediately experience the WOW moment.
16. As a collector, I want to see the Ghost Mannequin render update in place on my kit detail page, replacing the flat photo once it is ready, so that the upgrade feels seamless.
17. As a collector, I want the app to automatically retry a failed render up to three times, so that transient errors are handled without me having to intervene.
18. As a collector, I want a "Try Again" button on a kit if all render retries have been exhausted, so that I can manually re-trigger the process.
19. As a collector, I want to be prompted to rate the app immediately after my first successful Ghost Mannequin render, so that the rating request hits at my peak satisfaction.

### Collection (Locker)
20. As a collector, I want to view all my kits in a grid layout on my Locker page, so that I get an overview of my full collection.
21. As a collector, I want to filter my collection by team, league, season, or player, so that I can find a specific kit quickly.
22. As a collector, I want to sort my collection by date added, team, or season, so that I can organise my view.
23. As a collector, I want to see the total number of kits in my collection, so that I can track my collecting progress.
24. As a collector, I want to delete a kit from my collection, so that I can correct mistakes or update sold items.
25. As a collector, I want to mark a kit as favourite, so that my best pieces are prominently displayed.
26. As a collector, I want to add personal notes to a kit, so that I can record provenance, purchase story, or authenticity details.

### Showcase (Profile)
27. As a collector, I want a public Showcase page at `kitlocker.app/@username` that displays my collection, so that I can share it with friends and followers.
28. As a collector, I want to share a link to my Showcase or a specific kit, so that people without the app can view it in a browser.
29. As a visitor, I want to browse another user's Showcase and see their Ghost Mannequin renders, so that I feel inspired to join and build my own Locker.
30. As a collector, I want my Showcase to show my kit count, favourite teams, and most recent additions, so that visitors get an instant read of my collection identity.
31. As a collector, I want to control whether my Showcase is public or private, so that I can choose who sees my collection.
32. As a collector, I want my shared kit links to generate rich Open Graph previews (image + title) when pasted into messages or social platforms, so that my collection looks good when shared.

### Social Graph
33. As a collector, I want to follow other collectors, so that I can stay updated on their new kit additions.
34. As a collector, I want to see who follows me, so that I know my audience.
35. As a collector, I want to discover collectors grouped by team affiliation (e.g. Galatasaray collectors), so that I find people who share my passion.
36. As a collector, I want to receive a push notification when someone follows me, so that I know my collection is getting attention.

### Feed
37. As a collector, I want to see a chronological activity feed of new kits added by people I follow, so that I stay connected to the community.
38. As a collector, I want to like a kit in the feed, so that I can show appreciation without commenting.
39. As a collector, I want to comment on a kit, so that I can start a conversation about a specific jersey.
40. As a collector, I want to see who liked or commented on my kits, so that I know which pieces resonate most.
41. As a collector, I want to pull down to refresh the feed, so that I see the latest activity without the app refreshing automatically.
42. As a collector, I want comments to be capped at 500 characters, so that conversations stay focused.
43. As a collector, I want to block another user, so that they can no longer interact with my content or appear in my feed.
44. As a collector, I want to report a kit or comment for inappropriate content, so that the community stays safe.

### Kit Catalog
45. As a collector, I want the app to recognise kits from Super Lig clubs, so that my Turkish league collection is well-supported.
46. As a collector, I want the app to recognise kits from the top 5 European leagues (Premier League, La Liga, Bundesliga, Serie A, Ligue 1), so that international kits are also covered.
47. As a collector, I want to search the Kit Catalog by team name, season, or type (home/away/third) when adding a kit manually, so that I can find the correct entry even when photo recognition fails.

### Notifications
48. As a collector, I want push notifications for new followers and likes on my kits, so that I stay engaged with the community.
49. As a collector, I want a push notification when my Ghost Mannequin render is complete, so that I can see the result immediately.
50. As a collector, I want to control which notification types I receive, so that I am not overwhelmed.

### Monetisation
51. As a free user, I want access to all kit storage and core features with no limit, so that I am not blocked from collecting.
52. As a user browsing the feed, I want any sponsored content to appear naturally inline and infrequently, so that I discover new kits without feeling interrupted.

## Implementation Decisions

### Platform & Framework
- Flutter (Dart) — single codebase targeting iOS 16+ and Android 10 (API 29)+.
- Riverpod for state management.
- go_router for navigation.
- Feature-based folder structure: `lib/features/auth`, `lib/features/locker`, `lib/features/feed`, etc.

### Auth Module
- Providers: Apple Sign-In, Google Sign-In, Email/password. Facebook excluded (App Store requirement: if Apple login is offered, third-party login must also include Apple — Facebook adds no value here).
- Backed by Supabase Auth.
- Username: 3–30 characters, letters/digits/underscore only, 30-day change cooldown. Enforced at the database level.
- Supabase Row-Level Security (RLS) enabled on all tables. The service role key is used only inside Supabase Edge Functions, never exposed to the client.

### Kit Ingestion Module
- On photo capture, the image is sent to Gemini Flash (free tier) which returns `{ team, league, season, playerName, number, confidence }`.
- If confidence exceeds a threshold, fields are pre-filled and the user confirms. If below threshold, the user fills in manually.
- FKAPI (Football Kit Archive API, 467K kits) is used for fuzzy-match validation and the manual search fallback.
- After metadata confirmation, the Locker Entry is persisted immediately with the flat photo. Ghost Mannequin render starts asynchronously.
- Photos are compressed to WebP client-side before upload. Stored in Supabase Storage, served via Cloudflare CDN.

**Implemented (V1 slices):** Photo pipeline + WebP upload (#6). Kit catalog seed + manual search (#7). AI recognition via `recognize-kit` Edge Function + form pre-fill at confidence ≥ 0.7 (#8). Ghost Mannequin async pipeline not yet built (#9+).

### Ghost Mannequin Pipeline (Visualization Module)
- Encapsulated behind a single provider-agnostic interface: `GhostMannequinRenderer.render(photo) → Future<String renderUrl>`. The concrete provider is selected during initial testing and can be swapped without touching other modules.
- Render is triggered asynchronously after kit save. The flat photo is displayed immediately as a placeholder.
- On render completion, the `visualizationUrl` field on the Locker Entry is updated and the UI refreshes in place.
- Failure handling: 3 automatic retries with exponential backoff. After all retries fail, a "Try Again" button is shown on the kit detail page.
- On first successful render, the in-app App Store / Play Store rating prompt is triggered.
- FCM push notification is sent when render completes.

### Locker Module
- Locker Entry schema: `{ id, userId, kitCatalogId, teamName, leagueId, season, playerName, number, condition, notes, photos[], visualizationUrl, isFavourite, createdAt }`.
- CRUD backed by Supabase PostgreSQL with RLS.
- Filter and sort logic runs client-side on the fetched collection (V1 collection size does not warrant server-side filtering).

### Showcase / Profile Module
- Public URL pattern: `kitlocker.app/@username`.
- Web layer: Next.js on Vercel — server-side rendered profile pages only, no full web app.
- SSR enables Open Graph meta tags (image, title, description) for rich link previews.
- Visitors can browse without the app.

### Social Graph Module
- Directed follow graph: `(followerId, followeeId, createdAt)` table with RLS.
- Team Communities are derived views — a collector appears in a community if their Locker contains at least one kit from that team. No manual join required.

### Feed Module
- Event-sourced: kit additions, likes, and follows write events to an `activity_events` table.
- Feed is assembled from events of followed users, ordered chronologically. No algorithmic ranking in V1.
- Refreshed via pull-to-refresh. No realtime subscription in V1.
- Comments: 500-character limit, rate-limited to 5 per 60 seconds per user.
- User blocking: blocks are stored and applied as feed and interaction filters.

### Notifications Module
- Firebase Cloud Messaging (FCM) for push delivery. Only FCM is used from the Firebase suite — no Firestore, Analytics, or other Firebase services.
- Notification types: new follower, like on kit, comment on kit, Ghost Mannequin render complete.
- User-level notification preferences stored in Supabase.

### Localisation
- Device locale detection on app launch: `tr` → Turkish, everything else → English.
- No manual language switcher.

### Analytics & Infrastructure
- PostHog for analytics and feature flags (1M events/month free tier; self-host path available).
- Codemagic for CI/CD — Flutter native, automated App Store + Play Store deployments.
- Two environments: Dev (separate Supabase project) and Production. No staging environment.
- Content moderation: reactive — a report button on every kit and comment. SafeSearch filtering added in V2.

## Testing Decisions

**What makes a good test:** Tests verify observable external behaviour — inputs go in, outputs come out. A test that breaks when a private method is renamed is a bad test.

### Kit Ingestion Module
- Input: raw photo + mock Gemini response → output: structured Locker Entry metadata.
- Test confidence threshold branching: high confidence auto-fills fields, low confidence leaves them blank for user input.
- Test metadata merge when the user edits AI-suggested values.
- Test FKAPI fuzzy search: common misspellings, abbreviations, ambiguous player names, unknown team, future season.

**Covered in repo:** `test/features/recognition/` (prefill, coordinator, catalog matcher, applier); `test/features/catalog/kit_catalog_searcher_test.dart`.

### Ghost Mannequin Pipeline
- Test the `GhostMannequinRenderer` interface contract: a successful mock response updates the Locker Entry's `visualizationUrl`.
- Test retry logic: verify that a failing renderer is retried exactly 3 times before surfacing the "Try Again" state.
- Test provider substitution: swapping the concrete renderer implementation does not break callers.

### Locker Module
- CRUD operations produce correct state transitions.
- Filter logic returns the expected subset (by team, league, season, player).
- Sort logic returns correct ordering (by date, team, season).
- Favourite toggle and condition update behave correctly.

### Social Graph Module
- Follow creates a directed edge; unfollow removes it.
- `followersOf(userId)` and `followingOf(userId)` return correct sets.
- Blocking a user removes them from follow queries and feed results.
- Team Community membership is derived correctly from Locker contents.

### Feed Module
- A kit addition event by a followed user appears in the follower's feed.
- Events from unfollowed or blocked users do not appear.
- Chronological ordering is correct across multiple event types.
- Comment rate limiting rejects a 6th comment within 60 seconds.

### Not tested (rationale)
- **Auth Module** — standard provider SDK behaviour; framework-level responsibility.
- **Showcase web** — Next.js SSR rendering; visual and infrastructure concern, not business logic.
- **Notifications Module** — FCM is infrastructure/OS concern; no business logic to unit test.

## Out of Scope

- **Marketplace (V2):** kit trading and selling features.
- **Authenticity detection (V2+):** AI-powered fake vs. real kit detection.
- **Value estimation (V2+):** market price tracking and collection value calculator.
- **Basketball and other sports (V3):** scope is football kits only in V1.
- **Full web app:** mobile-first; web preview for Showcase only.
- **Offline mode:** V1 requires an internet connection.
- **Premium cosmetic features (V2):** themes, backgrounds, visual styles — monetisation model is ad-first in V1; premium is cosmetic and deferred.
- **User-contributed Kit Catalog entries:** FKAPI is the sole data source; user submissions are not supported in V1.
- **Staging environment:** two environments only — Dev and Production.

## Further Notes

- Ghost Mannequin visualization is KitLocker's sole differentiator. Every UX decision around the render moment should maximise the WOW factor. The flat photo → render transition is the product's hook.
- The concrete Ghost Mannequin provider is not locked in — it will be selected after testing candidate models. The provider-agnostic interface (ADR-0005) ensures this decision can be made and revised without architectural cost.
- Supabase is chosen as managed infrastructure with a documented self-host exit path (ADR-0002). The same applies to PostHog (ADR-0015). Vendor lock-in is a known risk, not an oversight.
- Kit limit removal: an earlier draft capped collections at 20 kits. This was removed. There is no kit limit in V1.
