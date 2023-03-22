import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_flutter/utils/constants.dart';
import 'package:tiktok_flutter/utils/helper.dart' as di;
import 'package:tiktok_flutter/views/screens/auth/login_screen.dart';
import 'package:tiktok_flutter/views/screens/auth/signup_screen.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
  // di means dependency injection
  await di.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        canvasColor: backgroundColor,
      ),
      home: LoginScreen(),
    );
  }
}
