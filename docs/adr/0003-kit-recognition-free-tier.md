# ADR-0003: Kit Recognition Uses Free-Tier Vision AI

**Status:** Accepted  
**Date:** 2026-05-13

## Context

Kit recognition (identifying team, season, player from a jersey photo) was initially considered a key AI feature. After product clarification, it is a convenience feature — users already know what jersey they hold. Recognition just saves typing.

## Decision

Use a **free-tier vision model** (e.g., Gemini Flash) for kit recognition. No investment in custom models or paid APIs for this feature.

## Reasons

- Kit recognition is NOT a differentiator. WOW Visualization is.
- Users tolerate imperfect recognition because they can correct it manually.
- Spending budget/complexity on recognition would be misallocated effort.
- Free-tier Gemini Flash (or equivalent) is sufficient: extract { team, league, season, playerName, number } with a confidence signal. If confidence is low, fall back to manual entry.

## Consequences

- Recognition accuracy ceiling is lower than a fine-tuned model. Acceptable.
- The confidence threshold UX (auto-fill vs. prompt-to-confirm) remains important — bad auto-fills are more annoying than no auto-fill.
- If free-tier rate limits become a problem at scale, this decision should be revisited.

## Implementation (issue #8)

- **Edge Function:** `supabase/functions/recognize-kit` — accepts base64 WebP (`imageBase64`), forwards as `image/webp` to Gemini Flash, returns `{ team, league, season, playerName, number, confidence }`. Secret: `GEMINI_API_KEY` (optional `GEMINI_MODEL`).
- **Pre-upload compress:** `LockerEntryFormScreen` runs `PhotoCompressor` on the picked image before calling the Edge Function (same WebP pipeline as storage upload).
- **Flutter:** `lib/features/recognition/` — `RecognitionCoordinator` orchestrates repo + catalog validation; `KitRecognitionPrefill` applies threshold `0.7` (`KitRecognitionConfig.confidenceThreshold`).
- **Form:** `LockerEntryFormScreen` triggers recognition after photo pick (add flow only). High confidence → pre-fill; low confidence or failure → manual entry + Catalog search; user-edited fields are not overwritten.
- **Catalog validation:** `KitRecognitionCatalogMatcher` reuses `KitCatalogSearcher` (#7) to set `kitCatalogId` / `leagueId` when AI output matches the catalog snapshot.
