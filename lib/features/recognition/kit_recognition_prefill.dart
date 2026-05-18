import 'kit_recognition_config.dart';
import 'models/kit_recognition_form_values.dart';
import 'models/kit_recognition_result.dart';

/// Maps a recognition result to optional form pre-fill values.
class KitRecognitionPrefill {
  const KitRecognitionPrefill._();

  static KitRecognitionFormValues? suggest(
    KitRecognitionResult result, {
    double threshold = KitRecognitionConfig.confidenceThreshold,
  }) {
    if (result.confidence < threshold) return null;

    final team = result.team?.trim();
    final season = result.season?.trim();
    if (team == null || team.isEmpty || season == null || season.isEmpty) {
      return null;
    }

    final player = result.playerName?.trim();
    final number = result.number?.trim();

    return KitRecognitionFormValues(
      teamName: team,
      season: season,
      playerName: (player == null || player.isEmpty) ? null : player,
      number: (number == null || number.isEmpty) ? null : number,
    );
  }
}
