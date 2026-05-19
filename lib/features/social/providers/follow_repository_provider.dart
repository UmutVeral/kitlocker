import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/follow_repository.dart';
import '../repositories/supabase_follow_repository.dart';

final followRepositoryProvider = Provider<FollowRepository>((ref) {
  return SupabaseFollowRepository(Supabase.instance.client);
});
