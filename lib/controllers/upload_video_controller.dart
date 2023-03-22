import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_flutter/models/video_model.dart';
import 'package:tiktok_flutter/utils/constants.dart';
import 'package:tiktok_flutter/utils/show_error_dialog.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

class UploadVideoController extends GetxController {
  static UploadVideoController instance = Get.find();
  //=====================================================
  // Compressing Video and getting thumbnail
  //=====================================================
  Future<File?> _compressVideo({required String videoPath}) async {
    try {
      if (VideoCompress.isCompressing) {
        Get.snackbar(
          "Compressing Video",
          "Already Compressing a video.",
        );
      } else {
        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          videoPath,
          quality: VideoQuality.Res640x480Quality,
          deleteOrigin: false,
          includeAudio: true,
          frameRate: 24,
          //duration: 30 //do not use this!
        );
        File? file = mediaInfo?.file;
        return file;
      }
    } catch (e) {
      VideoCompress.cancelCompression();
      Get.snackbar("Something Went Wrong", e.toString());
      devtools.log(e.toString());
    }
  }

  Future<File> _getThumbnail({required String videoPath}) async {
    File file = await VideoCompress.getFileThumbnail(videoPath);
    return file;
  }

  //=====================================================
  // Upload Video to Storage
  //=====================================================

  Future<String?> _uploadVideoToStorage({
    required String name,
    required String path,
  }) async {
    Reference ref = firebaseStorage.ref().child("videos").child(name);

    File? _file = await _compressVideo(videoPath: path);

    if (_file != null) {
      UploadTask task = ref.putFile(_file);

      TaskSnapshot snap = await task;

      String downloadUrlOfVideo = await snap.ref.getDownloadURL();

      return downloadUrlOfVideo;
    } else {
      return null;
    }
  }

  //=====================================================
  // Upload Video thumbnail to Storage
  //=====================================================

  Future<String> _uploadImageThumbnailToStorage({
    required String name,
    required String path,
  }) async {
    Reference ref = firebaseStorage.ref().child("thumbnails").child(name);
    File? _file = await _getThumbnail(videoPath: path);

    UploadTask task = ref.putFile(_file);

    TaskSnapshot snap = await task;

    String downloadUrlOfThumbnail = await snap.ref.getDownloadURL();

    return downloadUrlOfThumbnail;
  }

  //=====================================================
  // Upload Video to Firestore
  //=====================================================

  Future<String?> uploadVideo({
    required String songName,
    required String caption,
    required String videoPath,
  }) async {
    String res = "";
    try {
      String uid = firebaseAuth.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> docSnapOfUser =
          await firebaseFirestore.collection("users").doc(uid).get();

      // Get id e.g video 0, video 1, video 2 also can use uuid pkg
      QuerySnapshot allDocs =
          await firebaseFirestore.collection("videos").get();
      int len = allDocs.docs.length;

      // Upload video to storage and compressing
      String? videoUrl = await _uploadVideoToStorage(
        name: "Video $len",
        path: videoPath,
      );

      // upload image thumbnail
      String thumbnailUrl = await _uploadImageThumbnailToStorage(
        name: "Video $len",
        path: videoPath,
      );

      // Assigning Values to Model Class
      Video video = Video(
        uid: uid,
        username: docSnapOfUser.data()?["name"],
        profilePhoto: docSnapOfUser.data()?["profilePhoto"],
        videoid: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl!,
        thumbnailUrl: thumbnailUrl,
      );

      // Storing in Firebase Firestore DB
      await firebaseFirestore.collection("videos").doc("Video $len").set(
            video.toJson(),
          );
      Get.snackbar(
        "Video Uploaded",
        "Congratulations you have uploaded video successfully.",
      );
      res = "success";
      return res;
    } catch (e) {
      Get.snackbar("Something Went Wrong", e.toString());
      devtools.log(e.toString());
    }
  }
}
