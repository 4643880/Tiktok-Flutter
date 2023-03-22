import 'package:get/get.dart';
import 'package:tiktok_flutter/controllers/auth_controller.dart';
import 'package:tiktok_flutter/controllers/upload_video_controller.dart';

Future<void> init() async {
  Get.put(AuthController());
  Get.put(UploadVideoController());
}
