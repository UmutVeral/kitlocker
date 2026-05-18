import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/photo_fakes.dart';

void main() {
  group('PhotoCompressor — compress contract', () {
    test('compress non-empty bytes döner', () async {
      final compressor = FakePhotoCompressor();

      final result = await compressor.compress(
        Uint8List.fromList([1, 2, 3, 4, 5]),
      );

      expect(result, isNotEmpty);
    });

    test('compress başarısız olduğunda exception fırlatır', () async {
      final compressor = FakePhotoCompressor(shouldThrow: true);

      expect(
        () => compressor.compress(Uint8List.fromList([1, 2, 3])),
        throwsException,
      );
    });
  });
}
