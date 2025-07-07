import 'package:flutter/material.dart';
import 'package:forge_hrms/bottom_bar_screen.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset('assets/video/forge_intro.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {}); // Ensure the first frame is shown
        _controller.setLooping(false);
        _controller.play();

        _controller.addListener(() {
          if (!mounted) return;

          final isEnded = !_controller.value.isPlaying &&
              _controller.value.position >= _controller.value.duration;

          if (isEnded) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => BottomNavigationBarScreen()),
            );
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),

      // body: _controller.value.isInitialized
      //     ? /*SizedBox(
      //         width: size.width,
      //         height: size.height,
      //         child: VideoPlayer(_controller),
      //       )*/
      //     Center(
      //         child: AspectRatio(
      //           aspectRatio: _controller.value.aspectRatio,
      //           child: VideoPlayer(_controller),
      //         ),
      //       )
      //     : const Center(child: CircularProgressIndicator()),
    );
  }
}
