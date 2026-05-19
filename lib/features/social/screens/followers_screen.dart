import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitlocker/core/routing/app_routes.dart';
import 'package:kitlocker/features/social/providers/followers_notifier.dart';
import 'package:kitlocker/l10n/app_localizations.dart';

class FollowersScreen extends ConsumerWidget {
  const FollowersScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final followersAsync = ref.watch(followersOfProvider(userId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.followersLabel)),
      body: followersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (followers) => followers.isEmpty
            ? Center(child: Text(l10n.noFollowers))
            : ListView.builder(
                itemCount: followers.length,
                itemBuilder: (context, i) {
                  final profile = followers[i];
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
