import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'photo_compressor.dart';

class FlutterImageCompressPhotoCompressor implements PhotoCompressor {
  const FlutterImageCompressPhotoCompressor({this.quality = 85});

  final int quality;

  @override
  Future<Uint8List> compress(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      format: CompressFormat.webp,
      quality: quality,
    );
    return result;
  }
}
