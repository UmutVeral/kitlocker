# ADR-0014: Feature-Based Folder Structure

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Flutter project uses **feature-based** folder structure.

```
lib/
  features/
    auth/
    locker/
    kit_ingestion/
    visualization/
    showcase/
    feed/
    social/
    notifications/
  core/
    supabase/
    routing/
    theme/
    widgets/
```

## Reason

KitLocker's 9 modules are largely independent. Feature-based structure keeps all code for a feature co-located — data layer, providers, screens, widgets all in one folder. Changing a feature requires navigating one folder, not three layers. Scales better as the team grows.

## Consequences

- `core/` holds shared infrastructure (Supabase client, router, theme, reusable widgets).
- Cross-feature dependencies go through `core/` or explicit imports — no circular feature dependencies.
