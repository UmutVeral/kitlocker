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
