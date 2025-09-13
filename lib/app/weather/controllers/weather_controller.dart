import 'dart:convert';

import 'package:flutter/foundation.dart';
import '/data/models/weather_model.dart';
import '/services/locals/local_storage_service.dart';
import '/configs/injectiondepency/injection.dart';
import '/data/repositories/weather_repository.dart';
import '/services/networks/apis/api_controller_operation.dart';

import '/constants/app_export.dart';

enum WeatherEvent { initial, listWeather }

class WeatherController extends GetxController
    with ApiControllerOperationMixin {
  final weatherResponse = sl<WeatherRepository>();
  Rx<WeatherEvent> weatherEvent = WeatherEvent.initial.obs;

  // États observables
  RxList<Timeline> weatherTimelines = <Timeline>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessages = ''.obs;
  final RxBool hasError = false.obs;
  final Rx<DateTime?> lastUpdate = Rx<DateTime?>(null);
  final RxBool isOffline = false.obs;

  @override
  void onInit() {
    super.onInit();
    getWeatherList();
    getLastUpdateData();
    ever(apiStatus, fireState);
  }

  void getWeatherList() {
    weatherEvent = WeatherEvent.listWeather.obs;
    requestBaseController(weatherResponse.getWeatherList());
  }

  void getLastUpdateData() {
    lastUpdate.value =
        sl<LocalStorageServices>().getLastUpdateData ?? DateTime.now();
  }

  // Méthode pour effacer les erreurs
  void clearError() {
    hasError.value = false;
    errorMessages.value = '';
  }

// Méthodes utiles pour l'affichage
  String getFormattedTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  String getFormattedDate(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      final now = DateTime.now();

      if (dateTime.day == now.day) {
        return 'Aujourd\'hui';
      } else if (dateTime.day == now.day - 1) {
        return 'Hier';
      } else {
        return '${dateTime.day}/${dateTime.month}';
      }
    } catch (e) {
      return 'N/A';
    }
  }

  mapEventToState(WeatherEvent event, ApiState state) {
    switch (event) {
      case WeatherEvent.listWeather:
        switch (state) {
          case ApiState.loading:
            isLoading.value = true;
            hasError.value = false;
            errorMessages.value = '';
            isOffline.value = false;

            break;

          case ApiState.success:
            if (kDebugMode) {
              print("========ca marche=======");
              print("data: $dataResponse");
            }
            WeatherData weartherData =
                weatherDataFromJson(json.encode(dataResponse));
            weatherTimelines = weartherData.data.timelines.obs;

            lastUpdate.value = DateTime.now();

            // Sauvegarde en cache
            sl<LocalStorageServices>().saveLastUpdateData = lastUpdate.value;
            sl<LocalStorageServices>().saveWeatherData = weartherData;

            isLoading.value = false;
            isRefreshing.value = false;
            hasError.value = false;
            errorMessages.value = '';
            isOffline.value = false;
            break;
          case ApiState.failure:
            isLoading.value = false;
            // En cas d'erreur, essaie de charger depuis le cache
            final cachedData = sl<LocalStorageServices>().getWeatherData;
            if (cachedData != null) {
              try {
                WeatherData weatherData =
                    weatherDataFromJson(json.encode(cachedData));
                weatherTimelines.value = weatherData.data.timelines;
                lastUpdate.value = sl<LocalStorageServices>().getLastUpdateData;
                isOffline.value = true;
              } catch (cacheError) {
                if (kDebugMode) {
                  print('Cache parsing error: $cacheError');
                }
              }
            } else {
              // Aucune donnée disponible
            }
            break;
        }
        break;

      default:
    }
  }

  fireState(ApiState weatherApiState) {
    mapEventToState(weatherEvent.value, weatherApiState);
  }
}
