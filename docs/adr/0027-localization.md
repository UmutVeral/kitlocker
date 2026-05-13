# ADR-0027: Localization Strategy

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

App language follows the **device locale automatically**. No in-app language picker in V1.

- Turkish device → Turkish UI
- Any other locale → English UI (fallback)
- All strings are externalized from day one using Flutter's `flutter_localizations` + `intl` package

## Supported locales in V1

- `tr` (Turkish) — primary
- `en` (English) — fallback for all other locales

## Content vs UI

- UI strings: localized
- User-generated content (kit names, comments, bios): not translated — stored and displayed as-is
- Kit Catalog data (team names, league names): Turkish and English names stored separately in the catalog; displayed per locale

## Why no in-app picker

Adds UI surface area and state management overhead. The device locale is the correct signal in almost all cases. Can be added in V2 if user feedback demands it.
