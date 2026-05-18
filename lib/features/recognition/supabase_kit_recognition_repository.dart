import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'kit_recognition_repository.dart';
import 'models/kit_recognition_result.dart';

class SupabaseKitRecognitionRepository implements KitRecognitionRepository {
  SupabaseKitRecognitionRepository(this._client);

  final SupabaseClient _client;

  static const _functionName = 'recognize-kit';

  @override
  Future<KitRecognitionResult> recognize(Uint8List imageBytes) async {
    final response = await _client.functions.invoke(
      _functionName,
      body: {'imageBase64': base64Encode(imageBytes)},
    );

    if (response.status != 200) {
      throw Exception('recognition failed: ${response.status}');
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('invalid recognition response');
    }

    return KitRecognitionResult.fromJson(data);
  }
}
