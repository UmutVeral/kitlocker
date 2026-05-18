import 'package:image_picker/image_picker.dart';

abstract interface class ImagePickerService {
  Future<XFile?> pickImage(
    ImageSource source, {
    int imageQuality = 90,
  });
}

class ImagePickerServiceImpl implements ImagePickerService {
  ImagePickerServiceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<XFile?> pickImage(
    ImageSource source, {
    int imageQuality = 90,
  }) =>
      _picker.pickImage(source: source, imageQuality: imageQuality);
}
