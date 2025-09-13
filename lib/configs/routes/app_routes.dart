import 'package:get/get.dart';
import '/app/weather/bindings/weather_binding.dart';
import '/app/weather/screens/weather_screen.dart';
import '/configs/routes/page_name.dart';

class AppPages {
  static const weather = MyRoutes.weather;

  static const unknownRoute = MyRoutes.unknownRoute;

  static final routes = [
    GetPage(
      name: weather,
      page: () =>  WeatherScreen(),
      title: PageTitle.weather,
      binding: WeatherBinding(),
    ),
  ];
}
