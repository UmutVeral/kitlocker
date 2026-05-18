import 'dart:typed_data';

import 'models/kit_recognition_result.dart';

abstract interface class KitRecognitionRepository {
  Future<KitRecognitionResult> recognize(Uint8List imageBytes);
}
