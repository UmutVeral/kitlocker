import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/catalog/models/kit_catalog_entry.dart';
import 'package:kitlocker/features/catalog/models/kit_type.dart';
import 'package:kitlocker/features/recognition/kit_recognition_catalog_matcher.dart';
import 'package:kitlocker/features/recognition/models/kit_recognition_result.dart';

void main() {
  late List<KitCatalogEntry> catalog;

  setUp(() {
    catalog = [
      const KitCatalogEntry(
        id: 'cat-1',
        teamName: 'Galatasaray',
        leagueId: 'super-lig',
        season: '2024-25',
        kitType: KitType.home,
      ),
    ];
  });

  test('AI takım + sezon catalog kaydıyla eşleşir', () {
    const result = KitRecognitionResult(
      team: 'Galatasaray',
      season: '2024-25',
      confidence: 0.9,
    );

    final match = const KitRecognitionCatalogMatcher().match(catalog, result);

    expect(match?.id, 'cat-1');
    expect(match?.leagueId, 'super-lig');
  });

  test('yazım hatası fuzzy match ile catalog bulur', () {
    const result = KitRecognitionResult(
      team: 'Galatasary',
      season: '2024-25',
      confidence: 0.9,
    );

    final match = const KitRecognitionCatalogMatcher().match(catalog, result);

    expect(match?.teamName, 'Galatasaray');
  });
}
