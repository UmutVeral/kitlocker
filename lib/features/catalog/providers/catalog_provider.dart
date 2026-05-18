import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../catalog_repository.dart';
import '../models/kit_catalog_entry.dart';
import '../models/kit_type.dart';
import '../supabase_catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => SupabaseCatalogRepository(sb.Supabase.instance.client),
);

final kitCatalogProvider = FutureProvider<List<KitCatalogEntry>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchCatalog(),
);

List<KitCatalogEntry> searchKitCatalog(
  List<KitCatalogEntry> catalog, {
  required String teamQuery,
  String? season,
  KitType? kitType,
}) =>
    searchCatalog(
      catalog,
      teamQuery: teamQuery,
      season: season,
      kitType: kitType,
    );
