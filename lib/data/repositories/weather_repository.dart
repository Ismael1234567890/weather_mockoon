import 'package:dartz/dartz.dart';
import '/configs/injectiondepency/injection.dart';
import '/constants/api_path.dart';
import '/data/models/weather_model.dart';
import '/services/networks/apis/api_base.dart';
import '/services/networks/apis/rest_api_reponse.dart';
import '/services/networks/apis/rest_api_service.dart';

abstract class WeatherRepository {
  Future<Either<List<String>, ApiResponse>> getWeatherList();
}

class WeatherRepositoryImpl extends ApiBase<WeatherData>
    implements WeatherRepository {
  @override
  Future<Either<List<String>, ApiResponse>> getWeatherList() async {
    return await makeRequestApi(
        sl<RestApiServices>().dio.get(ApiPath.getWeather));
  }
}
