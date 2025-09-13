import 'package:get/get.dart';
import '/app/home/screens/home_screen.dart';
import '/configs/routes/page_name.dart';

class AppPages {
  static const initial = MyRoutes.initial;
  static const login = MyRoutes.login;

  static const unknownRoute = MyRoutes.unknownRoute;

  static final routes = [
    GetPage(
      name: initial,
      page: () => const MyHomePage(),
      title: PageTitle.initial,
    ),
  ];
}
