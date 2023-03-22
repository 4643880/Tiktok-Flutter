import 'package:get/get.dart';
import 'package:tiktok_flutter/controllers/auth_controller.dart';

Future<void> init() async {
  Get.put(AuthController());
}
