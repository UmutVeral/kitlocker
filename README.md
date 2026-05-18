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
| App shell, auth, locker CRUD, photo pipeline (#3–#6) | Ghost Mannequin, AI recognition, showcase, social, feed (#7–#25) |

## Dev

```bash
flutter pub get
flutter gen-l10n
flutter test
flutter run
```

Supabase env: `SUPABASE_URL` and `SUPABASE_ANON_KEY` (see `main.dart`).
