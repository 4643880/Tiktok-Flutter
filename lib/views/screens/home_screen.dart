import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_flutter/views/screens/add_video_screen.dart';
import 'package:tiktok_flutter/views/screens/video_screen.dart';
import 'package:tiktok_flutter/views/widgets/custom_icon.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  PageController pageController = PageController();

  final Rx<int> _pageIndex = 0.obs;
  int get pageIndex => _pageIndex.value;

  navigationTapped(var value) {
    _pageIndex.value = value;
    pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            currentIndex: pageIndex,
            onTap: (value) {
              navigationTapped(value);
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 30),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: CustomIcon(),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message, size: 30),
                label: "Messages",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: "Profile",
              ),
            ]),
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {},
        children: const [
          VideoScreen(),
          Center(
            child: Text("Search"),
          ),
          AddVideoScreen(),
          Center(
            child: Text("Messages"),
          ),
          Center(
            child: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
