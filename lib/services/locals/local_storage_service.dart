import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/models/weather_model.dart';
import '/utils/helpers/strings.dart';

/// contains all service to get data from local
class LocalStorageServices {
  static SharedPreferences? _sharedPref;

  static final LocalStorageServices _localStorageServices =
      LocalStorageServices._internal();

  factory LocalStorageServices() {
    return _localStorageServices;
  }
  LocalStorageServices._internal();

  Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  set saveWeatherData(WeatherData? keyWeather_) {
    _sharedPref?.setString(weatherKey, weatherDataToJson(keyWeather_!));
  }

   set saveLastUpdateData(DateTime? lastUpdateKey_) {
    _sharedPref?.setString(lastUpdateKey, lastUpdateKey_.toString());
  }


  WeatherData? get getWeatherData {
    return (_sharedPref != null && _sharedPref!.containsKey(weatherKey))
        ? weatherDataFromJson(_sharedPref?.getString(weatherKey) ?? "")
        : null;
  }

  DateTime? get getLastUpdateData {
    return (_sharedPref != null && _sharedPref!.containsKey(lastUpdateKey))
        ? DateTime.parse(_sharedPref?.getString(lastUpdateKey) ?? "")
        : null;
  }

  removeToken() {
    _sharedPref?.remove(weatherKey);
  }

  clear() {
    _sharedPref?.clear();
  }
}
