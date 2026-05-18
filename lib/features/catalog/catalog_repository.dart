import 'kit_catalog_searcher.dart';
import 'models/kit_catalog_entry.dart';
import 'models/kit_type.dart';

abstract class CatalogRepository {
  Future<List<KitCatalogEntry>> fetchCatalog();
}

List<KitCatalogEntry> searchCatalog(
  List<KitCatalogEntry> catalog, {
  required String teamQuery,
  String? season,
  KitType? kitType,
}) {
  return const KitCatalogSearcher().search(
    catalog,
    teamQuery: teamQuery,
    season: season,
    kitType: kitType,
  );
}
