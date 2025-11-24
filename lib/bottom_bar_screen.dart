// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:forge_hrms/utils/color_utils.dart';
// import 'package:forge_hrms/utils/secure_storage_utils.dart';
// import 'package:forge_hrms/webviews/about_us_webview.dart';
// import 'package:forge_hrms/webviews/contact_us_webview.dart';
// import 'package:forge_hrms/webviews/home_webview.dart';
// import 'package:forge_hrms/webviews/privacy_policy_webview.dart';
// import 'package:forge_hrms/webviews/term_and_condition_webview.dart';
// import 'package:get/get.dart';
//
// import 'controller/home_controller.dart';
//
// class BottomNavigationBarScreen extends StatefulWidget {
//   const BottomNavigationBarScreen({super.key});
//
//   @override
//   State<BottomNavigationBarScreen> createState() =>
//       _BottomNavigationBarScreenState();
// }
//
// class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
//   int currentBottomBarIndex = 4;
//   final homeController = Get.find<HomeController>();
//
//   List<String> bottomList = [
//     "aboutUs.png",
//     "contactUs.png",
//     "termAndCondition.png",
//     "privacyPolicy.png",
//   ];
//
//   String title() {
//     switch (currentBottomBarIndex) {
//       case 0:
//         return "About us";
//       case 1:
//         return "Contact us";
//       case 2:
//         return "Terms of Use";
//       case 3:
//         return "Privacy Policy";
//       case 4:
//         return homeController.isSwitchOn.value ? "WE-Enable" : "Forge Alumnus";
//       default:
//         return "WE-Enable";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       extendBody: true,
//       appBar: AppBar(
//         title: Obx(() {
//           return Text(
//             title(),
//             style: const TextStyle(
//                 fontFamily: 'AGENCYB',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//                 color: AppColors.primary
//                 // color: Colors.white,
//                 ),
//           );
//         }),
//         centerTitle: true,
//         backgroundColor: AppColors.white,
//         leading: currentBottomBarIndex != 4
//             ? InkWell(
//                 onTap: () {
//                   if (currentBottomBarIndex != 4) {
//                     setState(() {
//                       currentBottomBarIndex = 4;
//                     });
//                   }
//                 },
//                 child: const Icon(
//                   Icons.arrow_back_ios_new,
//                   color: AppColors.primary,
//                   size: 16,
//                 ),
//               )
//             : const SizedBox(),
//         actions: [
//           Obx(
//             () {
//               final isHome = currentBottomBarIndex == 4;
//               final isOnLoginPage = homeController.isLoginPage.value;
//               final isSupportedSwitchUrl =
//                   homeController.isSwitchOn.value == true ||
//                       homeController.isSwitchOn.value == false;
//               final showSwitch =
//                   isHome && isOnLoginPage && isSupportedSwitchUrl;
//               return showSwitch
//                   ? Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: FlutterSwitch(
//                           width: 60.0,
//                           height: 28.0,
//                           valueFontSize: 12.0,
//                           toggleSize: 20.0,
//                           value: homeController.isSwitchOn.value,
//                           borderRadius: 30.0,
//                           padding: 5.0,
//                           activeText: "OFF",
//                           inactiveText: "ON",
//                           // activeText: "ON",
//                           // inactiveText: "OFF",
//                           showOnOff: true,
//                           activeColor: Colors.grey.shade300,
//                           inactiveTextColor: AppColors.white,
//                           inactiveColor: AppColors.primary,
//
//                           // activeColor: AppColors.primary,
//                           // inactiveTextColor: AppColors.black,
//                           // inactiveColor: Colors.grey.shade300,
//                           onToggle: (val) async {
//                             homeController.isSwitchOn.value = val;
//
//                             /// ✅ Show loader before URL reload
//                             homeController.isLoadingPage.value = true;
//                             await SecureStorageUtils.setBool(
//                                 SecureStorageUtils.isProgramSwitchOnKey, val);
//                             bool savedVal = await SecureStorageUtils.getBool(
//                                 SecureStorageUtils.isProgramSwitchOnKey);
//                             print("---on SWITCH----$savedVal");
//                           }),
//                     )
//                   : const SizedBox();
//             },
//           )
//         ],
//         // shape: const RoundedRectangleBorder(
//         //   borderRadius: BorderRadius.only(
//         //     bottomLeft: Radius.circular(20.0),
//         //     bottomRight: Radius.circular(20.0),
//         //   ),
//         // ),
//       ),
//       body: SafeArea(
//         bottom: true,
//         child: currentBottomBarIndex == 0
//             ? const AboutUsWebViewScreen()
//             : currentBottomBarIndex == 1
//                 ? const ContactUsWebViewScreen()
//                 : currentBottomBarIndex == 2
//                     ? const TermAndConditionWebViewScreen()
//                     : currentBottomBarIndex == 3
//                         ? const PrivacyPolicyWebViewScreen()
//                         : currentBottomBarIndex == 4
//                             ? const HomeWebViewScreen()
//                             : const Material(),
//       ),
//       floatingActionButton: showFab
//           ? GestureDetector(
//               onTap: () {
//                 setState(() {
//                   currentBottomBarIndex = 4;
//                 });
//               },
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: AppColors.primary,
//                 child: Image.asset(
//                   "assets/images/home.png",
//                   width: 25,
//                   height: 25,
//                   color: currentBottomBarIndex == 4
//                       ? AppColors.yellow
//                       : AppColors.white,
//                 ),
//               ),
//             )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: AnimatedBottomNavigationBar.builder(
//         itemCount: bottomList.length,
//         tabBuilder: (int index, bool isActive) {
//           final color = isActive ? AppColors.primary : AppColors.grey;
//           return Padding(
//               padding: const EdgeInsets.all(15),
//               child: Image.asset(
//                 "assets/images/${bottomList[index]}",
//                 width: 10,
//                 height: 10,
//                 color: color,
//               ));
//         },
//         backgroundColor: Colors.white,
//         activeIndex: currentBottomBarIndex,
//         gapLocation: GapLocation.center,
//         notchSmoothness: NotchSmoothness.defaultEdge,
//         onTap: (index) {
//           setState(() {
//             print(
//                 '--TAP -homeController.isLoginPage.value---${homeController.isLoginPage.value}');
//             currentBottomBarIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:forge_hrms/controller/home_controller.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:forge_hrms/utils/secure_storage_utils.dart';
import 'package:forge_hrms/webviews/about_us_webview.dart';
import 'package:forge_hrms/webviews/contact_us_webview.dart';
import 'package:forge_hrms/webviews/home_webview.dart';
import 'package:forge_hrms/webviews/privacy_policy_webview.dart';
import 'package:forge_hrms/webviews/term_and_condition_webview.dart';
import 'package:get/get.dart';

