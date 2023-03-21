// for picking up image from gallery
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {    
    Get.snackbar(
      "Profile Picture",
      "You have successfully selected your profile picture.",
    );
    return _file.path;
  }
  print('No Image Selected');
}
