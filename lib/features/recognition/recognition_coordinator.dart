import 'dart:typed_data';

import '../catalog/models/kit_catalog_entry.dart';
import 'kit_recognition_catalog_matcher.dart';
import 'kit_recognition_prefill.dart';
import 'kit_recognition_repository.dart';
import 'recognition_outcome.dart';

/// Orchestrates kit photo recognition and catalog validation.
class RecognitionCoordinator {
  RecognitionCoordinator({
    required KitRecognitionRepository repository,
    KitRecognitionCatalogMatcher? catalogMatcher,
  })  : _repository = repository,
        _catalogMatcher = catalogMatcher ?? const KitRecognitionCatalogMatcher();

  final KitRecognitionRepository _repository;
  final KitRecognitionCatalogMatcher _catalogMatcher;

  Future<RecognitionOutcome> recognize({
    required Uint8List imageBytes,
    required List<KitCatalogEntry> catalog,
  }) async {
    try {
      final result = await _repository.recognize(imageBytes);
      final formValues = KitRecognitionPrefill.suggest(result);
      if (formValues == null) {
        return RecognitionManualEntry();
      }

      final catalogEntry = _catalogMatcher.match(catalog, result);
      return RecognitionPrefillSuggested(
        formValues: formValues,
        catalogEntry: catalogEntry,
      );
    } catch (_) {
      return RecognitionManualEntry(hadError: true);
    }
  }
}
