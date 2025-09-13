class ApiPath {
  static const String baseUrlDev = "http://"; // Dev
  static const String baseUrlProd = "http://"; // Prod
  static const String baseUrlLocal = "http://localhost:3000"; // local ou test
  static const String baseUrlImage = "http://"; // base image url

  // time for requests
  static const int receiveTimeout = 30000;
  static const int connectionTimeout = 30000;

  // lien Api
  static const String getWeather = '/weather';
}
