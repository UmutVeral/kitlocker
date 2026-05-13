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
      auth_state.dart               ← sealed AuthState (AuthLoading | Authenticated | Unauthenticated)
      auth_state_provider.dart      ← StateProvider<AuthState>
    routing/
      app_router.dart               ← routerProvider (GoRouter)
      router_notifier.dart          ← RouterNotifier (ChangeNotifier, refresh bridge)
  features/
    auth/screens/auth_screen.dart
    home/screens/home_screen.dart
    splash/screens/splash_screen.dart
    locker/ | feed/ | showcase/ | social/ | notifications/
  l10n/
    app_en.arb | app_tr.arb         ← string kaynakları
    app_localizations.dart          ← flutter gen-l10n çıktısı
test/
  core/routing/app_router_test.dart ← auth redirect davranışları (3 test)
  features/home/home_screen_test.dart ← TR/EN lokalizasyon (2 test)
```

**Auth redirect mantığı:** `AuthLoading → /splash`, `Authenticated → /home`, `Unauthenticated → /auth`

**Lokalizasyon:** `flutter gen-l10n` → `lib/l10n/app_localizations.dart` (synthetic-package: false). Import: `package:kitlocker/l10n/app_localizations.dart`
