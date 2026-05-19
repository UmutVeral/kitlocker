import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/features/social/providers/follow_repository_provider.dart';
import 'package:kitlocker/features/social/providers/follow_toggle_notifier.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/social_fakes.dart';

ProviderContainer _container({
  required String currentUserId,
  required FakeFollowRepository repo,
}) {
  final c = ProviderContainer(overrides: [
    authStateProvider.overrideWith(
      () => FakeAuthNotifier(Authenticated(userId: currentUserId)),
    ),
    followRepositoryProvider.overrideWithValue(repo),
  ]);
  addTearDown(c.dispose);
  return c;
}

void main() {
  late FakeFollowRepository repo;

  setUp(() {
    repo = FakeFollowRepository();
    repo.seedProfile(fakeProfile(userId: 'alice', username: 'alice'));
    repo.seedProfile(fakeProfile(userId: 'bob', username: 'bob'));
  });

  group('FollowToggleNotifier — başlangıç durumu', () {
    test('takip etmiyorsa false döner', () async {
      final c = _container(currentUserId: 'alice', repo: repo);
      final result = await c.read(followToggleProvider('bob').future);
      expect(result, isFalse);
    });

    test('takip ediyorsa true döner', () async {
      await repo.follow('alice', 'bob');
      final c = _container(currentUserId: 'alice', repo: repo);
      final result = await c.read(followToggleProvider('bob').future);
      expect(result, isTrue);
    });

    test('auth yoksa false döner', () async {
      final c = ProviderContainer(overrides: [
        authStateProvider.overrideWith(
          () => FakeAuthNotifier(const Unauthenticated()),
        ),
        followRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final result = await c.read(followToggleProvider('bob').future);
      expect(result, isFalse);
    });
  });

  group('FollowToggleNotifier — toggle()', () {
    test('takip etmiyorken toggle → state true', () async {
      final c = _container(currentUserId: 'alice', repo: repo);
      await c.read(followToggleProvider('bob').future);

      await c.read(followToggleProvider('bob').notifier).toggle();

      expect(c.read(followToggleProvider('bob')).value, isTrue);
    });

    test('takip ediyorken toggle → state false', () async {
      await repo.follow('alice', 'bob');
      final c = _container(currentUserId: 'alice', repo: repo);
      await c.read(followToggleProvider('bob').future);

      await c.read(followToggleProvider('bob').notifier).toggle();

      expect(c.read(followToggleProvider('bob')).value, isFalse);
    });

    test('follow sonrası repo\'da ilişki oluşur', () async {
      final c = _container(currentUserId: 'alice', repo: repo);
      await c.read(followToggleProvider('bob').future);
      await c.read(followToggleProvider('bob').notifier).toggle();

      expect(await repo.isFollowing('alice', 'bob'), isTrue);
    });

    test('unfollow sonrası repo\'dan ilişki silinir', () async {
      await repo.follow('alice', 'bob');
      final c = _container(currentUserId: 'alice', repo: repo);
      await c.read(followToggleProvider('bob').future);
      await c.read(followToggleProvider('bob').notifier).toggle();

      expect(await repo.isFollowing('alice', 'bob'), isFalse);
    });

    test('follow sonrası notifyNewFollower çağrılır', () async {
      final c = _container(currentUserId: 'alice', repo: repo);
      await c.read(followToggleProvider('bob').future);
      await c.read(followToggleProvider('bob').notifier).toggle();

      expect(repo.lastNotifyCall?.followerId, 'alice');
      expect(repo.lastNotifyCall?.followeeId, 'bob');
    });

    test('unfollow sırasında notifyNewFollower çağrılmaz', () async {
      await repo.follow('alice', 'bob');
      final c = _container(currentUserId: 'alice', repo: repo);
      await c.read(followToggleProvider('bob').future);
      await c.read(followToggleProvider('bob').notifier).toggle();

      expect(repo.lastNotifyCall, isNull);
    });
  });
}
