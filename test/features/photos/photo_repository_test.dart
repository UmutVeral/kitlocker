import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/photos/photo_repository.dart';

import '../../helpers/photo_fakes.dart';

void main() {
  group('PhotoRepository — uploadPhoto contract', () {
    test('başarılı upload CDN URL döner', () async {
      final repo = FakePhotoRepository(
        returnUrl: 'https://cdn.example.com/kit-photos/user1/abc.webp',
      );

      final url = await repo.uploadPhoto(Uint8List(10), 'user1');

      expect(url, 'https://cdn.example.com/kit-photos/user1/abc.webp');
    });

    test('upload başarısız olduğunda exception fırlatır', () async {
      final repo = FakePhotoRepository(shouldThrow: true);

      expect(
        () => repo.uploadPhoto(Uint8List(10), 'user1'),
        throwsException,
      );
    });
  });
}
