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
A supporting feature, not a differentiator. Saves the user from typing metadata manually. If the AI is confident (≥ 0.7), it pre-fills fields on the add-kit form. If not, the user fills them in manually or uses Catalog search. Recognition runs via Supabase Edge Function `recognize-kit` (Gemini Flash); the API key never ships in the client. Accuracy matters, but imperfection is acceptable — the user always knows what jersey they have. See ADR-0003, issue #8.

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
  main.dart                         ← async entry point: WidgetsFlutterBinding.ensureInitialized() → Supabase.initialize(url, anonKey) → runApp(ProviderScope)
  core/
    auth/
      auth_state.dart               ← sealed AuthState (AuthLoading | Authenticated | Unauthenticated | AuthError)
      auth_notifier.dart            ← AuthNotifier (Notifier<AuthState>) + authStateProvider
      auth_state_provider.dart      ← re-export shim (authStateProvider, AuthNotifier)
      username_validator.dart       ← UsernameValidator.validate(String) → String? (regex: ^[a-zA-Z0-9_]{3,30}$)
    routing/
      app_routes.dart               ← AppRoutes sabitleri (splash, auth, home, locker, lockerAdd, lockerDetail)
      app_router.dart               ← routerProvider (GoRouter), AppRoutes kullanır
      router_notifier.dart          ← RouterNotifier (ChangeNotifier, refresh bridge), AppRoutes kullanır
  features/
    auth/screens/auth_screen.dart   ← TabBar (Kayıt Ol / Giriş Yap), Form + validation, Riverpod
    home/screens/home_screen.dart   ← ConsumerStatefulWidget, BottomNavigationBar shell — Tab 0: LockerScreen, Tab 1: ProfileScreen(currentUserId)
    splash/screens/splash_screen.dart
    locker/
      models/
        locker_condition.dart       ← enum LockerCondition { mint, excellent, good, worn }
        locker_entry.dart           ← LockerEntry (immutable data class, fromJson/toJson/copyWith)
      providers/
        locker_entries_notifier.dart ← LockerEntriesNotifier + sortLockerEntries() + lockerEntriesProvider
      screens/
        locker_screen.dart          ← grid view, kit count header, FAB → /locker/add
        locker_entry_form_screen.dart ← add/edit formu, foto + AI recognition (add only), Catalog arama, validation
        locker_entry_detail_screen.dart ← detay, favori toggle, düzenleme, confirmation delete
    recognition/
      models/
        kit_recognition_result.dart     ← Gemini JSON (team, league, season, playerName, number, confidence)
        kit_recognition_form_values.dart ← pre-fill DTO for form controllers
      kit_recognition_config.dart       ← confidenceThreshold = 0.7
      kit_recognition_prefill.dart        ← threshold → KitRecognitionFormValues?
      kit_recognition_catalog_matcher.dart ← AI output → KitCatalogEntry? via KitCatalogSearcher
      kit_recognition_repository.dart     ← abstract recognize(Uint8List)
      supabase_kit_recognition_repository.dart ← functions.invoke('recognize-kit')
      recognition_coordinator.dart        ← repo + catalog + RecognitionOutcome
      recognition_outcome.dart            ← RecognitionPrefillSuggested | RecognitionManualEntry
      locker_entry_recognition_applier.dart ← skip pre-fill if user already typed team/season
      providers/recognition_provider.dart ← kitRecognitionRepositoryProvider, recognitionCoordinatorProvider
    catalog/
      models/
        kit_type.dart                 ← enum KitType { home, away, third }
        kit_catalog_entry.dart        ← KitCatalogEntry (fromJson/toJson)
      kit_catalog_searcher.dart       ← KitCatalogSearcher — client-side fuzzy search (trigram + prefix)
      catalog_repository.dart         ← abstract CatalogRepository + searchCatalog()
      supabase_catalog_repository.dart ← SupabaseCatalogRepository (kit_catalog SELECT)
      providers/catalog_provider.dart ← catalogRepositoryProvider, kitCatalogProvider
      widgets/catalog_search_sheet.dart ← CatalogSearchSheet + showCatalogSearchSheet()
    photos/
      photo_repository.dart         ← abstract interface PhotoRepository { uploadPhoto(Uint8List, userId) → Future<String> }
      supabase_photo_repository.dart ← SupabasePhotoRepository — kit-photos bucket, userId/uuid.webp yolu, getPublicUrl döner
      photo_compressor.dart         ← abstract interface PhotoCompressor { compress(Uint8List) → Future<Uint8List> }
      flutter_image_compress_photo_compressor.dart ← FlutterImageCompressPhotoCompressor — WebP format, quality 85
      photo_providers.dart          ← photoRepositoryProvider + photoCompressorProvider (Provider<T>)
      image_picker_service.dart     ← abstract pickImage(ImageSource); ImagePickerServiceImpl
      providers/image_picker_provider.dart ← imagePickerServiceProvider (test override)
    social/
      models/
        user_profile.dart             ← UserProfile(userId, username) — immutable, fromJson, == by userId
      repositories/
        follow_repository.dart        ← abstract interface FollowRepository { follow, unfollow, isFollowing, getFollowers, getFollowing, notifyNewFollower }
        supabase_follow_repository.dart ← SupabaseFollowRepository — iki aşamalı sorgu (follows → inFilter profiles)
      providers/
        follow_repository_provider.dart ← followRepositoryProvider = Provider<FollowRepository>
        follow_toggle_notifier.dart   ← FollowToggleNotifier (FamilyAsyncNotifier<bool,String>) + followToggleProvider
        followers_notifier.dart       ← FollowersNotifier (FamilyAsyncNotifier<List<UserProfile>,String>) + followersOfProvider
        following_notifier.dart       ← FollowingNotifier (FamilyAsyncNotifier<List<UserProfile>,String>) + followingOfProvider
        user_profile_provider.dart    ← userProfileProvider (FutureProvider.family<UserProfile?,String>) — profiles tablosu
      screens/
        profile_screen.dart           ← ProfileScreen(userId) — follow/unfollow butonu (kendi profilinde gizli), takipçi/takip sayıları tıklanabilir
        followers_screen.dart         ← FollowersScreen(userId) — takipçi listesi
        following_screen.dart         ← FollowingScreen(userId) — takip edilen listesi
    feed/ | showcase/ | notifications/
  l10n/
    app_en.arb | app_tr.arb         ← string kaynakları
    app_localizations.dart          ← flutter gen-l10n çıktısı
