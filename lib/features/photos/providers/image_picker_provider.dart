import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../image_picker_service.dart';

final imagePickerServiceProvider = Provider<ImagePickerService>(
  (ref) => ImagePickerServiceImpl(),
);
