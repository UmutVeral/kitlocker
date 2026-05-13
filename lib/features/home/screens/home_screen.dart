import 'package:flutter/material.dart';
import 'package:kitlocker/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)!.homeGreeting),
      ),
    );
  }
}
