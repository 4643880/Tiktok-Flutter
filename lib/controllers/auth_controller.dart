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
import 'package:tiktok_flutter/views/screens/auth/login_screen.dart';
import 'package:tiktok_flutter/views/screens/home_screen.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  //=====================================================
  // Persisting Auth State with Getx
  //=====================================================
  late Rx<User?> _user;

  User? get getCurrentUser => _user.value;

  @override
  void onReady() {
    _user = firebaseAuth.currentUser.obs;
    // It will track current changes in auth
    _user.bindStream(firebaseAuth.authStateChanges());
    // Whenever will be changes then it will listen and perform action through my function
    ever(_user, _setInitialScreen);
    super.onReady();
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  //=====================================================
  // Picking Image For SignUp User
  //=====================================================
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

  //=====================================================
  // upload to firebase storage
  //=====================================================

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

  //=====================================================
  // register
  //=====================================================

  Future<String?> registerUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required File? image,
  }) async {
    try {
      String res = "";
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
        res = "success";
        return res;
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

  //=====================================================
  // Login User
  //=====================================================
  Future<String?> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      String res = "";
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.snackbar(
          "Login",
          "Congratulations you have Loggedin successfully.",
        );
        res = "success";
        return res;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        devtools.log('No user found for that email.');
        await showErrorDialog(
          context,
          "User Not Found",
          "No user found for that email. Please try again.",
        );
      } else if (e.code == 'wrong-password') {
        devtools.log(
          'Wrong password provided for that user.',
        );
        await showErrorDialog(
          context,
          "Wrong Password",
          "Wrong password provided for that user. Please try again.",
        );
      } else {
        devtools.log(e.code.toString());
        await showErrorDialog(
            context, "Something Went Wrong", "Error:  ${e.code}");
      }
    } catch (e) {
      Get.snackbar("Something Went Wrong", e.toString());
      devtools.log(e.toString());
    }
  }

  //=====================================================
  //  Sign out
  //=====================================================
  Future<void> signout() async {
    firebaseAuth.signOut();
  }
}
