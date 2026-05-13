# ADR-0015: PostHog for Product Analytics

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Use **PostHog** (managed cloud initially, self-hosted path open) for product analytics, feature flags, and A/B testing.

## Why not the alternatives

- **Firebase Analytics (GA4)**: Free and already in the project for FCM, but it is a marketing attribution tool, not a product analytics tool. Cannot answer "what % of users who added a kit waited for the WOW render?" without significant setup pain. No self-host, no feature flags.
- **Mixpanel**: Good product analytics UI but cloud-only (no self-host), expensive at scale, no feature flags. Same event limit as PostHog with less capability.
- **Amplitude**: Most generous free tier (10M events) and strong mobile SDKs, but no self-host, feature flags require a separate product (Statsig), and less adoption in the indie/vibe coder community.

## Why PostHog

1. **Feature flags**: Rolling out new Ghost Mannequin models to 10% of users before full release — no code change needed. Directly complements ADR-0005 (provider-agnostic render pipeline).
2. **Consistent architecture philosophy**: Every major dependency has a self-host exit path (Supabase → ADR-0002, PostHog → open source Docker). Firebase Analytics has no exit.
3. **KVKK compliance**: Self-hosted PostHog keeps Turkish user behavioral data in Turkish/EU servers. Firebase sends data to Google US servers.
4. **All-in-one**: Analytics + session replay + feature flags + A/B tests + surveys in a single SDK. One tool to manage, not three.

## Free tier

1M events/month + 2,500 session replays + unlimited feature flags. Sufficient for V1.

## Key events to track (V1)

- `kit_added` — forma ekleme tamamlandı
- `recognition_result` — AI tahmin confidence skoru
- `visualization_requested` — Ghost Mannequin render başlatıldı
- `visualization_completed` — render tamamlandı (süre ile birlikte)
- `visualization_abandoned` — kullanıcı render beklerken uygulamadan çıktı
- `showcase_shared` — link paylaşıldı
- `follow` — birini takip etme
- `onboarding_completed` — ilk kit eklendi + WOW görüldü

## Flutter SDK

`posthog-flutter` official package.

## Consequences

- Firebase is used only for FCM (ADR-0010). Firebase Analytics is NOT added — two analytics tools would be redundant and confusing.
- When self-hosting PostHog, a VPS with Docker is required (~€20/month at small scale).