test/
  helpers/
    auth_fakes.dart                       ← FakeAuthNotifier (paylaşılan test fake, tüm auth testleri kullanır)
    locker_fakes.dart                     ← FakeLockerEntriesNotifier + fakeEntry() yardımcısı
    photo_fakes.dart                      ← FakePhotoRepository + FakePhotoCompressor
    recognition_fakes.dart                ← FakeKitRecognitionRepository + FakeImagePickerService
    onboarding_fakes.dart                 ← FakeOnboardingNotifier, completeOnboardingCalled flag
    social_fakes.dart                     ← FakeFollowRepository (Set<(String,String)>, seedProfile), fakeProfile()
  core/auth/username_validator_test.dart  ← 11 unit test (length, regex, edge cases)
  core/routing/app_router_test.dart       ← auth redirect davranışları (34 test)
  features/auth/auth_screen_test.dart     ← sign-up + sign-in form widget testleri (5 test)
  features/home/home_screen_test.dart     ← BottomNavigationBar sekme testleri (4 test)
  features/catalog/
    kit_catalog_searcher_test.dart        ← 6 unit test (fuzzy, filtreler, ambiguous, unknown)
  features/recognition/
    kit_recognition_prefill_test.dart     ← 2 unit test (yüksek/düşük confidence)
    kit_recognition_catalog_matcher_test.dart ← 2 unit test (exact + typo fuzzy)
    recognition_coordinator_test.dart     ← 3 unit test (prefill, low confidence, error)
    locker_entry_recognition_applier_test.dart ← 2 unit test (prefill, user already filled)
  features/locker/
    locker_entries_notifier_test.dart     ← 11 unit test (sortLockerEntries:2, state transitions:7, foto pipeline:2)
    locker_filter_sort_test.dart          ← LockerFilter + applyFilterAndSort unit testleri
    locker_screen_test.dart               ← widget test (grid, filtre, sort, form incl. catalog seçimi)
  features/photos/
    photo_repository_test.dart            ← 2 unit test (başarılı upload URL, exception fırlatma)
    photo_compressor_test.dart            ← 2 unit test (non-empty bytes döner, exception fırlatma)
  features/onboarding/
    onboarding_notifier_test.dart         ← completeOnboarding state geçişi
    onboarding_camera_screen_test.dart    ← skip + add kit butonu widget testleri
  features/social/
    follow_repository_test.dart           ← 12 unit test (follow, unfollow, isFollowing, getFollowers, getFollowing, notify)
    follow_toggle_notifier_test.dart      ← 9 unit test (başlangıç durumu, toggle follow/unfollow, notify çağrısı)
    profile_screen_test.dart              ← 8 widget test (kullanıcı adı, follow butonu, toggle, kendi profili)
  widget_test.dart                        ← smoke test
