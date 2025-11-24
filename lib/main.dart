import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/home_controller.dart';
import 'splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      // title: 'Forge Hrms',
      title: 'Forge Resources',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  final homeController = Get.put<HomeController>(HomeController());
}
