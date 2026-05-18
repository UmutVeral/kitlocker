import 'dart:typed_data';

abstract interface class PhotoRepository {
  Future<String> uploadPhoto(Uint8List bytes, String userId);
}
