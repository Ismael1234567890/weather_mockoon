import 'package:get/route_manager.dart';
import '/configs/routes/page_name.dart';

class MyNavigation {
  static void goToWeatherScreen() {
    Get.offAllNamed(MyRoutes.weather);
  }

  static void goTo404Page() {
    Get.offAllNamed(MyRoutes.unknownRoute);
  }
}
