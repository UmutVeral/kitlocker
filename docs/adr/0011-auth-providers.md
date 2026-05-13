# ADR-0011: Authentication Providers

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Support three auth methods via Supabase Auth: **Apple**, **Google**, **Email/password**.

## Reasons

- **Apple Login**: Mandatory per App Store Review Guidelines — any app offering third-party social login must include Sign in with Apple. Rejection risk if omitted.
- **Google Login**: De facto standard on Android. High adoption in Turkey.
- **Email/password**: Universal fallback — no dependency on third-party accounts.
- **Facebook**: Rejected — declining usage, extra SDK overhead, App Store privacy label complexity not worth it for V1.

## Consequences

- Supabase Auth handles all three natively — no custom auth code.
- Apple Developer account required for Sign in with Apple configuration.
