import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import 'follow_repository_provider.dart';

class FollowersNotifier
    extends FamilyAsyncNotifier<List<UserProfile>, String> {
  @override
  Future<List<UserProfile>> build(String userId) =>
      ref.read(followRepositoryProvider).getFollowers(userId);
}

final followersOfProvider = AsyncNotifierProvider.family<FollowersNotifier,
    List<UserProfile>, String>(FollowersNotifier.new);
