import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/catalog/models/kit_catalog_entry.dart';
import 'package:kitlocker/features/catalog/models/kit_type.dart';
import 'package:kitlocker/features/recognition/locker_entry_recognition_applier.dart';
import 'package:kitlocker/features/recognition/models/kit_recognition_form_values.dart';
import 'package:kitlocker/features/recognition/recognition_outcome.dart';

void main() {
  const prefill = KitRecognitionFormValues(
    teamName: 'Galatasaray',
    season: '2024-25',
    playerName: 'Icardi',
    number: '9',
  );

  const catalogEntry = KitCatalogEntry(
    id: 'cat-1',
    teamName: 'Galatasaray',
    leagueId: 'super-lig',
    season: '2024-25',
    kitType: KitType.home,
  );

  test('yüksek confidence outcome → prefill değerleri', () {
    final result = LockerEntryRecognitionApplier.apply(
      outcome: RecognitionPrefillSuggested(
        formValues: prefill,
        catalogEntry: catalogEntry,
      ),
      currentTeamName: '',
      currentSeason: '',
    );

    expect(result.kind, RecognitionApplyKind.prefill);
    expect(result.formValues?.teamName, 'Galatasaray');
    expect(result.catalogEntry?.id, 'cat-1');
  });

  test('kullanıcı alan doldurmuşsa prefill atlanır', () {
    final result = LockerEntryRecognitionApplier.apply(
      outcome: RecognitionPrefillSuggested(formValues: prefill),
      currentTeamName: 'Fenerbahçe',
      currentSeason: '2023-24',
    );

    expect(result.kind, RecognitionApplyKind.skipped);
  });
}
