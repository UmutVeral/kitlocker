# ADR-0008: Riverpod for Flutter State Management

**Status:** Accepted  
**Date:** 2026-05-13

## Context

Flutter requires a state management solution. Options: Riverpod, BLoC, Provider, GetX.

## Decision

Use **Riverpod** (v3.x) as the state management solution.

## Reasons

- Most downloaded Flutter state management library in 2025–2026 (3.11M downloads). De facto community standard for new projects.
- Compile-time safety: provider references are verified at compile time, not runtime.
- First-class async support via `AsyncNotifier` — matches KitLocker's needs: Ghost Mannequin render state (`pending → processing → done`), feed loading, recognition results.
- Less boilerplate than BLoC, more powerful than Provider.
- Decouples state from the widget tree — no `BuildContext` threading through business logic.

## Rejected alternatives

- **BLoC**: Preferred for large enterprise teams needing strict audit trails. Overkill for KitLocker's team size and complexity.
- **Provider**: Predecessor to Riverpod, no longer recommended for new projects.
- **GetX**: Fast setup but poor testability and opinionated routing conflicts with our architecture.

## Consequences

- All global state lives in Riverpod providers.
- `AsyncNotifier` is the standard pattern for any state that involves loading/error/data (renders, feed, auth).
