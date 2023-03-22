import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tiktok_flutter/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late TextEditingController _songController;
  late TextEditingController _captionController;
  late VideoPlayerController _controller;

  @override
  void initState() {
    _songController = TextEditingController();
    _captionController = TextEditingController();
    // Video Player
    _controller = VideoPlayerController.file(widget.videoFile);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize();
    _controller.play();
    _controller.setVolume(1);
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _songController.dispose();
    _captionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(_controller),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song Name',
                      icon: Icons.music_note,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Share!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
