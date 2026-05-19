import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'follow_repository_provider.dart';
import 'followers_notifier.dart';
import 'following_notifier.dart';

class FollowToggleNotifier extends FamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String targetUserId) async {
    final auth = ref.watch(authStateProvider);
    if (auth is! Authenticated) return false;
    return ref
        .read(followRepositoryProvider)
        .isFollowing(auth.userId, targetUserId);
  }

  Future<void> toggle() async {
    final auth = ref.read(authStateProvider);
    if (auth is! Authenticated) return;
    final repo = ref.read(followRepositoryProvider);
    final currentlyFollowing = state.valueOrNull ?? false;

    if (currentlyFollowing) {
      await repo.unfollow(auth.userId, arg);
      state = const AsyncData(false);
    } else {
      await repo.follow(auth.userId, arg);
      // best-effort: push bildirim başarısız olursa follow işlemi etkilenmez
      await repo.notifyNewFollower(auth.userId, arg);
      state = const AsyncData(true);
    }

    ref.invalidate(followersOfProvider(arg));
    ref.invalidate(followingOfProvider(auth.userId));
  }
}

final followToggleProvider = AsyncNotifierProvider.family<FollowToggleNotifier,
    bool, String>(FollowToggleNotifier.new);
