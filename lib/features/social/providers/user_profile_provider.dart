import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

final userProfileProvider =
    FutureProvider.family<UserProfile?, String>((ref, userId) async {
  final result = await Supabase.instance.client
      .from('profiles')
      .select('id, username')
      .eq('id', userId)
      .maybeSingle();
  return result != null ? UserProfile.fromJson(result) : null;
});
