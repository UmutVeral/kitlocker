import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../providers/onboarding_notifier.dart';

class OnboardingCameraScreen extends ConsumerWidget {
  const OnboardingCameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlk Kitini Ekle'),
        actions: [
          TextButton(
            key: const Key('onboarding_skip_button'),
            onPressed: () async {
              await ref
                  .read(onboardingStatusProvider.notifier)
                  .completeOnboarding();
            },
            child: const Text('Atla'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_soccer, size: 80),
            const SizedBox(height: 24),
            const Text(
              'Koleksiyonuna ilk kitini ekle!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              key: const Key('onboarding_add_kit_button'),
              icon: const Icon(Icons.add),
              label: const Text('Kit Ekle'),
              onPressed: () async {
                await context.push(AppRoutes.lockerAdd);
                if (context.mounted) {
                  await ref
                      .read(onboardingStatusProvider.notifier)
                      .completeOnboarding();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
