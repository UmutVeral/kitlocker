import 'dart:typed_data';

abstract interface class PhotoCompressor {
  Future<Uint8List> compress(Uint8List bytes);
}
