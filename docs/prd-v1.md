## Problem Statement

Jersey collectors have no dedicated space to catalog, showcase, and share their physical kit collections. Today they resort to phone photo galleries (unstructured), Instagram posts (no metadata, lost in the feed), or spreadsheets (no social layer). There is no product that combines structured cataloging with a social showcase experience built specifically for the kit collector community.

## Solution

KitLocker is a cross-platform mobile app (React Native / Flutter) where users photograph their jerseys, have them automatically identified via AI, and display them in a beautiful digital locker. The AI-powered 3D/WOW visualization transforms flat jersey photos into floating or mannequin-style renders — making every collection shareable and impressive. A lightweight social layer lets collectors follow each other and discover collections by team and community.

## User Stories

### Onboarding & Auth
1. As a new user, I want to register with email or social login, so that I can create my KitLocker profile.
2. As a new user, I want to see a compelling onboarding screen that prompts me to add my first kit immediately, so that I experience the WOW moment before leaving the app.
3. As a returning user, I want to log in quickly, so that I can access my collection without friction.

### Kit Ingestion
4. As a collector, I want to photograph my jersey directly in the app, so that I can add it to my collection without leaving.
5. As a collector, I want the app to automatically identify the team, season, player name, and number from my jersey photo, so that I do not have to type metadata manually.
6. As a collector, I want to review and confirm the auto-detected kit details before saving, so that I can correct any AI errors.
7. As a collector, I want to manually enter or edit kit details (team, season, player, number, condition, notes) when AI recognition fails or is incomplete, so that every kit in my locker is accurate.
8. As a collector, I want to see my jersey transformed into a WOW visualization (mannequin or floating render) immediately after adding it, so that I feel rewarded for adding a new kit.
9. As a collector, I want to add multiple photos of the same jersey (front, back, detail), so that my locker entry is complete.
10. As a collector, I want to assign a condition rating (mint, excellent, good, worn) to each kit, so that my collection reflects real-world state.

### AI Visualization
11. As a collector, I want my flat jersey photo to be rendered as if it is on a mannequin or floating in air, so that my showcase looks premium and shareable.
12. As a collector, I want to choose between visualization styles (mannequin, floating, flat), so that I can personalize how my kits are displayed.
13. As a collector, I want the visualization to be generated within seconds, so that the experience feels instant and magical.

### Collection (Locker)
14. As a collector, I want to view all my kits in a grid layout on my locker page, so that I get an overview of my full collection.
15. As a collector, I want to filter my collection by team, league, season, or player, so that I can find a specific kit quickly.
16. As a collector, I want to sort my collection by date added, team, or season, so that I can organize my view.
17. As a collector, I want to see the total number of kits in my collection, so that I can track my collecting progress.
18. As a collector, I want to delete a kit from my collection, so that I can correct mistakes or update sold or traded items.
19. As a collector, I want to mark a kit as favourite, so that my best pieces are always at the top.

### Showcase (Profile)
20. As a collector, I want a public profile page (my Showcase) that displays my collection beautifully, so that I can share it with friends and followers.
21. As a collector, I want to share a link to my Showcase or a specific kit, so that people without the app can view it in a browser.
22. As a visitor, I want to browse another user's Showcase and see their kits in WOW visualization, so that I feel inspired to join and build my own locker.
23. As a collector, I want my Showcase to show my kit count, favourite teams, and most recent additions, so that visitors get an instant read of my collection identity.
24. As a collector, I want to control whether my Showcase is public or private, so that I can choose who sees my collection.

### Social Graph
25. As a collector, I want to follow other collectors, so that I can stay updated on their new kit additions.
26. As a collector, I want to see who follows me, so that I know my audience.
27. As a collector, I want to discover collectors by team affiliation (e.g. Galatasaray collectors), so that I find people who share my passion.
28. As a collector, I want to receive a notification when someone follows me, so that I know my collection is getting attention.

### Feed
29. As a collector, I want to see a lightweight activity feed of new kits added by people I follow, so that I stay connected to the community.
30. As a collector, I want to like a kit in the feed, so that I can show appreciation without commenting.
31. As a collector, I want to comment on a kit, so that I can start a conversation about a specific jersey.
32. As a collector, I want to see who liked or commented on my kits, so that I know which pieces resonate most.

### Kit Database
33. As a collector, I want the app to recognize kits from Super Lig clubs, so that my Turkish league collection is well-supported.
34. As a collector, I want the app to recognize kits from the top 5 European leagues (Premier League, La Liga, Bundesliga, Serie A, Ligue 1), so that international kits are also covered.
35. As a collector, I want to search the kit catalog directly when adding a kit manually, so that I can find the right entry even if photo recognition fails.

