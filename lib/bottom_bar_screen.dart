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

  // Store menu items from API
  final RxList<Map<String, String>> menuItems = <Map<String, String>>[].obs;
  final RxBool isLoadingMenu = true.obs;

  // Store home data separately
  final RxString homeIcon = "".obs;
  final RxString homeTitle = "Home".obs;
  final RxString homeUrl = "".obs;
  final RxString homeWeenableUrl = "".obs;

  // Flag to track if data is initialized
  final RxBool isDataInitialized = false.obs;


  @override
  void initState() {
    super.initState();
    // Set default values immediately
    setDefaultMenuItems();
    // Then fetch from API
    fetchMenuData();
  }

  Future<void> fetchMenuData() async {
    try {
      isLoadingMenu.value = true;

      var request = http.Request('GET', Uri.parse('https://forgealumnus.com/api/far/get-menu'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("API call successful");
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);

        if (jsonResponse['success'] == true) {
          final List<dynamic> menuData = jsonResponse['result']['menu'];

          List<Map<String, String>> items = [];

          for (var item in menuData) {
            String imageUrl = item['image'] ?? "";
            String title = item['title'] ?? "";
            String url = item['url'] ?? "";

            // Store home data separately
            if (title.toLowerCase() == "home") {
              homeIcon.value = imageUrl;
              homeTitle.value = title;
              homeUrl.value = url;
              homeWeenableUrl.value = item['weenable_url'] ?? "";
              continue; // Skip adding home to bottom navigation list
            }

            // Add to menu items with all data
            items.add({
              'image': imageUrl,
              'title': title,
              'url': url,
            });
          }

          menuItems.assignAll(items);
        } else {
          print('API returned error: ${jsonResponse['error']['message']}');
        }
      } else {
        print('HTTP Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching menu: $e');
    } finally {
      isLoadingMenu.value = false;
      isDataInitialized.value = true;
    }
  }

  void setDefaultMenuItems() {
    // Set default menu items as fallback - call this immediately in initState
    menuItems.assignAll([
      {
        'image': 'https://forgealumnus.com/frontend/images/far/aboutUs.png',
        'title': 'About Us',
        'url': 'https://forgealumnus.com/about-us',
      },
      {
        'image': 'https://forgealumnus.com/frontend/images/far/contactUs.png',
        'title': 'Contact Us',
        'url': 'https://forgealumnus.com/contact',
      },
      {
        'image': 'https://forgealumnus.com/frontend/images/far/termAndCondition.png',
        'title': 'Terms of use',
        'url': 'https://forgealumnus.com/terms',
      },
      {
        'image': 'https://forgealumnus.com/frontend/images/far/privacyPolicy.png',
        'title': 'Privacy Policy',
        'url': 'https://forgealumnus.com/privacy/policy',
      },
    ]);

    // Set default home data
    homeIcon.value = "https://forgealumnus.com/frontend/images/far/home.png";
    homeTitle.value = "Home";
    homeUrl.value = "https://forgealumnus.com/forge/login";
    homeWeenableUrl.value = "https://forgealumnus.com/WE-enable/login";
  }

  String title(int index) {
    // For home screen (index 4)
    if (index == 4) {
      return homeController.isSwitchOn.value ? "WE-Enable" : "Forge Alumnus";
    }

    // For bottom navigation items (index 0-3)
    if (index >= 0 && index < menuItems.length) {
      return menuItems[index]['title']!;
    }

    return "Forge"; // default fallback
  }

  // Helper method to get URL for specific index
  String getUrlForIndex(int index) {
    if (index >= 0 && index < menuItems.length) {
      return menuItems[index]['url']!;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Obx(() {
      // Show loading indicator only if we don't have default data AND still loading
      if (isLoadingMenu.value && menuItems.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final isHome = currentBottomBarIndex.value == 4;
      final isOnLoginPage = homeController.isLoginPage.value;
      final isUserLoggedIn = homeController.isUserLoggedIn.value;
      final showSwitch = (isHome || isOnLoginPage) && !isUserLoggedIn;

      // Calculate safe active index for bottom navigation
      final int safeActiveIndex = currentBottomBarIndex.value == 4
          ? -1 // No active item when home is selected
          : currentBottomBarIndex.value.clamp(0, menuItems.length - 1);

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
              Obx(() => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Forge Alumnus",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: "AGENCYB",
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
              )),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (_) {
              switch (currentBottomBarIndex.value) {
                case 0:
                  return AboutUsWebViewScreen(
                    aboutUrl: getUrlForIndex(0),
                  );
                case 1:
                  return ContactUsWebViewScreen(
                    contactUsUrl: getUrlForIndex(1),
                  );
                case 2:
                  return TermAndConditionWebViewScreen(
                    termsConditionUrl: getUrlForIndex(2),
                  );
                case 3:
                  return PrivacyPolicyWebViewScreen(
                    privacyUrl: getUrlForIndex(3),
                  );
                case 4:
                  return HomeWebViewScreen(
                    url: homeUrl.value.isNotEmpty
                        ? homeUrl.value
                        : "https://forgealumnus.com/forge/login",
                    weEnable: homeWeenableUrl.value.isNotEmpty
                        ? homeWeenableUrl.value
                        : "https://forgealumnus.com/WE-enable/login",
                  );
                default:
                  return HomeWebViewScreen(
                    url: homeUrl.value.isNotEmpty
                        ? homeUrl.value
                        : "https://forgealumnus.com/forge/login",
                    weEnable: homeWeenableUrl.value.isNotEmpty
                        ? homeWeenableUrl.value
                        : "https://forgealumnus.com/WE-enable/login",
                  );
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
            child: Obx(() {
              String iconToUse = homeIcon.value.isNotEmpty
                  ? homeIcon.value
                  : "https://forgealumnus.com/frontend/images/far/home.png";

              return Image.network(
                iconToUse,
                width: 25,
                height: 25,
                color: currentBottomBarIndex.value == 4
                    ? AppColors.yellow
                    : AppColors.white,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/home.png",
                    width: 25,
                    height: 25,
                    color: currentBottomBarIndex.value == 4
                        ? AppColors.yellow
                        : AppColors.white,
                  );
                },
              );
            }),
          ),
        )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: menuItems.length,
          tabBuilder: (int index, bool isActive) {
            final bool shouldBeActive = currentBottomBarIndex.value == index;
            final color = shouldBeActive ? AppColors.primary : AppColors.grey;

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Image.network(
                menuItems[index]['image']!,
                width: 10,
                height: 10,
                color: color,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error_outline,
                    size: 10,
                    color: color,
                  );
                },
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
}