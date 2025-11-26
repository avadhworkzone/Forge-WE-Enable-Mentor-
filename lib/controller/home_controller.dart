import 'package:forge_hrms/utils/secure_storage_utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isSwitchOn = false.obs;
  RxBool isLoadingPage = true.obs;
  final RxString currentWebUrl = ''.obs;
  final RxBool isLoginPage = true.obs;
  final RxBool isUserLoggedIn = false.obs; // નવું ઍડ કરો

  @override
  void onInit() {
    super.onInit();
    loadSwitchState();
  }

  void loadSwitchState() async {
    bool savedVal = await SecureStorageUtils.getBool(
        SecureStorageUtils.isProgramSwitchOnKey);
    print("---isProgramSwitchOnKey----$savedVal");
    isSwitchOn.value = savedVal;
  }

  // નવી મેથડ ઍડ કરો - લૉગિન સ્ટેટ સેટ કરવા માટે
  void setUserLoggedIn(bool loggedIn) {
    isUserLoggedIn.value = loggedIn;
  }
}
