import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitlocker/core/routing/app_routes.dart';
import 'package:kitlocker/features/social/providers/following_notifier.dart';
import 'package:kitlocker/l10n/app_localizations.dart';

class FollowingScreen extends ConsumerWidget {
  const FollowingScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final followingAsync = ref.watch(followingOfProvider(userId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.followingLabel)),
      body: followingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (following) => following.isEmpty
            ? Center(child: Text(l10n.noFollowing))
            : ListView.builder(
                itemCount: following.length,
                itemBuilder: (context, i) {
                  final profile = following[i];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(profile.username),
                    onTap: () =>
                        context.push(AppRoutes.profile(profile.userId)),
                  );
                },
              ),
      ),
    );
  }
}
