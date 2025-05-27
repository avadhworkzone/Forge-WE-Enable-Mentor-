import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:forge_hrms/webviews/about_us_webview.dart';
import 'package:forge_hrms/webviews/contact_us_webview.dart';
import 'package:forge_hrms/webviews/home_webview.dart';
import 'package:forge_hrms/webviews/privacy_policy_webview.dart';
import 'package:forge_hrms/webviews/term_and_condition_webview.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentBottomBarIndex = 4;
  List<String> bottomList = [
    "aboutUs.png",
    "contactUs.png",
    "termAndCondition.png",
    "privacyPolicy.png",
  ];

  String title() {
    switch (currentBottomBarIndex) {
      case 0:
        return "About us";
      case 1:
        return "Contact us";
      case 2:
        return "Terms of Use";
      case 3:
        return "Privacy Policy";
      case 4:
        return "HR Dock";
      default:
        return "HR Dock";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          title(),
          style: TextStyle(
              fontFamily: 'AGENCYB',
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: AppColors.primary
              // color: Colors.white,
              ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        leading:currentBottomBarIndex!=4? InkWell(
          onTap: () {
            if (currentBottomBarIndex != 4) {
              setState(() {
                currentBottomBarIndex = 4;
              });
            }
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 16,
          ),
        ):const SizedBox(),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(20.0),
        //     bottomRight: Radius.circular(20.0),
        //   ),
        // ),
      ),
      body: SafeArea(
        bottom: true,
        child: currentBottomBarIndex == 0
            ? const AboutUsWebViewScreen()
            : currentBottomBarIndex == 1
                ? const ContactUsWebViewScreen()
                : currentBottomBarIndex == 2
                    ? const TermAndConditionWebViewScreen()
                    : currentBottomBarIndex == 3
                        ? const PrivacyPolicyWebViewScreen()
                        : currentBottomBarIndex == 4
                            ? const HomeWebViewScreen()
                            : const Material(),
      ),
      floatingActionButton: showFab
          ? GestureDetector(
              onTap: () {
                setState(() {
                  currentBottomBarIndex = 4;
                });
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: Image.asset(
                  "assets/images/home.png",
                  width: 25,
                  height: 25,
                  color: currentBottomBarIndex == 4
                      ? AppColors.yellow
                      : AppColors.white,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: bottomList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? AppColors.primary : AppColors.grey;
          return Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "assets/images/${bottomList[index]}",
                width: 10,
                height: 10,
                color: color,
              ));
        },
        backgroundColor: Colors.white,
        activeIndex: currentBottomBarIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) {
          setState(() {
            currentBottomBarIndex = index;
          });
        },
      ),
    );
  }
}
