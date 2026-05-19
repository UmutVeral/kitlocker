import 'package:kitlocker/features/social/models/user_profile.dart';
import 'package:kitlocker/features/social/repositories/follow_repository.dart';

class FakeFollowRepository implements FollowRepository {
  final _follows = <(String, String)>{};
  final _profiles = <String, UserProfile>{};

  ({String followerId, String followeeId})? lastNotifyCall;

  void seedProfile(UserProfile profile) =>
      _profiles[profile.userId] = profile;

  @override
  Future<void> follow(String followerId, String followeeId) async {
    if (followerId == followeeId) throw Exception('Cannot follow yourself');
    if (_follows.contains((followerId, followeeId))) {
      throw Exception('Already following');
    }
    _follows.add((followerId, followeeId));
  }

  @override
  Future<void> unfollow(String followerId, String followeeId) async {
    _follows.remove((followerId, followeeId));
  }

  @override
  Future<bool> isFollowing(String followerId, String followeeId) async =>
      _follows.contains((followerId, followeeId));

  @override
  Future<List<UserProfile>> getFollowers(String userId) async => _follows
      .where((f) => f.$2 == userId)
      .map((f) => _profiles[f.$1])
      .whereType<UserProfile>()
      .toList();

  @override
  Future<List<UserProfile>> getFollowing(String userId) async => _follows
      .where((f) => f.$1 == userId)
      .map((f) => _profiles[f.$2])
      .whereType<UserProfile>()
      .toList();

  @override
  Future<void> notifyNewFollower(
      String followerId, String followeeId) async {
    lastNotifyCall = (followerId: followerId, followeeId: followeeId);
  }
}

UserProfile fakeProfile({
  String userId = 'user-1',
  String username = 'testuser',
}) =>
    UserProfile(userId: userId, username: username);
