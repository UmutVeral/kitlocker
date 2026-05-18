import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/recognition/kit_recognition_prefill.dart';
import 'package:kitlocker/features/recognition/models/kit_recognition_result.dart';

void main() {
  group('KitRecognitionPrefill', () {
    test('yüksek confidence → form alanları önerilir', () {
      const result = KitRecognitionResult(
        team: 'Galatasaray',
        league: 'Süper Lig',
        season: '2024-25',
        playerName: 'Icardi',
        number: '9',
        confidence: 0.85,
      );

      final prefill = KitRecognitionPrefill.suggest(result);

      expect(prefill, isNotNull);
      expect(prefill!.teamName, 'Galatasaray');
      expect(prefill.season, '2024-25');
      expect(prefill.playerName, 'Icardi');
      expect(prefill.number, '9');
    });

    test('düşük confidence → prefill yok', () {
      const result = KitRecognitionResult(
        team: 'Galatasaray',
        season: '2024-25',
        confidence: 0.5,
      );

      expect(KitRecognitionPrefill.suggest(result), isNull);
    });
  });
}
