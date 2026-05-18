import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'catalog_repository.dart';
import 'models/kit_catalog_entry.dart';

class SupabaseCatalogRepository implements CatalogRepository {
  SupabaseCatalogRepository(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<List<KitCatalogEntry>> fetchCatalog() async {
    final data = await _client.from('kit_catalog').select();
    return (data as List)
        .map((row) => KitCatalogEntry.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
