import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/features/social/providers/follow_repository_provider.dart';
import 'package:kitlocker/features/social/providers/user_profile_provider.dart';
import 'package:kitlocker/features/social/screens/profile_screen.dart';
import 'package:kitlocker/l10n/app_localizations.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/social_fakes.dart';

Widget _buildScreen({
  required String viewingUserId,
  required String currentUserId,
  required FakeFollowRepository repo,
}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith(
        () => FakeAuthNotifier(Authenticated(userId: currentUserId)),
      ),
      followRepositoryProvider.overrideWithValue(repo),
      userProfileProvider.overrideWith(
        (ref, uid) async => uid == 'alice'
            ? fakeProfile(userId: 'alice', username: 'alice_rocks')
            : uid == 'bob'
                ? fakeProfile(userId: 'bob', username: 'bob_plays')
                : null,
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProfileScreen(userId: viewingUserId),
    ),
  );
}

void main() {
  late FakeFollowRepository repo;

  setUp(() {
    repo = FakeFollowRepository();
    repo.seedProfile(fakeProfile(userId: 'alice', username: 'alice_rocks'));
    repo.seedProfile(fakeProfile(userId: 'bob', username: 'bob_plays'));
  });

  group('ProfileScreen — başka kullanıcı', () {
    testWidgets('kullanıcı adını gösterir', (tester) async {
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'bob',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('bob_plays'), findsOneWidget);
    });

    testWidgets('takipçi sayısını gösterir', (tester) async {
      await repo.follow('alice', 'bob');
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'bob',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_followers_count')), findsOneWidget);
    });

    testWidgets('takipte olmadığında "Takip Et" butonu görünür', (tester) async {
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'bob',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_follow_button')), findsOneWidget);
    });

    testWidgets('"Takip Et" tıklayınca repo güncellenir ve "Takipten Çık" görünür',
        (tester) async {
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'bob',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('profile_follow_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_unfollow_button')), findsOneWidget);
      expect(await repo.isFollowing('alice', 'bob'), isTrue);
    });

    testWidgets('takip ediyorken "Takipten Çık" butonu görünür', (tester) async {
      await repo.follow('alice', 'bob');
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'bob',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_unfollow_button')), findsOneWidget);
    });

    testWidgets('"Takipten Çık" tıklayınca repo güncellenir ve "Takip Et" görünür',
        (tester) async {
      await repo.follow('alice', 'bob');
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'bob',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('profile_unfollow_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_follow_button')), findsOneWidget);
      expect(await repo.isFollowing('alice', 'bob'), isFalse);
    });
  });

  group('ProfileScreen — kendi profili', () {
    testWidgets('follow/unfollow butonu görünmez', (tester) async {
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'alice',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_follow_button')), findsNothing);
      expect(find.byKey(const Key('profile_unfollow_button')), findsNothing);
    });

    testWidgets('kendi kullanıcı adını gösterir', (tester) async {
      await tester.pumpWidget(_buildScreen(
        viewingUserId: 'alice',
        currentUserId: 'alice',
        repo: repo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('alice_rocks'), findsOneWidget);
    });
  });
}
