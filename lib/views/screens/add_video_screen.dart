import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_flutter/utils/constants.dart';
import 'package:tiktok_flutter/views/screens/confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  pickVideo(ImageSource source, BuildContext context) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickVideo(
      source: source,
    );
    if (_file != null) {
      Get.to(() => ConfirmScreen(
            videoFile: File(_file.path),
            videoPath: _file.path,
          ));
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () => pickVideo(ImageSource.gallery, context),
              child: Row(
                children: const [
                  Icon(Icons.image),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Gallery",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => pickVideo(ImageSource.camera, context),
              child: Row(
                children: const [
                  Icon(Icons.camera_alt),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Camera",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Get.back();
              },
              child: Row(
                children: const [
                  Icon(Icons.cancel),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showOptionsDialog(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(color: buttonColor),
            child: const Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
