# ADR-0017: Two Environments — Dev and Production

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Two Supabase projects: **Development** and **Production**. No staging environment in V1.

## Reasons

- Writing to production during development is too risky — schema changes, bad data, accidental deletions.
- Staging adds operational overhead (three sets of credentials, three deploy targets) not justified at V1 team size.
- Supabase free tier supports two projects — zero additional cost.

## Environment config in Flutter

- `.env.dev` and `.env.prod` files, loaded via `--dart-define-from-file` at build time.
- Codemagic uses the correct env file per build target.
- Dev builds show a visible "DEV" banner in the app to prevent confusion.
