# ADR-0025: Username Policy

**Status:** Accepted  
**Date:** 2026-05-13

## Rules

- 3–30 characters
- Allowed: letters (a–z, A–Z), digits (0–9), underscore (`_`)
- Case-insensitive for uniqueness; stored and displayed in user's chosen casing
- Must be chosen during registration — no auto-generated usernames
- Reserved words blocked: `admin`, `support`, `kitlocker`, `help`, `api`, `www`, `app`, `official`, etc.

## Changing username

- Allowed, but with a **30-day cooldown** after each change
- Old username becomes available immediately after change — no redirect from old URL
- User is warned: "Eski profil linkin artık çalışmayacak"

## URL

`kitlocker.app/@username` — the `@` prefix is display-only; actual URL path is `/username`.
