import 'dart:typed_data';

import 'package:kitlocker/features/recognition/kit_recognition_repository.dart';
import 'package:kitlocker/features/recognition/models/kit_recognition_result.dart';
import 'package:kitlocker/features/photos/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

class FakeKitRecognitionRepository implements KitRecognitionRepository {
  FakeKitRecognitionRepository({
    this.result,
    this.shouldThrow = false,
  });

  final KitRecognitionResult? result;
  final bool shouldThrow;

  Uint8List? lastImageBytes;

  @override
  Future<KitRecognitionResult> recognize(Uint8List imageBytes) async {
    lastImageBytes = imageBytes;
    if (shouldThrow) throw Exception('recognition failed');
    return result ??
        const KitRecognitionResult(
          team: 'Galatasaray',
          season: '2024-25',
          confidence: 0.9,
        );
  }
}

class FakeImagePickerService implements ImagePickerService {
  FakeImagePickerService({this.file});

  XFile? file;

  @override
  Future<XFile?> pickImage(
    ImageSource source, {
    int imageQuality = 90,
  }) async =>
      file;
}