Toplam: 116 test GREEN
tool/
  seed_kit_catalog.dart                   ← FKAPI → kit_catalog idempotent upsert (FKAPI_BASE_URL veya dev fixture)
supabase/
  migrations/
    20260514000001_create_profiles.sql          ← profiles tablosu, citext, unique index, RLS
    20260514000002_username_cooldown.sql         ← update_username() fonksiyonu, 30 gün cooldown
    20260514000003_create_locker_entries.sql     ← locker_entries tablosu, RLS (select/insert/update/delete own)
    20260514233219_profiles_rls_insert_policy.sql    ← profiles INSERT policy (authenticated role)
    20260514234158_grant_profiles_to_authenticated.sql   ← GRANT SELECT/INSERT/UPDATE on profiles
    20260514234544_grant_locker_entries_to_authenticated.sql ← GRANT SELECT/INSERT/UPDATE/DELETE on locker_entries
    20260519000001_create_kit_catalog.sql     ← kit_catalog tablosu, RLS read-only, locker_entries FK
  functions/
    recognize-kit/index.ts                  ← Gemini Flash vision → structured kit metadata (GEMINI_API_KEY secret)
```

**Auth redirect mantığı:** `AuthLoading → /splash`, `Authenticated → /home`, `Unauthenticated → /auth`, `AuthError → /auth`

**AppRoutes:** `abstract final class` — `splash`, `auth`, `home`, `onboardingCamera` path sabitleri + `locker = '/locker'`, `lockerAdd = '/locker/add'`, `lockerDetail(String id) → '/locker/$id'`. Social: `profile(String userId) → '/profile/$userId'`, `profileFollowers(userId)`, `profileFollowing(userId)`. GoRouter'da `/locker` ve `/profile/:userId` altında nested alt rotalar tanımlı.

**AuthNotifier pattern:** `Notifier<AuthState>` — `build()` önce `_supabase.auth.currentSession`'ı senkron okur (null → `Unauthenticated`, non-null → `Authenticated`), ardından `onAuthStateChange` stream'i dinler. `AuthLoading` artık sadece geçiş anında kullanılır, başlangıç state'i değil. `register()` e-posta doğrulama gerektiren durumda (`session == null`) `AuthError('E-posta adresinizi doğrulayın.')` döner. Public interface: `signIn(email, password)`, `register(email, password, username)`, `signOut()`. Supabase client: `Supabase.instance.client` singleton.

**LockerEntriesNotifier pattern:** `AsyncNotifier<List<LockerEntry>>` — `build()` Supabase'den yükler (RLS userId filtresi), `AsyncLoading → AsyncData | AsyncError`. Public interface: `add({teamName, season, condition, kitCatalogId?, leagueId?, playerName?, number?, notes?, photos?: List<String>})`, `addWithPhotos(...)`, `remove(id)`, `updateEntry(LockerEntry)`, `toggleFavourite(id)`. Mutasyonlar `state.requireValue` ile mevcut listeye erişir, `AsyncData(sortLockerEntries(...))` ile günceller. `lockerEntriesProvider = AsyncNotifierProvider<LockerEntriesNotifier, List<LockerEntry>>`.

**KitCatalogSearcher pattern:** `KitCatalogSearcher.search(catalog, {teamQuery, season?, kitType?})` — pure Dart, client-side. Kısaltma (prefix/contains), trigram benzeri typo toleransı, Türkçe karakter normalizasyonu. `searchCatalog()` ve `searchKitCatalog()` repository katmanından export edilir.

**CatalogRepository pattern:** `abstract class CatalogRepository { fetchCatalog() }` — `SupabaseCatalogRepository` `kit_catalog` tablosunu okur. `kitCatalogProvider` FutureProvider ile cache'ler. Form: `showCatalogSearchSheet()` → seçim `teamName`/`season` doldurur, submit `kitCatalogId` + `leagueId` gönderir.

**KitRecognition pattern:** `RecognitionCoordinator.recognize(imageBytes, catalog)` → `RecognitionOutcome`. Form compresses picked photo via `PhotoCompressor` (WebP) before invoke. `SupabaseKitRecognitionRepository` calls Edge Function `recognize-kit` with base64 WebP; Edge Function sends `image/webp` to Gemini. Returns `KitRecognitionResult`. `KitRecognitionPrefill.suggest(result)` returns form values when `confidence >= KitRecognitionConfig.confidenceThreshold` (0.7) and team/season present. `KitRecognitionCatalogMatcher.match(catalog, result)` picks best `KitCatalogEntry` via `KitCatalogSearcher`. `LockerEntryRecognitionApplier.apply(outcome, currentTeamName, currentSeason)` skips pre-fill if user already entered team or season. Form: after `pickImage` on add flow → loading (`form_recognition_loading`) → pre-fill or SnackBar on error; kit save never blocked.

**sortLockerEntries:** `lib/features/locker/providers/locker_entries_notifier.dart`'da top-level pure function. Sıralama: `isFavourite: true` önce, sonra `createdAt` desc. Hem notifier hem test fake aynı fonksiyonu kullanır.

**Test override pattern (auth):** `authStateProvider.overrideWith(() => FakeAuthNotifier())` — `FakeAuthNotifier extends AuthNotifier`, `lastRegisterCall` / `lastSignInCall` alanları ile çağrı doğrulama.

**Test override pattern (locker):** `lockerEntriesProvider.overrideWith(() => FakeLockerEntriesNotifier(initial))` — `FakeLockerEntriesNotifier extends LockerEntriesNotifier`, `build()` `async => List.of(_initial)` ile Supabase'siz çalışır. Unit testlerde `await container.read(lockerEntriesProvider.future)` ile ilk yükleme beklenir. Capture alanları: `lastAddCall` / `lastRemoveCall` / `lastUpdateCall` / `lastToggleFavouriteCall`. Mutasyonlar `state.valueOrNull ?? []` kullanır (widget testlerinde provider henüz başlatılmamış olabilir). `fakeEntry({id, teamName, season, condition, isFavourite, createdAt})` builder fonksiyonu ile test verisi oluşturulur.

**PhotoRepository pattern:** `abstract interface class PhotoRepository` — tek metot: `uploadPhoto(Uint8List bytes, String userId) → Future<String>`. Implementasyon: `SupabasePhotoRepository` — `kit-photos` bucket'ına `$userId/${uuid}.webp` yolunda yükler, `getPublicUrl(path)` döner. Provider: `photoRepositoryProvider = Provider<PhotoRepository>(_ => SupabasePhotoRepository(Supabase.instance.client))`.

**PhotoCompressor pattern:** `abstract interface class PhotoCompressor` — tek metot: `compress(Uint8List bytes) → Future<Uint8List>`. Implementasyon: `FlutterImageCompressPhotoCompressor(quality: 85)` — `flutter_image_compress` paketini kullanır, WebP format, quality 85. Provider: `photoCompressorProvider = Provider<PhotoCompressor>(_ => const FlutterImageCompressPhotoCompressor())`.

**Test fakes (photos):** `FakePhotoRepository(returnUrl, shouldThrow)` — `lastUploadedBytes` / `lastUploadedUserId` capture alanları. `FakePhotoCompressor(shouldThrow)` — `lastInput` capture alanı, tek byte dönerek sıkıştırmayı simüle eder.

**Test fakes (recognition):** `FakeKitRecognitionRepository(result, shouldThrow)` — `lastImageBytes` capture. `FakeImagePickerService(file)` — overrides `imagePickerServiceProvider` for form tests. Recognition behavior is covered by unit tests on coordinator/prefill/applier (not widget tests with `Image.file`).

**Form widget test pattern:** `LockerEntryFormScreen` widget testleri için gerekli override'lar: `authStateProvider` (→ `FakeAuthNotifier(Authenticated(userId: 'test-user'))`), `lockerEntriesProvider`, `photoRepositoryProvider`, `photoCompressorProvider`. ListView lazy-build nedeniyle submit butonu varsayılan 600px viewport'ta element tree'e girmiyor — `tester.view.physicalSize = const Size(800, 2000)` ile viewport büyütülmeli (tearDown'da `tester.view.resetPhysicalSize`). Hata yolu testi için `_ThrowingLockerEntriesNotifier extends LockerEntriesNotifier` (add() throws) lokal fake olarak test dosyasında tanımlanır.

**FollowRepository pattern:** `abstract interface class FollowRepository` — `follow(followerId, followeeId)`, `unfollow(followerId, followeeId)`, `isFollowing(followerId, followeeId) → Future<bool>`, `getFollowers(userId) → Future<List<UserProfile>>`, `getFollowing(userId) → Future<List<UserProfile>>`, `notifyNewFollower(followerId, followeeId)` (Edge Function stub, hata yutarak çalışır). `SupabaseFollowRepository` iki aşamalı sorgu kullanır: önce follower_id listesi çeker, sonra `inFilter('id', ids)` ile profiles'dan UserProfile'ları alır — PostgREST doğrudan join yok. Provider: `followRepositoryProvider = Provider<FollowRepository>`.

**FollowToggleNotifier pattern:** `FamilyAsyncNotifier<bool, String>` (arg = targetUserId) — `build(targetUserId)`: `authStateProvider` watch eder, `isFollowing(currentUser, targetUserId)` döner. `toggle()`: follow ise `unfollow()` + `state = AsyncData(false)`, değilse `follow()` + `notifyNewFollower()` + `state = AsyncData(true)`. Her iki durumda `ref.invalidate(followersOfProvider(arg))` ve `ref.invalidate(followingOfProvider(currentUserId))`. Provider: `followToggleProvider = AsyncNotifierProvider.family`.

**FollowersNotifier / FollowingNotifier pattern:** `FamilyAsyncNotifier<List<UserProfile>, String>` — `build(userId)` sadece `followRepositoryProvider.getFollowers/getFollowing(userId)` döner. Provider: `followersOfProvider`, `followingOfProvider`.

**userProfileProvider:** `FutureProvider.family<UserProfile?, String>` — `profiles` tablosundan `id, username` çeker, `maybeSingle()` ile yoksa null döner.

**ProfileScreen pattern:** `ProfileScreen(userId)` — `authStateProvider`'dan currentUserId alır, `isOwnProfile = currentUserId == userId` kontrolü. AppBar actions'da `_FollowButton(targetUserId)` — sadece başkasının profilinde. Body: `_CountTile` (tıklanabilir, `context.push(AppRoutes.profileFollowers/Following(userId))`). Followers/Following sayıları `followersOfProvider`/`followingOfProvider` ile.

**HomeScreen TabBar pattern:** `ConsumerStatefulWidget`, `_currentIndex` state, `IndexedStack([LockerScreen(), ProfileScreen(userId)])`, `BottomNavigationBar` ile tab geçişi.

**Test override pattern (social):** `followRepositoryProvider.overrideWithValue(FakeFollowRepository())` — tüm social testlerde. `userProfileProvider.overrideWith((ref, uid) async => fakeProfile(...))` — FutureProvider.family override syntax. `FakeFollowRepository` — `Set<(String, String)>` ile takip grafiği, `seedProfile()` ile profil ekleme, `lastNotifyCall` capture.

**l10n:** `l10n.yaml` — `output-dir` kullanılmıyor; `flutter gen-l10n` çıktısı doğrudan `lib/l10n/` içine yazılır. `synthetic-package: false` (deprecated warning, işlevsel değil). `lib/l10n/generated/` klasörü yoktur — bu dizin varsa stale artefact, silinebilir.

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

RLS aktif. Policies: `profiles_select_public` (herkes okur), `profiles_insert_own` / `profiles_update_own` / `users can insert own profile` (sadece kendi kaydı). GRANT: `authenticated` ve `anon` rollerine SELECT/INSERT/UPDATE verildi.

**#18 eklenenler:** `onboarding_completed_at timestamptz nullable` (OnboardingNotifier), `fcm_token text nullable` (notify-new-follower Edge Function, #14'te aktif).

`update_username(new_username citext)` — SECURITY DEFINER fonksiyon. 30 gün geçmemişse `raise exception` ile reddeder. Sadece `authenticated` role çağırabilir.

### locker_entries
| Kolon | Tip | Kısıt |
|-------|-----|-------|
| id | uuid | PK, DEFAULT gen_random_uuid() |
| user_id | uuid | NOT NULL, FK → auth.users(id) ON DELETE CASCADE |
| kit_catalog_id | uuid | nullable, FK → kit_catalog(id) ON DELETE SET NULL |
| team_name | text | NOT NULL |
| league_id | text | nullable — FKAPI competition id |
| season | text | NOT NULL |
| player_name | text | nullable |
| number | text | nullable |
| condition | text | NOT NULL, CHECK IN ('mint','excellent','good','worn') |
| notes | text | nullable |
| photos | text[] | NOT NULL DEFAULT '{}' |
| visualization_url | text | nullable — Ghost Mannequin render URL'i |
| is_favourite | boolean | NOT NULL DEFAULT false |
| created_at | timestamptz | NOT NULL DEFAULT now() |

RLS aktif. Policies: `locker_entries_select_own`, `locker_entries_insert_own`, `locker_entries_update_own`, `locker_entries_delete_own` — hepsi `auth.uid() = user_id` ile kısıtlı. GRANT: `authenticated` rolüne SELECT/INSERT/UPDATE/DELETE verildi.

**Dart model:** `LockerEntry` — `fromJson(Map)` snake_case → camelCase, `toJson()` insert/update payload için (id ve created_at hariç), `copyWith(...)` immutable güncelleme. `LockerCondition` enum'u `.name` ile serileşir.

### follows
| Kolon | Tip | Kısıt |
|-------|-----|-------|
| id | uuid | PK, DEFAULT gen_random_uuid() |
| follower_id | uuid | NOT NULL, FK → auth.users(id) ON DELETE CASCADE |
| followee_id | uuid | NOT NULL, FK → auth.users(id) ON DELETE CASCADE |
| created_at | timestamptz | NOT NULL DEFAULT now() |
| — | — | UNIQUE (follower_id, followee_id), CHECK follower_id <> followee_id |

RLS aktif. Policies: `follows_select` (authenticated SELECT all), `follows_insert` (follower_id = auth.uid()), `follows_delete` (follower_id = auth.uid()). GRANT SELECT/INSERT/DELETE `authenticated`.

### kit_catalog
| Kolon | Tip | Kısıt |
|-------|-----|-------|
| id | uuid | PK, DEFAULT gen_random_uuid() |
| fkapi_kit_id | text | UNIQUE — idempotent seed anahtarı |
| team_name | text | NOT NULL |
| league_id | text | NOT NULL — FKAPI competition id |
| season | text | NOT NULL |
| kit_type | text | NOT NULL, CHECK IN ('home','away','third') |
| image_url | text | nullable |
| created_at | timestamptz | NOT NULL DEFAULT now() |

RLS aktif. Policy: `kit_catalog_select_authenticated` — authenticated kullanıcılar SELECT. GRANT SELECT `authenticated`. Kaynak: FKAPI (ADR-0009), `tool/seed_kit_catalog.dart` ile seed.

**Dart model:** `KitCatalogEntry` + `KitType` enum. Read-only; kullanıcı katkısı yok.

### Supabase Storage Buckets

| Bucket | Erişim | Yol Yapısı | Kullanım |
|--------|--------|------------|----------|
| `kit-photos` | Public read, owner write (RLS) | `{userId}/{uuid}.webp` | Kullanıcı kit fotoğrafları (WebP, quality 85) |
| `kit-renders` | Public read, owner write | `{userId}/{uuid}.webp` | Ghost Mannequin render çıktıları |
| `avatars` | Public read, owner write | `{userId}/avatar.webp` | Profil fotoğrafları |

`kit-photos` bucket V1'de implement edildi. `kit-renders` ve `avatars` Ghost Mannequin (#9+) ve profil issue'larında eklenecek.

## Supabase Edge Functions (V1)

| Function | Secret(s) | Purpose |
|----------|-----------|---------|
| `recognize-kit` | `GEMINI_API_KEY`, optional `GEMINI_MODEL` | Jersey photo → structured metadata via Gemini Flash (#8) |
| `notify-new-follower` | `FCM_SERVER_KEY` (gerekli, #14'te set edilecek) | Follow event → FCM push to followee. Token yoksa `{sent: false}` döner, hata fırlatmaz (#18) |

Deploy: `supabase functions deploy <function-name>`. Client invokes via `Supabase.instance.client.functions.invoke(name, body: {...})`.
