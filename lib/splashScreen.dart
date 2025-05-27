import 'package:flutter/material.dart';
import 'package:forge_hrms/bottom_bar_screen.dart';
import 'package:forge_hrms/utils/const_utils.dart';
// import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'webviews/home_webview.dart';

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
    // _initializeVideoPlayer();
    _navigateToNextScreen();
    // _requestLocationPermission();
  }

  // void _initializeVideoPlayer() {
  //   _controller = VideoPlayerController.asset('assets/video/forge_intro.mp4')
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _controller.play();
  //     });
  // }

  Future<void> _navigateToNextScreen() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      // final getLocation = await Location().getLocation();
      // ConstUtils.lat = getLocation.latitude!;
      // ConstUtils.long = getLocation.longitude!;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomNavigationBarScreen(),
      ));
    } on Exception catch (e) {
      print('GET LAT LONG ERROR :=> $e');
    }
  }

  // Future<void> _requestLocationPermission() async {
  //   try {
  //     Location location = Location();
  //     final status = await Permission.location.request();
  //     print("_checkLocationPermission:==> $status");
  //
  //     if (status.isGranted) {
  //       final service = await Permission.location.serviceStatus;
  //       print("service==> $service");
  //       if (service == ServiceStatus.enabled) {
  //         _navigateToNextScreen();
  //       } else {
  //         final isServiceEnable = await location.requestService();
  //         print("isServiceEnable=====> $isServiceEnable");
  //         if (isServiceEnable) {
  //           _navigateToNextScreen();
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               content: Text("Please enable location service")));
  //         }
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Please enable location permission")));
  //     }
  //   } on Exception catch (e) {
  //     print("LOCATION ERROR :=> $e");
  //   }
  // }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      /*  body: _controller.value.isInitialized
          ? SizedBox(
              height: size.height,
              width: size.width,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: size.height * _controller.value.aspectRatio,
                  height: size.height * 1,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const SizedBox(),*/
      body: Center(
          child: Image.network(
        'https://forgealumnus.com/weEnable/images/logo.png',
        scale: 3,
      ) /*Image.asset(
          "assets/images/app_logo_with_bg.png",
          scale: 6,
        ),*/
          ),
    );
  }
}
