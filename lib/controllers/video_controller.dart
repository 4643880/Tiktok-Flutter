import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_flutter/utils/constants.dart';

import '../models/video_model.dart';

class VideoController extends GetxController {
  static VideoController instance = Get.find();

  //=====================================================
  // Fetch Videos
  //=====================================================

  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    final result = firebaseFirestore
        .collection("videos")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      // creating empty list then adding objects of video
      List<Video> returnValue = [];
      for (final value in querySnapshot.docs) {
        final data = value.data() as Map<String, dynamic>;
        returnValue.add(Video.fromSnap(snapshot: data));
      }
      return returnValue;
    });
    _videoList.bindStream(result);
    super.onInit();
  }
}
