import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/catalog/models/kit_catalog_entry.dart';
import 'package:kitlocker/features/catalog/models/kit_type.dart';
import 'package:kitlocker/features/recognition/kit_recognition_repository.dart';
import 'package:kitlocker/features/recognition/models/kit_recognition_result.dart';
import 'package:kitlocker/features/recognition/recognition_coordinator.dart';
import 'package:kitlocker/features/recognition/recognition_outcome.dart';

class _FakeRecognitionRepo implements KitRecognitionRepository {
  _FakeRecognitionRepo({this.result, this.error});

  final KitRecognitionResult? result;
  final Object? error;

  Uint8List? lastImage;

  @override
  Future<KitRecognitionResult> recognize(Uint8List imageBytes) async {
    lastImage = imageBytes;
    if (error != null) throw error!;
    return result!;
  }
}

void main() {
  final catalog = [
    const KitCatalogEntry(
      id: 'cat-1',
      teamName: 'Galatasaray',
      leagueId: 'super-lig',
      season: '2024-25',
      kitType: KitType.home,
    ),
  ];

  group('RecognitionCoordinator', () {
    test('yüksek confidence → prefill + catalog match', () async {
      final repo = _FakeRecognitionRepo(
        result: const KitRecognitionResult(
          team: 'Galatasaray',
          season: '2024-25',
          playerName: 'Icardi',
          number: '9',
          confidence: 0.9,
        ),
      );
      final coordinator = RecognitionCoordinator(repository: repo);

      final outcome = await coordinator.recognize(
        imageBytes: Uint8List.fromList([1, 2, 3]),
        catalog: catalog,
      );

      expect(outcome, isA<RecognitionPrefillSuggested>());
      final suggested = outcome as RecognitionPrefillSuggested;
      expect(suggested.formValues.teamName, 'Galatasaray');
      expect(suggested.catalogEntry?.id, 'cat-1');
    });

    test('düşük confidence → manuel giriş', () async {
      final coordinator = RecognitionCoordinator(
        repository: _FakeRecognitionRepo(
          result: const KitRecognitionResult(
            team: 'Galatasaray',
            season: '2024-25',
            confidence: 0.4,
          ),
        ),
      );

      final outcome = await coordinator.recognize(
        imageBytes: Uint8List.fromList([1]),
        catalog: catalog,
      );

      expect(outcome, isA<RecognitionManualEntry>());
    });

    test('recognition hata → manuel giriş', () async {
      final coordinator = RecognitionCoordinator(
        repository: _FakeRecognitionRepo(error: Exception('timeout')),
      );

      final outcome = await coordinator.recognize(
        imageBytes: Uint8List.fromList([1]),
        catalog: catalog,
      );

      expect(outcome, isA<RecognitionManualEntry>());
      expect((outcome as RecognitionManualEntry).hadError, isTrue);
    });
  });
}
