# ADR-0007: Showcase Web Preview — Minimal Next.js App on Vercel

**Status:** Accepted  
**Date:** 2026-05-13

## Context

`kitlocker.app/@username` must render in a browser for users without the app — primarily for link sharing on WhatsApp, Twitter, iMessage. Social crawlers parse the page's HTML for OG tags to generate link previews. Without proper SSR + OG tags, shared links show blank previews and kill click-through rates.

## Industry Reference

Spotify (`open.spotify.com`), Instagram (`instagram.com/@username`), Pinterest — all use a separate SSR web app for public profile/content pages, independent of their native mobile apps. This is the established pattern.

## Decision

Build a **minimal Next.js app deployed on Vercel** to serve Showcase pages only. The Flutter app is unchanged.

## What it does

1. Renders `kitlocker.app/@username` server-side with proper OG tags (title, description, og:image showing the collector's top kits).
2. Detects if the user has the KitLocker app installed — deep links into the app; otherwise redirects to App Store / Play Store.
3. Hosts `/.well-known/apple-app-site-association` and `/assetlinks.json` for Universal Links / Android App Links.

## What it does NOT do

- No auth, no writing, no full web app. Read-only public showcase only.
- No duplication of Flutter app functionality.

## Reasons

- Next.js App Router has a built-in metadata API and `ImageResponse` for dynamic OG images — exactly what's needed here.
- Vercel deploys in minutes, scales automatically, has a free tier sufficient for V1 traffic.
- Supabase Edge Function alternative was rejected: writing HTML rendering in Deno is more complex and less maintainable than Next.js for this use case.

## Consequences

- Two codebases: Flutter (mobile app) + Next.js (Showcase web). Both read from the same Supabase database.
- Dart and TypeScript/JavaScript are both in the project. Acceptable for the scope.
