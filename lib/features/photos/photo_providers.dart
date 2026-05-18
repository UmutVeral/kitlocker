import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'flutter_image_compress_photo_compressor.dart';
import 'photo_compressor.dart';
import 'photo_repository.dart';
import 'supabase_photo_repository.dart';

final photoRepositoryProvider = Provider<PhotoRepository>(
  (_) => SupabasePhotoRepository(Supabase.instance.client),
);

final photoCompressorProvider = Provider<PhotoCompressor>(
  (_) => const FlutterImageCompressPhotoCompressor(),
);
