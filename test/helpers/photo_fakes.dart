import 'dart:typed_data';

import 'package:kitlocker/features/photos/photo_compressor.dart';
import 'package:kitlocker/features/photos/photo_repository.dart';

class FakePhotoRepository implements PhotoRepository {
  FakePhotoRepository({this.returnUrl = '', this.shouldThrow = false});

  final String returnUrl;
  final bool shouldThrow;

  Uint8List? lastUploadedBytes;
  String? lastUploadedUserId;

  @override
  Future<String> uploadPhoto(Uint8List bytes, String userId) async {
    if (shouldThrow) throw Exception('upload failed');
    lastUploadedBytes = bytes;
    lastUploadedUserId = userId;
    return returnUrl;
  }
}

class FakePhotoCompressor implements PhotoCompressor {
  FakePhotoCompressor({this.shouldThrow = false});

  final bool shouldThrow;

  Uint8List? lastInput;

  @override
  Future<Uint8List> compress(Uint8List bytes) async {
    if (shouldThrow) throw Exception('compression failed');
    lastInput = bytes;
    // Simüle edilmiş sıkıştırma: ilk byte'ı tut, geri kalanı at
    return Uint8List.fromList(bytes.isEmpty ? [] : [bytes.first]);
  }
}
