import 'package:flutter/material.dart';
import 'splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      // title: 'Forge Hrms',
      title: 'Forge WE-Enable (Mentor)',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
