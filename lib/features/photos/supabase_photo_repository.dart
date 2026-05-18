import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'photo_repository.dart';

class SupabasePhotoRepository implements PhotoRepository {
  SupabasePhotoRepository(this._supabase);

  final SupabaseClient _supabase;

  static const _bucket = 'kit-photos';

  @override
  Future<String> uploadPhoto(Uint8List bytes, String userId) async {
    final path = '$userId/${const Uuid().v4()}.webp';
    await _supabase.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/webp'),
        );
    return _supabase.storage.from(_bucket).getPublicUrl(path);
  }
}