### Notifications
36. As a collector, I want push notifications for new followers and likes on my kits, so that I stay engaged with the community.
37. As a collector, I want to control notification preferences, so that I am not overwhelmed.

### Monetization (Freemium)
38. As a free user, I want to add up to 20 kits and use basic visualization, so that I can try the app meaningfully before paying.
39. As a premium subscriber, I want unlimited kit storage, advanced WOW visualization styles, and detailed collection stats, so that my full collecting experience is unlocked.
40. As a user browsing the feed, I want sponsored kit promotions to appear naturally inline, so that I discover new official kits without feeling interrupted.

## Implementation Decisions

### Platform
- Cross-platform mobile app using React Native or Flutter — single codebase targeting iOS and Android simultaneously.
- Multi-language architecture from day one: Turkish for launch, English strings alongside for fast global expansion.

### AI Kit Recognition (Kit Ingestion Module)
- On photo capture, the image is sent to an AI recognition service that returns a structured payload: { team, league, season, playerName, number, confidence }.
- If confidence is below a threshold, the app prompts the user to confirm or correct.
- Recognition is backed by the Kit Database catalog for lookup and fuzzy-matching validation.

### AI Visualization Module
- Separate from recognition — takes a cropped jersey image and applies a garment reconstruction / virtual staging pipeline.
- Output: a rendered image (mannequin-mounted or floating effect).
- Runs asynchronously after kit save; a placeholder is shown while rendering.
- Style options: mannequin, floating, flat (flat = original photo, always available instantly).

### Kit Database Module
- Canonical catalog of: Club -> Kit (season, type: home/away/third, optional player variants).
- Seeded with Super Lig and Top 5 EU leagues for V1.
- Supports fuzzy search for manual entry flow.

### Collection (Locker) Module
- Each Kit entry: { id, userId, kitCatalogId, teamName, leagueId, season, playerName, number, condition, notes, photos[], visualizationUrl, isFavourite, createdAt }.
- Private by default; visibility controlled at user profile level.

### Social Graph Module
- Simple directed follow graph: (followerId, followeeId, createdAt).
- Team communities derived from collection data — no manual group join required.

### Feed Module
- Event-sourced: kit additions, likes, follows generate events.
- Feed assembled from events of followed users, ordered chronologically.
- No algorithmic ranking in V1 — pure chronological.

### Showcase (Profile) Module
- Public URL pattern: kitlocker.app/@username
- Shareable as deep link and web preview.
- Web preview renders static HTML for non-app users.

### Launch Market
- Turkey first: Turkish UI, TL pricing, Super Lig kit coverage prioritized.
- Global-ready: English strings, international payment infrastructure, non-Turkey kit coverage included from day one.

## Testing Decisions

**What makes a good test:** Tests verify observable external behavior — what goes in, what comes out — not internal implementation. A test that breaks when you rename a private function is a bad test.

### Modules to test:

**Kit Ingestion Module**
- Input: raw photo + mock AI response -> Output: structured kit metadata object.
- Test confidence threshold branching (auto-accept vs. prompt-to-confirm).
- Test metadata merge when user edits AI result.

**Kit Database Module**
- Fuzzy search returns the correct kit for common misspellings and abbreviations.
- Catalog lookup by (team, season, type) returns the correct entry.
- Edge cases: unknown team, future season, ambiguous player name.

**Collection (Locker) Module**
- CRUD operations produce correct state.
- Filter and sort logic returns expected subsets.
- Favourite toggle and condition update behave correctly.

**Social Graph Module**
- Follow creates a directed edge; unfollow removes it.
- Followers of X and Following by X queries return correct sets.
- Community membership derived correctly from collection data.

**Feed Module**
- New kit event by followed user appears in follower's feed.
- Events from unfollowed users do not appear.
- Chronological ordering is correct across multiple event types.

### Not tested (rationale):
- AI Visualization Module — visual output; correctness is perceptual, not assertable in unit tests.
- Auth Module — standard auth library behavior; framework-level responsibility.
- Notifications Module — infrastructure/OS concern; no business logic to test.

## Out of Scope

- Marketplace (V2): kit trading and selling features.
- Authenticity detection (V2): AI-powered fake vs. real kit detection.
- Value estimation (V2): market price tracking and collection value calculator.
- Basketball and other sports (V3): scope is football kits only in V1.
- Web app: mobile-first; web preview for Showcase only, no full web app.
- Offline mode: V1 requires internet connection.

## Further Notes

- WOW visualization is the product core differentiator — the moment a user sees their flat jersey photo transformed into a floating or mannequin render is the hook. Every UI/UX decision around this moment should maximize the wow factor.
- KitLocker is the working app name. Domain availability (kitlocker.com, getkitlocker.com, kitlocker.app) should be verified before launch.
