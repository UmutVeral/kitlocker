import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/catalog/kit_catalog_searcher.dart';
import 'package:kitlocker/features/catalog/models/kit_catalog_entry.dart';
import 'package:kitlocker/features/catalog/models/kit_type.dart';

KitCatalogEntry _entry({
  required String id,
  required String teamName,
  String season = '2024-25',
  KitType kitType = KitType.home,
  String leagueId = 'super-lig',
}) =>
    KitCatalogEntry(
      id: id,
      teamName: teamName,
      leagueId: leagueId,
      season: season,
      kitType: kitType,
    );

void main() {
  late KitCatalogSearcher searcher;
  late List<KitCatalogEntry> catalog;

  setUp(() {
    searcher = KitCatalogSearcher();
    catalog = [
      _entry(id: '1', teamName: 'Galatasaray'),
      _entry(id: '2', teamName: 'Fenerbahçe'),
      _entry(id: '3', teamName: 'Beşiktaş'),
    ];
  });

  group('KitCatalogSearcher', () {
    test('kısaltma ile arama: Gala → Galatasaray', () {
      final results = searcher.search(
        catalog,
        teamQuery: 'Gala',
      );

      expect(results, hasLength(1));
      expect(results.first.teamName, 'Galatasaray');
    });

    test('yazım hatası tolere edilir: Galatasaray → Galatasaray', () {
      final results = searcher.search(
        catalog,
        teamQuery: 'Galatasary',
      );

      expect(results, hasLength(1));
      expect(results.first.teamName, 'Galatasaray');
    });

    test('sezon filtresi eşleşmeyen kayıtları eler', () {
      final mixedSeason = [
        _entry(id: '1', teamName: 'Galatasaray', season: '2023-24'),
        _entry(id: '2', teamName: 'Galatasaray', season: '2024-25'),
      ];

      final results = searcher.search(
        mixedSeason,
        teamQuery: 'Galatasaray',
        season: '2024-25',
      );

      expect(results, hasLength(1));
      expect(results.first.season, '2024-25');
    });

    test('kit tipi filtresi eşleşmeyen kayıtları eler', () {
      final mixedType = [
        _entry(id: '1', teamName: 'Galatasaray', kitType: KitType.home),
        _entry(id: '2', teamName: 'Galatasaray', kitType: KitType.away),
      ];

      final results = searcher.search(
        mixedType,
        teamQuery: 'Galatasaray',
        kitType: KitType.away,
      );

      expect(results, hasLength(1));
      expect(results.first.kitType, KitType.away);
    });

    test('bilinmeyen takım boş liste döner', () {
      final results = searcher.search(
        catalog,
        teamQuery: 'Nonexistent FC',
      );

      expect(results, isEmpty);
    });

    test('belirsiz arama birden fazla sonuç döner', () {
      final ambiguousCatalog = [
        _entry(id: '1', teamName: 'Manchester United'),
        _entry(id: '2', teamName: 'Manchester City'),
      ];

      final results = searcher.search(
        ambiguousCatalog,
        teamQuery: 'Manchester',
      );

      expect(results, hasLength(2));
    });
  });
}
