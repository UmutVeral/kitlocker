# ADR-0005: Ghost Mannequin Pipeline is Provider-Agnostic

**Status:** Accepted  
**Date:** 2026-05-13

## Context

The Ghost Mannequin rendering market is moving fast. A model that is best-in-class today may be replaced by a better one in months. Locking the architecture to a specific provider (Replicate, fal.ai, etc.) would make swapping expensive.

## Decision

The Ghost Mannequin rendering service is hidden behind an **interface (adapter pattern)**. The rest of the system calls `GhostMannequinRenderer.render(photo) -> renderedImageUrl` and knows nothing about which provider is behind it.

## Constraints

- One concrete adapter per provider (e.g., `ReplicateAdapter`, `FalAiAdapter`).
- Swapping providers = swapping the active adapter. No changes to job queue, storage, or notification logic.
- The interface contract: input is a jersey image URL, output is a rendered image URL. Provider-specific parameters (model ID, inference settings) are internal to the adapter.

## Consequences

- First concrete adapter can be whichever model proves best during initial testing.
- Future models (including self-hosted) plug in without touching the pipeline.
