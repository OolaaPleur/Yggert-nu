import 'package:get_it/get_it.dart';
import 'package:mobility_app/data/data_sources/gtfs_data_operations.dart';
import 'package:mobility_app/data/repositories/public_transport_repository.dart';
import 'package:mobility_app/data/repositories/settings_repository.dart';

import '../constants/api_links.dart';
import '../data/data_sources/gtfs_file_source.dart';
import '../data/providers/estonia_public_transport_api_provider.dart';
import '../data/providers/scooter/bolt_api_provider.dart';
import '../data/providers/scooter/hoog_scooter_api_provider.dart';
import '../data/providers/scooter/tuul_scooter_api_provider.dart';
import '../data/providers/tartu_bike_station_api_provider.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/vehicle_repository.dart';
import '../domain/usecases/filter_trips_by_direction.dart';
import '../domain/usecases/get_calendar.dart';
import '../domain/user_repositories/usecases/download_user_settings.dart';
import '../domain/user_repositories/usecases/sign_in_with_google.dart';
import '../domain/user_repositories/usecases/sign_out.dart';
import '../domain/user_repositories/usecases/upload_user_settings.dart';
import '../domain/user_repositories/user_repository.dart';
import '../screens/map/markers/map_marker.dart';

/// Function, where we setup GetIt service locators.
void setUpServicesLocator({
  required bool isProductionForTartuBikesLink,
  required bool isProductionForBoltScooterLink,
  required bool isProductionForGtfsLink,
  required bool isProductionForTuulScooterLink,
  required bool isProductionForGeolocation,
  required bool isProductionHoogScooterLink,
  required bool isProductionBoltCarsLink,
}) {
  final getIt = GetIt.instance;
  getIt
    // Links used in app.
    ..registerLazySingleton<ApiLinks>(
      () => ApiLinks(
        tartuBikesLink:
            isProductionForTartuBikesLink ? getApiLinks.tartuBikesLink : getApiLinks.dummyLink,
        boltScooterLink:
            isProductionForBoltScooterLink ? getApiLinks.boltScooterLink : getApiLinks.dummyLink,
        gtfsLink: isProductionForGtfsLink ? getApiLinks.gtfsLink : getApiLinks.dummyLink,
        tuulScooterLink: isProductionForTuulScooterLink ? getApiLinks.tuulScooterLink : getApiLinks.dummyLink,
          isProductionForGeolocation: isProductionForGeolocation,
        hoogScooterLink: isProductionHoogScooterLink ? getApiLinks.hoogScooterLink : getApiLinks.dummyLink,
        boltCarsLink: isProductionBoltCarsLink? getApiLinks.boltCarsLink : getApiLinks.dummyLink,
      ),
    )
    // Settings and Authentication related services.
    ..registerLazySingleton<SettingsRepository>(SettingsRepository.new)
    ..registerLazySingleton<UserRepository>(UserRepositoryImplementation.new)
    ..registerLazySingleton<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(getIt.get<UserRepository>()),
    )
    ..registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(getIt.get<UserRepository>()),
    )
    ..registerLazySingleton<UploadUserSettingsUseCase>(
      () => UploadUserSettingsUseCase(getIt.get<UserRepository>()),
    )
    ..registerLazySingleton<DownloadUserSettingsUseCase>(
      () => DownloadUserSettingsUseCase(getIt.get<UserRepository>()),
    )
    // Micro mobility services.
    ..registerLazySingleton(BoltScooterApiProvider.new)
    ..registerLazySingleton(TartuBikeStationApiProvider.new)
    ..registerLazySingleton(TuulScooterApiProvider.new)
    ..registerLazySingleton(HoogScooterApiProvider.new)
    // Public transport related services.
    ..registerLazySingleton(EstoniaPublicTransportApiProvider.new)
    ..registerLazySingleton(GtfsDataOperations.new)
    ..registerLazySingleton(PublicTransportRepository.new)
    ..registerLazySingleton(GTFSFileSource.new)
    ..registerLazySingleton(VehicleRepository.new)
    ..registerLazySingleton(() => GetCalendar(repository: getIt.get<VehicleRepository>()))
    ..registerLazySingleton(FilterTripsByDirection.new)
    // Creating markers.
    ..registerLazySingleton(CreateMapMarkerList.new);
}
