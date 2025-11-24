import 'dart:convert';
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
import 'package:http/http.dart' as http;

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  final RxInt currentBottomBarIndex = 4.obs;
  final homeController = Get.find<HomeController>();

  // Replace static lists with dynamic lists from API
  final RxList<String> bottomList = <String>[].obs;
  final RxList<String> menuTitles = <String>[].obs;
  final RxBool isLoadingMenu = false.obs;

  @override
  void initState() {
    super.initState();
    fetchMenuData();
  }

  Future<void> fetchMenuData() async {
    try {
      isLoadingMenu.value = true;

      var request = http.Request('GET', Uri.parse('https://forgealumnus.com/api/far/get-menu'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);

        if (jsonResponse['success'] == true) {
          final List<dynamic> menuData = jsonResponse['result']['menu'];

          // Extract image URLs and titles from API response
          List<String> imageUrls = [];
          List<String> titles = [];

          for (var item in menuData) {
            String imageUrl = item['image'];
            String title = item['title'];

            // Extract filename from URL and map to local asset name
            if (imageUrl.contains('aboutUs.png')) {
              imageUrls.add("aboutUs.png");
            } else if (imageUrl.contains('contactUs.png')) {
              imageUrls.add("contactUs.png");
            } else if (imageUrl.contains('termAndCondition.png')) {
              imageUrls.add("termAndCondition.png");
            } else if (imageUrl.contains('privacyPolicy.png')) {
              imageUrls.add("privacyPolicy.png");
            } else {
              imageUrls.add("aboutUs.png"); // default fallback
            }

            titles.add(title);
          }

          bottomList.assignAll(imageUrls);
          menuTitles.assignAll(titles);
        } else {
          print('API returned error: ${jsonResponse['error']['message']}');
          // Fallback to default list if API fails
          setDefaultMenuItems();
        }
      } else {
        print('HTTP Error: ${response.reasonPhrase}');
        // Fallback to default list if API fails
        setDefaultMenuItems();
      }
    } catch (e) {
      print('Error fetching menu: $e');
      // Fallback to default list if API fails
      setDefaultMenuItems();
    } finally {
      isLoadingMenu.value = false;
    }
  }

  void setDefaultMenuItems() {
    // Set default menu items as fallback
    bottomList.assignAll([
      "aboutUs.png",
      "contactUs.png",
      "termAndCondition.png",
      "privacyPolicy.png",
    ]);

    menuTitles.assignAll([
      "About us",
      "Contact us",
      "Terms of Use",
      "Privacy Policy",
    ]);
  }

  String title(int index) {
    // For home screen (index 4)
    if (index == 4) {
      return homeController.isSwitchOn.value ? "WE-Enable" : "Forge Alumnus";
    }

    // For bottom navigation items (index 0-3)
    if (index >= 0 && index < menuTitles.length) {
      return menuTitles[index];
    }

    return "Forge"; // default fallback
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Obx(() {
      final isHome = currentBottomBarIndex.value == 4;
      final isOnLoginPage = homeController.isLoginPage.value;
      final showSwitch = isHome && isOnLoginPage;

      // Calculate safe active index for bottom navigation
      // When home is selected (index 4), show no active item in bottom nav
      final int safeActiveIndex = currentBottomBarIndex.value == 4
          ? -1 // No active item when home is selected
          : currentBottomBarIndex.value.clamp(0, bottomList.length - 1);

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
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
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
                      activeColor: AppColors.primary,
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
                        print("----homeController.isSwitchOn.value----${homeController.isSwitchOn.value}");
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
        bottomNavigationBar: bottomList.isEmpty
            ? _buildLoadingBottomNav() // Show loading state
            : AnimatedBottomNavigationBar.builder(
          itemCount: bottomList.length,
          tabBuilder: (int index, bool isActive) {
            // When home is selected (currentBottomBarIndex == 4),
            // all bottom nav items should be inactive
            final bool shouldBeActive = currentBottomBarIndex.value == index;
            final color = shouldBeActive ? AppColors.primary : AppColors.grey;

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
          activeIndex: safeActiveIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          onTap: (index) {
            currentBottomBarIndex.value = index;
          },
        ),
      );
    });
  }

  // Loading state for bottom navigation
  Widget _buildLoadingBottomNav() {
    return Container(
      height: 60,
      color: Colors.white,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}