import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kitlocker/core/routing/app_routes.dart';
import 'package:kitlocker/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.homeGreeting),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.locker),
              child: const Text('Locker\'ıma Git'),
            ),
          ],
        ),
      ),
    );
  }
}
