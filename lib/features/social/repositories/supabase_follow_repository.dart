import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import 'follow_repository.dart';

class SupabaseFollowRepository implements FollowRepository {
  const SupabaseFollowRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> follow(String followerId, String followeeId) async {
    await _client.from('follows').insert({
      'follower_id': followerId,
      'followee_id': followeeId,
    });
  }

  @override
  Future<void> unfollow(String followerId, String followeeId) async {
    await _client
        .from('follows')
        .delete()
        .eq('follower_id', followerId)
        .eq('followee_id', followeeId);
  }

  @override
  Future<bool> isFollowing(String followerId, String followeeId) async {
    final result = await _client
        .from('follows')
        .select('id')
        .eq('follower_id', followerId)
        .eq('followee_id', followeeId)
        .limit(1);
    return result.isNotEmpty;
  }

  @override
  Future<List<UserProfile>> getFollowers(String userId) async {
    final rows = await _client
        .from('follows')
        .select('follower_id')
        .eq('followee_id', userId);
    final ids = rows.map((r) => r['follower_id'] as String).toList();
    if (ids.isEmpty) return [];
    final profiles = await _client
        .from('profiles')
        .select('id, username')
        .inFilter('id', ids);
    return profiles.map(UserProfile.fromJson).toList();
  }

  @override
  Future<List<UserProfile>> getFollowing(String userId) async {
    final rows = await _client
        .from('follows')
        .select('followee_id')
        .eq('follower_id', userId);
    final ids = rows.map((r) => r['followee_id'] as String).toList();
    if (ids.isEmpty) return [];
    final profiles = await _client
        .from('profiles')
        .select('id, username')
        .inFilter('id', ids);
    return profiles.map(UserProfile.fromJson).toList();
  }

  @override
  Future<void> notifyNewFollower(
      String followerId, String followeeId) async {
    try {
      await _client.functions.invoke(
        'notify-new-follower',
        body: {'followerId': followerId, 'followeeId': followeeId},
      );
    } catch (_) {
      // push notification failure must not block the follow action
    }
  }
}