class BottomNavigationBarScreen extends StatelessWidget {
  BottomNavigationBarScreen({super.key});

  final RxInt currentBottomBarIndex = 4.obs;
  final homeController = Get.find<HomeController>();

  final List<String> bottomList = [
    "aboutUs.png",
    "contactUs.png",
    "termAndCondition.png",
    "privacyPolicy.png",
  ];

  String title(int index) {
    switch (index) {
      case 0:
        return "About us";
      case 1:
        return "Contact us";
      case 2:
        return "Terms of Use";
      case 3:
        return "Privacy Policy";
      case 4:
        return homeController.isSwitchOn.value ? "WE-Enable" : "Forge Alumnus";
      default:
        return "Forge";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Obx(() {
      final isHome = currentBottomBarIndex.value == 4;
      final isOnLoginPage = homeController.isLoginPage.value;
      final showSwitch = isHome && isOnLoginPage;

      return Scaffold(
        backgroundColor: AppColors.white,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            title(currentBottomBarIndex.value),
            style: const TextStyle(
              fontFamily: 'AGENCYB',
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: AppColors.primary,
            ),
          ),
          leading: currentBottomBarIndex.value != 4
              ? InkWell(
                  onTap: () {
                    currentBottomBarIndex.value = 4;
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.primary,
                    size: 16,
                  ),
                )
              : const SizedBox(),
          actions: [
            if (showSwitch)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    const Text(
                        "Forge Alumnus",
                        /*text: storageService.readStringData(
                                            AppStorageKeys.programName),*/
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize:
                             13.0,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(
                      height: 3,
                    ),
                    FlutterSwitch(
                      width: 60.0,
                      height: 28.0,
                      valueFontSize: 12.0,
                      toggleSize: 20.0,
                      value: homeController.isSwitchOn.value,
                      borderRadius: 30.0,
                      padding: 5.0,
                      activeText: "ON",
                      inactiveText: "OFF",
                      showOnOff: true,
                      activeColor:AppColors.primary ,
                      inactiveTextColor: AppColors.black,
                      inactiveColor: Colors.grey.shade300,
                      activeTextColor: Colors.white,
                      onToggle: (val) async {
                        homeController.isSwitchOn.value = val;
                        homeController.isLoadingPage.value = true;
                        await SecureStorageUtils.setBool(
                          SecureStorageUtils.isProgramSwitchOnKey,
                          val,
                        );
                        print(
                            "----homeController.isSwitchOn.value----${homeController.isSwitchOn.value}");
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (_) {
              switch (currentBottomBarIndex.value) {
                case 0:
                  return const AboutUsWebViewScreen();
                case 1:
                  return const ContactUsWebViewScreen();
                case 2:
                  return const TermAndConditionWebViewScreen();
                case 3:
                  return const PrivacyPolicyWebViewScreen();
                case 4:
                  return const HomeWebViewScreen();
                default:
                  return const HomeWebViewScreen();
              }
            },
          ),
        ),
        floatingActionButton: showFab
            ? GestureDetector(
                onTap: () {
                  currentBottomBarIndex.value = 4;
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Image.asset(
                    "assets/images/home.png",
                    width: 25,
                    height: 25,
                    color: currentBottomBarIndex.value == 4
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
              ),
            );
          },
          backgroundColor: Colors.white,
          activeIndex: currentBottomBarIndex.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          onTap: (index) {
            currentBottomBarIndex.value = index;
          },
        ),
      );
    });
  }
}
