// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get homeGreeting => 'KitLocker\'a hoş geldin';

  @override
  String get lockerTab => 'Locker';

  @override
  String get profileTab => 'Profil';

  @override
  String get followButton => 'Takip Et';

  @override
  String get unfollowButton => 'Takipten Çık';

  @override
  String get followersLabel => 'Takipçi';

  @override
  String get followingLabel => 'Takip';

  @override
  String get noFollowers => 'Henüz takipçi yok';

  @override
  String get noFollowing => 'Henüz kimseyi takip etmiyor';
}
