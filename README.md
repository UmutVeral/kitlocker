# KitLocker

Digital jersey collection app with Ghost Mannequin visualization (Flutter + Supabase).

## Docs

- [CONTEXT.md](CONTEXT.md) — domain glossary, architecture, implemented modules
- [docs/prd-v1.md](docs/prd-v1.md) — V1 product requirements
- [docs/adr/](docs/adr/) — architecture decision records
- [GitHub Issues](https://github.com/UmutVeral/kitlocker/issues) — implementation tracker

## Status (V1)

| Done | Open |
|------|------|
| App shell, auth, locker CRUD, photo pipeline (#3–#6), kit catalog (#7), AI recognition (#8) | Ghost Mannequin, showcase, social, feed (#9–#25) |

## Dev

```bash
flutter pub get
flutter gen-l10n
flutter test
flutter run
```

Supabase env: `SUPABASE_URL` and `SUPABASE_ANON_KEY` (see `main.dart`).

### Kit recognition (production)

Recognition runs via the `recognize-kit` Edge Function (Gemini Flash). The API key is never in the Flutter app.

```bash
supabase secrets set GEMINI_API_KEY=<google_ai_studio_key>
supabase functions deploy recognize-kit
```

Optional: `GEMINI_MODEL` (default `gemini-2.0-flash`). See [ADR-0003](docs/adr/0003-kit-recognition-free-tier.md) and [CONTEXT.md](CONTEXT.md).
