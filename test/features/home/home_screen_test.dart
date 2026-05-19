import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/features/home/screens/home_screen.dart';
import 'package:kitlocker/features/locker/providers/locker_entries_notifier.dart';
import 'package:kitlocker/features/social/providers/follow_repository_provider.dart';
import 'package:kitlocker/features/social/providers/user_profile_provider.dart';
import 'package:kitlocker/l10n/app_localizations.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/locker_fakes.dart';
import '../../helpers/social_fakes.dart';

Widget _buildHome(Locale locale) {
  final repo = FakeFollowRepository();
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith(
        () => FakeAuthNotifier(const Authenticated(userId: 'user-1')),
      ),
      lockerEntriesProvider
          .overrideWith(() => FakeLockerEntriesNotifier()),
      followRepositoryProvider.overrideWithValue(repo),
      userProfileProvider.overrideWith(
        (ref, uid) async => fakeProfile(userId: uid, username: 'testuser'),
      ),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    ),
  );
}

void main() {
  group('HomeScreen — bottom navigation', () {
    testWidgets('TR locale\'de "Locker" ve "Profil" sekmeleri görünür',
        (tester) async {
      await tester.pumpWidget(_buildHome(const Locale('tr')));
      await tester.pumpAndSettle();

      expect(find.text('Locker'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });

    testWidgets('EN locale\'de "Locker" ve "Profile" sekmeleri görünür',
        (tester) async {
      await tester.pumpWidget(_buildHome(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Locker'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('başlangıçta Locker sekmesi aktif', (tester) async {
      await tester.pumpWidget(_buildHome(const Locale('tr')));
      await tester.pumpAndSettle();

      final nav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(nav.currentIndex, 0);
    });

    testWidgets('Profil sekmesine tıklayınca index 1 olur', (tester) async {
      await tester.pumpWidget(_buildHome(const Locale('tr')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profil'));
      await tester.pump();

      final nav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(nav.currentIndex, 1);
    });
  });
}
