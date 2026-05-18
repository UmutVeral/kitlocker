import '../catalog/kit_catalog_searcher.dart';
import '../catalog/models/kit_catalog_entry.dart';
import 'models/kit_recognition_result.dart';

/// Validates AI recognition output against the local kit catalog snapshot.
class KitRecognitionCatalogMatcher {
  const KitRecognitionCatalogMatcher({KitCatalogSearcher? searcher})
      : _searcher = searcher ?? const KitCatalogSearcher();

  final KitCatalogSearcher _searcher;

  KitCatalogEntry? match(
    List<KitCatalogEntry> catalog,
    KitRecognitionResult result,
  ) {
    final team = result.team?.trim();
    if (team == null || team.isEmpty) return null;

    final season = result.season?.trim();
    final results = _searcher.search(
      catalog,
      teamQuery: team,
      season: season?.isEmpty ?? true ? null : season,
    );

    return results.isEmpty ? null : results.first;
  }
}
