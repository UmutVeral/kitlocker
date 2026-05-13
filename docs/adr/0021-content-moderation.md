# ADR-0021: Content Moderation Strategy

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

**V1: Reactive moderation only.** Every kit and profile has a "Şikayet Et" (Report) button. Reports are reviewed manually. No automated image scanning in V1.

## V1 implementation

- Report button on every kit card and profile page.
- Reports stored in Supabase with: reporterId, targetType (kit/profile), targetId, reason, createdAt.
- Admin dashboard (simple Supabase Studio query) to review and act on reports.
- Reported content can be hidden pending review via a `flagged` boolean on the kit/user record.

## Why not automated scanning in V1

- KitLocker's V1 audience is jersey collectors — low inappropriate content risk.
- Google Cloud Vision SafeSearch adds per-request cost and latency to every upload.
- App Store requires a reporting mechanism, not automated scanning.

## V2

Add Google Cloud Vision SafeSearch or equivalent on upload when user base grows and manual review becomes unsustainable.

## App Store compliance

Apple requires: content reporting mechanism + ability to block users. Both are covered in V1.
