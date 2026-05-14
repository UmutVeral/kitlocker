import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/core/auth/username_validator.dart';

void main() {
  group('UsernameValidator', () {
    test('geçerli username null döner', () {
      expect(UsernameValidator.validate('umut_42'), isNull);
    });

    test('3 karakterden kısa username hata döner', () {
      expect(UsernameValidator.validate('ab'), isNotNull);
    });

    test('30 karakterden uzun username hata döner', () {
      expect(UsernameValidator.validate('a' * 31), isNotNull);
    });

    test('tam 3 karakter geçerli', () {
      expect(UsernameValidator.validate('abc'), isNull);
    });

    test('tam 30 karakter geçerli', () {
      expect(UsernameValidator.validate('a' * 30), isNull);
    });

    test('harf ve rakam içeren username geçerli', () {
      expect(UsernameValidator.validate('Jersey99'), isNull);
    });

    test('boşluk içeren username hata döner', () {
      expect(UsernameValidator.validate('umut veral'), isNotNull);
    });

    test('tire (-) içeren username hata döner', () {
      expect(UsernameValidator.validate('umut-veral'), isNotNull);
    });

    test('alt çizgi (_) içeren username geçerli', () {
      expect(UsernameValidator.validate('umut_veral'), isNull);
    });

    test('boş string hata döner', () {
      expect(UsernameValidator.validate(''), isNotNull);
    });

    test('sadece rakam geçerli', () {
      expect(UsernameValidator.validate('123456'), isNull);
    });
  });
}
