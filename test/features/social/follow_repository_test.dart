import 'package:flutter_test/flutter_test.dart';
import '../../helpers/social_fakes.dart';

void main() {
  late FakeFollowRepository repo;

  setUp(() {
    repo = FakeFollowRepository();
    repo.seedProfile(fakeProfile(userId: 'alice', username: 'alice'));
    repo.seedProfile(fakeProfile(userId: 'bob', username: 'bob'));
  });

  group('follow()', () {
    test('ilişkiyi oluşturur — isFollowing true döner', () async {
      await repo.follow('alice', 'bob');
      expect(await repo.isFollowing('alice', 'bob'), isTrue);
    });

    test('ters yön bağımsız — bob alice\'i takip etmeden önce false', () async {
      await repo.follow('alice', 'bob');
      expect(await repo.isFollowing('bob', 'alice'), isFalse);
    });

    test('duplicate follow exception fırlatır', () async {
      await repo.follow('alice', 'bob');
      await expectLater(
        repo.follow('alice', 'bob'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('unfollow()', () {
    test('ilişkiyi siler — isFollowing false döner', () async {
      await repo.follow('alice', 'bob');
      await repo.unfollow('alice', 'bob');
      expect(await repo.isFollowing('alice', 'bob'), isFalse);
    });

    test('takip yokken unfollow exception fırlatmaz', () async {
      await expectLater(repo.unfollow('alice', 'bob'), completes);
    });
  });

  group('isFollowing()', () {
    test('takip yokken false döner', () async {
      expect(await repo.isFollowing('alice', 'bob'), isFalse);
    });
  });

  group('getFollowers()', () {
    test('takipçi listesini döner', () async {
      await repo.follow('alice', 'bob');
      final followers = await repo.getFollowers('bob');
      expect(followers.map((p) => p.userId), contains('alice'));
    });

    test('takip yoksa boş liste döner', () async {
      expect(await repo.getFollowers('alice'), isEmpty);
    });

    test('sadece o kullanıcının takipçilerini döner', () async {
      repo.seedProfile(fakeProfile(userId: 'carol', username: 'carol'));
      await repo.follow('alice', 'bob');
      await repo.follow('carol', 'bob');
      final followers = await repo.getFollowers('bob');
      expect(followers.map((p) => p.userId), containsAll(['alice', 'carol']));
    });
  });

  group('getFollowing()', () {
    test('takip edilen listesini döner', () async {
      await repo.follow('alice', 'bob');
      final following = await repo.getFollowing('alice');
      expect(following.map((p) => p.userId), contains('bob'));
    });

    test('takip yoksa boş liste döner', () async {
      expect(await repo.getFollowing('bob'), isEmpty);
    });
  });

  group('notifyNewFollower()', () {
    test('çağrı parametrelerini kaydeder', () async {
      await repo.notifyNewFollower('alice', 'bob');
      expect(repo.lastNotifyCall?.followerId, 'alice');
      expect(repo.lastNotifyCall?.followeeId, 'bob');
    });
  });
}
