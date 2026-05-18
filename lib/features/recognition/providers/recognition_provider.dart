import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../kit_recognition_repository.dart';
import '../recognition_coordinator.dart';
import '../supabase_kit_recognition_repository.dart';

final kitRecognitionRepositoryProvider = Provider<KitRecognitionRepository>((ref) {
  return SupabaseKitRecognitionRepository(Supabase.instance.client);
});

final recognitionCoordinatorProvider = Provider<RecognitionCoordinator>((ref) {
  return RecognitionCoordinator(
    repository: ref.watch(kitRecognitionRepositoryProvider),
  );
});
