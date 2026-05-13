# ADR-0023: Minimum OS Versions

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

- **iOS:** 16.0 minimum
- **Android:** API 29 (Android 10) minimum

## Rationale

Covers ~92% of Turkish iOS users and ~85% of Turkish Android users. Older versions add testing overhead and Flutter package compatibility issues without meaningful market gain. Sign in with Apple and modern camera APIs require iOS 16+.
