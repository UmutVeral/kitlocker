// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeGreeting => 'Welcome to KitLocker';

  @override
  String get lockerTab => 'Locker';

  @override
  String get profileTab => 'Profile';

  @override
  String get followButton => 'Follow';

  @override
  String get unfollowButton => 'Unfollow';

  @override
  String get followersLabel => 'Followers';

  @override
  String get followingLabel => 'Following';

  @override
  String get noFollowers => 'No followers yet';

  @override
  String get noFollowing => 'Not following anyone yet';
}
