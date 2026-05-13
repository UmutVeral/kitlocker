# ADR-0012: go_router for Flutter Navigation

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Use **go_router** (Flutter team's official routing package) for all in-app navigation.

## Reasons

- Official Flutter recommendation, maintained by Google.
- URL-based routing required for deep linking: `kitlocker.app/@username` must open the in-app Showcase screen via Universal Links (iOS) / App Links (Android).
- Integrates cleanly with Riverpod for auth-gated redirects (unauthenticated user redirected to login).

## Consequences

- All routes are declared as URL paths — consistent with the web mental model and the Next.js Showcase app's URL structure.
