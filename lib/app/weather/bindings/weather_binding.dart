import '../controllers/weather_controller.dart';
import '/constants/app_export.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    // Initialisation du contrôleur
     Get.lazyPut(() => WeatherController());
  }
}