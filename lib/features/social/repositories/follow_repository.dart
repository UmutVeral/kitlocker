import '../models/user_profile.dart';

abstract interface class FollowRepository {
  Future<void> follow(String followerId, String followeeId);
  Future<void> unfollow(String followerId, String followeeId);
  Future<bool> isFollowing(String followerId, String followeeId);
  Future<List<UserProfile>> getFollowers(String userId);
  Future<List<UserProfile>> getFollowing(String userId);
  Future<void> notifyNewFollower(String followerId, String followeeId);
}
