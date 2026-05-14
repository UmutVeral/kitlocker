class UsernameValidator {
  static final _pattern = RegExp(r'^[a-zA-Z0-9_]{3,30}$');

  static String? validate(String username) {
    if (_pattern.hasMatch(username)) return null;
    if (username.isEmpty) return 'Kullanıcı adı boş olamaz';
    if (username.length < 3) return 'Kullanıcı adı en az 3 karakter olmalı';
    if (username.length > 30) return 'Kullanıcı adı en fazla 30 karakter olabilir';
    return 'Kullanıcı adı sadece harf, rakam ve alt çizgi içerebilir';
  }
}
