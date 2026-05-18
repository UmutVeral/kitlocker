import '../catalog/models/kit_catalog_entry.dart';
import 'models/kit_recognition_form_values.dart';

sealed class RecognitionOutcome {}

class RecognitionPrefillSuggested extends RecognitionOutcome {
  RecognitionPrefillSuggested({
    required this.formValues,
    this.catalogEntry,
  });

  final KitRecognitionFormValues formValues;
  final KitCatalogEntry? catalogEntry;
}

class RecognitionManualEntry extends RecognitionOutcome {
  RecognitionManualEntry({this.hadError = false});

  final bool hadError;
}
