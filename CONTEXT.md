# KitLocker — Domain Context

## Core Differentiator

**WOW Visualization** is the product's only AI differentiator. Everything else is infrastructure.

## Glossary

### Kit
A physical football jersey owned by a collector. Has metadata: team, league, season, player name, number, condition, notes. Stored as a Locker Entry.

### Locker
A user's private collection of Kits. The structured, personal catalog.

### Showcase
The public-facing view of a user's Locker. Has a shareable URL (`kitlocker.app/@username`). Visitors can browse without the app.

### WOW Visualization
The AI-powered visual transformation of a flat jersey photo into a Ghost Mannequin render. This is KitLocker's primary differentiator — the moment that hooks users and makes collections shareable. NOT the same as kit recognition.

### Ghost Mannequin
The visual effect where a flat jersey photo is transformed so the garment appears to be worn by an invisible human body — no head, no arms, no legs visible, but the fabric takes the natural 3D shape, volume, and drape of a garment on a body. Industry term used in e-commerce product photography. This is what KitLocker's WOW Visualization produces.

### Kit Recognition
A supporting feature, not a differentiator. Saves the user from typing metadata manually. If the AI is confident, it pre-fills fields. If not, the user fills them in. Accuracy matters, but imperfection is acceptable — the user always knows what jersey they have.

### Locker Entry
The database record representing one Kit in a user's Locker. Fields: { id, userId, kitCatalogId, teamName, leagueId, season, playerName, number, condition, notes, photos[], visualizationUrl, isFavourite, createdAt }.

### Kit Catalog
The canonical reference database of known kits (Club → Season → Type: home/away/third). Used for recognition fuzzy-matching and manual search. Seeded with Super Lig + Top 5 EU leagues for V1.

### Feed
Chronological activity stream of kit additions, likes, and follows from people a user follows. No algorithmic ranking in V1.

### Team Community
A derived grouping of collectors who share the same team affiliation in their Locker. Not a manually-joined group — membership is inferred from collection data.

## What KitLocker Is NOT

- A jersey authentication service
- A marketplace (V2)
- A value/price tracker (V2)
- A web app (Showcase web preview only)

## Flutter Project Structure

```
lib/
  app.dart                          ← KitLockerApp (ConsumerWidget, MaterialApp.router)
  main.dart                         ← entry point, ProviderScope
  core/
    auth/
      auth_state.dart               ← sealed AuthState (AuthLoading | Authenticated | Unauthenticated | AuthError)
      auth_notifier.dart            ← AuthNotifier (Notifier<AuthState>) + authStateProvider
      auth_state_provider.dart      ← re-export shim (authStateProvider, AuthNotifier)
      username_validator.dart       ← UsernameValidator.validate(String) → String? (regex: ^[a-zA-Z0-9_]{3,30}$)
    routing/
      app_router.dart               ← routerProvider (GoRouter)
      router_notifier.dart          ← RouterNotifier (ChangeNotifier, refresh bridge)
  features/
    auth/screens/auth_screen.dart   ← TabBar (Kayıt Ol / Giriş Yap), Form + validation, Riverpod
    home/screens/home_screen.dart
    splash/screens/splash_screen.dart
    locker/ | feed/ | showcase/ | social/ | notifications/
  l10n/
    app_en.arb | app_tr.arb         ← string kaynakları
    app_localizations.dart          ← flutter gen-l10n çıktısı
test/
  core/auth/username_validator_test.dart  ← 11 unit test (length, regex, edge cases)
  core/routing/app_router_test.dart       ← auth redirect davranışları (4 test)
  features/auth/auth_screen_test.dart     ← sign-up + sign-in form widget testleri (5 test)
  features/home/home_screen_test.dart     ← TR/EN lokalizasyon (2 test)
  widget_test.dart                        ← smoke test
supabase/
  migrations/
    20260514010614_create_profiles.sql    ← profiles tablosu, citext, unique index, RLS
    20260514010622_username_cooldown.sql  ← update_username() fonksiyonu, 30 gün cooldown
```

**Auth redirect mantığı:** `AuthLoading → /splash`, `Authenticated → /home`, `Unauthenticated → /auth`, `AuthError → /auth`

**AuthNotifier pattern:** `Notifier<AuthState>` — `build()` içinde `supabase.auth.onAuthStateChange` stream'i dinler, başlangıç state'i `AuthLoading`. Public interface: `signIn(email, password)`, `register(email, password, username)`, `signOut()`. Supabase client: `Supabase.instance.client` singleton.

**Test override pattern:** `_FakeAuthNotifier extends AuthNotifier` — `build()` ve `register()`/`signIn()` override ederek Supabase'siz çalışır. Widget testlerinde `lastRegisterCall` / `lastSignInCall` alanları ile çağrı doğrulanır.

**Lokalizasyon:** `flutter gen-l10n` → `lib/l10n/app_localizations.dart` (synthetic-package: false). Import: `package:kitlocker/l10n/app_localizations.dart`

**UsernameValidator:** `lib/core/auth/username_validator.dart` — pure Dart, regex `^[a-zA-Z0-9_]{3,30}$`. `validate(String) → String?` döner (null = geçerli). Form `validator:` callback'ine doğrudan bağlanır.

## Supabase Schema (V1)

### profiles
| Kolon | Tip | Kısıt |
|-------|-----|-------|
| id | uuid | PK, FK → auth.users(id) ON DELETE CASCADE |
| username | citext | NOT NULL, 3–30 karakter, `^[a-zA-Z0-9_]+$`, UNIQUE |
| username_updated_at | timestamptz | DEFAULT now() — cooldown takibi |
| created_at | timestamptz | DEFAULT now() |

RLS aktif. Policies: `profiles_select_public` (herkes okur), `profiles_insert_own` / `profiles_update_own` (sadece kendi kaydı).

`update_username(new_username citext)` — SECURITY DEFINER fonksiyon. 30 gün geçmemişse `raise exception` ile reddeder. Sadece `authenticated` role çağırabilir.
