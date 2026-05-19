import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import 'follow_repository_provider.dart';

class FollowingNotifier
    extends FamilyAsyncNotifier<List<UserProfile>, String> {
  @override
  Future<List<UserProfile>> build(String userId) =>
      ref.read(followRepositoryProvider).getFollowing(userId);
}

final followingOfProvider = AsyncNotifierProvider.family<FollowingNotifier,
    List<UserProfile>, String>(FollowingNotifier.new);
