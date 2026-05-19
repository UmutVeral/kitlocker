import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/core/routing/app_routes.dart';
import 'package:kitlocker/features/social/providers/follow_toggle_notifier.dart';
import 'package:kitlocker/features/social/providers/followers_notifier.dart';
import 'package:kitlocker/features/social/providers/following_notifier.dart';
import 'package:kitlocker/features/social/providers/user_profile_provider.dart';
import 'package:kitlocker/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authStateProvider);
    final currentUserId =
        auth is Authenticated ? auth.userId : null;
    final isOwnProfile = currentUserId == userId;

    final profile = ref.watch(userProfileProvider(userId));
    final followers = ref.watch(followersOfProvider(userId));
    final following = ref.watch(followingOfProvider(userId));

    final username = profile.valueOrNull?.username ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        actions: isOwnProfile || currentUserId == null
            ? null
            : [_FollowButton(targetUserId: userId)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () =>
                    context.push(AppRoutes.profileFollowers(userId)),
                child: _CountTile(
                  key: const Key('profile_followers_count'),
                  label: l10n.followersLabel,
                  count: followers.valueOrNull?.length ?? 0,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.push(AppRoutes.profileFollowing(userId)),
                child: _CountTile(
                  key: const Key('profile_following_count'),
                  label: l10n.followingLabel,
                  count: following.valueOrNull?.length ?? 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends ConsumerWidget {
  const _FollowButton({required this.targetUserId});

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isFollowingAsync = ref.watch(followToggleProvider(targetUserId));
    final isFollowing = isFollowingAsync.valueOrNull ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: isFollowing
          ? OutlinedButton(
              key: const Key('profile_unfollow_button'),
              onPressed: () =>
                  ref.read(followToggleProvider(targetUserId).notifier).toggle(),
              child: Text(l10n.unfollowButton),
            )
          : FilledButton(
              key: const Key('profile_follow_button'),
              onPressed: () =>
                  ref.read(followToggleProvider(targetUserId).notifier).toggle(),
              child: Text(l10n.followButton),
            ),
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    super.key,
    required this.label,
    required this.count,
  });

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(label),
      ],
    );
  }
}
