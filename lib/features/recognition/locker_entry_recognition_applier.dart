import '../catalog/models/kit_catalog_entry.dart';
import 'models/kit_recognition_form_values.dart';
import 'recognition_outcome.dart';

/// Applies recognition outcome to locker entry form state.
class LockerEntryRecognitionApplier {
  const LockerEntryRecognitionApplier._();

  static RecognitionApplyResult apply({
    required RecognitionOutcome outcome,
    required String currentTeamName,
    required String currentSeason,
  }) {
    switch (outcome) {
      case RecognitionPrefillSuggested():
        if (currentTeamName.trim().isNotEmpty || currentSeason.trim().isNotEmpty) {
          return RecognitionApplyResult.skippedUserFilled();
        }
        return RecognitionApplyResult.prefill(
          formValues: outcome.formValues,
          catalogEntry: outcome.catalogEntry,
        );
      case RecognitionManualEntry(:final hadError):
        return RecognitionApplyResult.manual(hadError: hadError);
    }
  }
}

class RecognitionApplyResult {
  const RecognitionApplyResult._({
    required this.kind,
    this.formValues,
    this.catalogEntry,
    this.hadError = false,
  });

  factory RecognitionApplyResult.prefill({
    required KitRecognitionFormValues formValues,
    KitCatalogEntry? catalogEntry,
  }) =>
      RecognitionApplyResult._(
        kind: RecognitionApplyKind.prefill,
        formValues: formValues,
        catalogEntry: catalogEntry,
      );

  factory RecognitionApplyResult.manual({bool hadError = false}) =>
      RecognitionApplyResult._(
        kind: RecognitionApplyKind.manual,
        hadError: hadError,
      );

  factory RecognitionApplyResult.skippedUserFilled() =>
      const _SkippedRecognitionApplyResult();

  final RecognitionApplyKind kind;
  final KitRecognitionFormValues? formValues;
  final KitCatalogEntry? catalogEntry;
  final bool hadError;
}

enum RecognitionApplyKind { prefill, manual, skipped }

class _SkippedRecognitionApplyResult extends RecognitionApplyResult {
  const _SkippedRecognitionApplyResult()
      : super._(kind: RecognitionApplyKind.skipped);
}
