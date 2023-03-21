import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
import 'package:tiktok_flutter/utils/constants.dart';
import 'package:tiktok_flutter/models/user_model.dart' as model;
import 'package:tiktok_flutter/utils/show_error_dialog.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  // Picking Image For SignUp User
  Rx<File?> _pickedImage = File("").obs;
  File? get getPickedImage => _pickedImage.value;

  setPickedImageEmpty() {
    _pickedImage.value = File("");
  }

  pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (_file != null) {
      Get.snackbar(
        "Profile Picture",
        "You have successfully selected your profile picture.",
      );
      _pickedImage.value = File(_file.path);
    }
  }

  // upload to firebase storage
  Future<String> uploadToStorage(
    File image,
    String child,
    String uid,
  ) async {
    Reference ref = firebaseStorage.ref().child(child).child(uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String dawnloadUrl = await taskSnapshot.ref.getDownloadURL();
    return dawnloadUrl;
  }

  // register
  Future<void> registerUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required File? image,
  }) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // Registering user with email and password
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Storing image in Firebase Storage
        final photoUrl = await uploadToStorage(
          image,
          "profilePics",
          userCredential.user!.uid,
        );

        // Assigning Data to Model Class
        model.User user = model.User(
          uid: userCredential.user!.uid,
          name: username,
          email: email,
          profilePhoto: photoUrl,
        );

        // Storing Info in Cloud Firestore DB
        await firebaseFirestore
            .collection("users")
            .doc(userCredential.user?.uid)
            .set(
              user.toJson(),
            );
        Get.snackbar(
          "Signed Up",
          "Congratulations you have signed up successfully.",
        );
      }
    } on FirebaseAuthException catch (e) {
      devtools.log(e.toString());
      if (e.code == 'weak-password') {
        devtools.log('The password provided is too weak.');
        await showErrorDialog(
          context,
          "Weak Password",
          "The password provided is too weak.",
        );
      } else if (e.code == 'email-already-in-use') {
        devtools.log('The account already exists for that email.');
        await showErrorDialog(
          context,
          "Email Already in Use",
          "The account already exists for that email.",
        );
      } else if (e.code == "invalid-email") {
        devtools.log("Invalid Email Address");
        await showErrorDialog(
          context,
          "Invalid Email Address",
          "Please Enter Correct Email Address it's Invalid",
        );
      }
    } catch (e) {
      Get.snackbar("Something Went Wrong", e.toString());
      devtools.log(e.toString());
    }
  }
}
