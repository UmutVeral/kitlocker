# ADR-0002: Supabase as Backend (Managed → Self-hosted path)

**Status:** Accepted  
**Date:** 2026-05-13

## Context

KitLocker needs auth, database, file storage, realtime, and push notification infrastructure. Options considered: Firebase, Supabase, custom backend.

## Decision

Use **Supabase (managed)** for V1, with architecture designed to migrate to **self-hosted Supabase** as scale requires.

## Reasons

- Kit Database and Social Graph are inherently relational (team → kit, follow graph, feed assembly). PostgreSQL is the right fit; Firestore's document model would force awkward workarounds.
- `pg_trgm` extension enables fuzzy search on kit catalog natively — no extra service needed.
- Supabase bundles Auth, Storage, Realtime, and Edge Functions — covers all V1 infrastructure needs.
- Supabase is fully open source (Apache 2.0 core). The managed → self-hosted migration path is documented and viable, unlike Firebase which has no self-host option.

## Constraints

- Avoid using any Supabase managed-only features that have no self-hosted equivalent. Flag any such dependency before adopting it.
- Data access must go through a service/repository layer — no direct Supabase SDK calls scattered across UI code. This abstraction is what makes the migration feasible.

## Consequences

- Dart `supabase_flutter` package is the primary SDK.
- Self-hosting Supabase requires Docker + PostgreSQL ops capability — acceptable cost at the scale where managed pricing becomes a concern.
