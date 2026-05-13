# ADR-0009: Kit Catalog Source — Football Kit Archive API (FKAPI)

**Status:** Accepted (pending commercial license confirmation)  
**Date:** 2026-05-13

## Context

KitLocker needs a kit catalog for: (1) auto-fill when adding a kit, (2) validating AI recognition output, (3) standardized team identifiers for communities and stats. Building and maintaining this catalog manually is not feasible.

## Decision

Use **Football Kit Archive API (FKAPI)** as the sole source for the Kit Catalog. KitLocker does not maintain its own catalog and does not accept user contributions to the catalog.

## Why FKAPI

- 467,983 kits across 29,687 teams and 3,354 leagues — covers Super Lig and all Top 5 EU leagues with historical seasons.
- REST API with fuzzy search (trigram-based) — maps directly to the manual kit search UX.
- An existing app (FootyCollect) already uses FKAPI for the same use case, validating feasibility.
- Commercial license pricing TBD — requires direct contact with the FKAPI team before launch.

## User Contribution: Rejected

Allowing users to add kits to the shared catalog was considered and rejected. Unmoderated crowdsourcing produces duplicates, spam, and incorrect data. FKAPI itself is community-curated — as its coverage grows, KitLocker's catalog improves automatically.

## Fallback for Missing Kits

If a kit is not found in the catalog, the user enters free-text fields (team, season, type, player, number). This data is saved to their personal Locker Entry only — it does NOT enter the shared catalog. The catalog stays clean.

## Consequences

- A commercial API dependency exists. If FKAPI becomes unavailable or pricing is unacceptable, an alternative source must be found before launch.
- Catalog coverage gaps are a known limitation — mitigated by the free-text fallback.
- No admin moderation overhead for catalog quality.
