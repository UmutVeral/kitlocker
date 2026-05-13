# ADR-0006: Monetization Strategy — Ads First, Premium Cosmetic

**Status:** Accepted  
**Date:** 2026-05-13

## Context

Early PRD assumed a freemium model with a 20-kit limit gating core functionality. After product clarification, the priority is user acquisition and product-market fit, not early revenue extraction.

## Decision

- **V1: Full functionality is free. No kit count limit.**
- **Revenue model: Non-intrusive native ads** in the Feed and/or story-style surfaces. Users see 1–2 ads in natural scroll — not interstitials, not banners.
- **Premium (future): Cosmetic only** — themes, backgrounds, visualization styles, aesthetic personalization. Never gates functional features.
- **Marketplace commission (V2+)**: When trading/selling launches, commission on transactions.

## Reasons

- Gating core features early drives churn before users experience the product's value. The WOW moment needs to be free.
- Ad revenue scales with DAU — incentivizes growth over conversion pressure.
- Cosmetic premium is honest: users pay for expression, not for features they already expect.
- The 20-kit limit from the original PRD is removed — it was arbitrary and would have frustrated the core collector audience.

## Architecture Implications

- The codebase must have ad slot infrastructure from day one (even if not active in V1) — adding ads to a codebase that was never designed for them is painful.
- Subscription/premium infrastructure should be scaffolded but not actively sold in V1.
- No feature flags tied to subscription status in V1 core flows.
