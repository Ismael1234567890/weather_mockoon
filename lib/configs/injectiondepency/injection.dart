import '/services/locals/local_storage_service.dart';
import '/data/repositories/weather_repository.dart';
import '/constants/app_export.dart';
import '/services/networks/apis/rest_api_service.dart';

final sl = GetIt.instance;

// c'est ici que je gere mes injections de dependances avec getIt
Future<void> init() async {
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(),
  );

  sl.registerLazySingleton(() => RestApiServices());

  // environnements set local | dev | prod
  sl.get<RestApiServices>().setEnvironment(EnvironmentType.local);

  // local storage (share preference) init
  sl.registerFactory<LocalStorageServices>(
    () => LocalStorageServices(),
  );

  await sl<LocalStorageServices>().init();
}
