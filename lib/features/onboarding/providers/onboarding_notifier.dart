import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../core/auth/auth_state.dart';
import '../../../core/auth/auth_state_provider.dart';

class OnboardingNotifier extends AsyncNotifier<bool> {
  sb.SupabaseClient get _supabase => sb.Supabase.instance.client;

  @override
  Future<bool> build() async {
    final authState = ref.watch(authStateProvider);
    if (authState is! Authenticated) return false;
    final data = await _supabase
        .from('profiles')
        .select('onboarding_completed_at')
        .eq('id', authState.userId)
        .single();
    return data['onboarding_completed_at'] != null;
  }

  Future<void> completeOnboarding() async {
    final authState = ref.read(authStateProvider);
    if (authState is! Authenticated) return;
    await _supabase
        .from('profiles')
        .update({
          'onboarding_completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', authState.userId);
    state = const AsyncData(true);
  }
}

final onboardingStatusProvider =
    AsyncNotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);
