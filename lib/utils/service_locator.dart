import 'package:get_it/get_it.dart';
import 'package:mobility_app/data/repositories/settings_repository.dart';

import '../constants/api_links/api_links.dart';
import '../constants/api_links/custom_api_links.dart';
import '../constants/api_links/production_api_links.dart';
import '../constants/api_links/test_api_links.dart';
import '../data/data_sources/gtfs_file_source.dart';
import '../data/providers/bolt_scooter_api_provider.dart';
import '../data/providers/estonia_public_transport_api_provider.dart';
import '../data/providers/tartu_bike_station_api_provider.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/vehicle_repository.dart';
import '../domain/usecases/filter_trips_by_direction.dart';
import '../domain/usecases/get_calendar.dart';
import '../domain/usecases/get_stops.dart';
import '../domain/user_repositories/usecases/download_user_settings.dart';
import '../domain/user_repositories/usecases/sign_in_with_google.dart';
import '../domain/user_repositories/usecases/sign_out.dart';
import '../domain/user_repositories/usecases/upload_user_settings.dart';
import '../domain/user_repositories/user_repository.dart';

/// Function, where we setup GetIt service locators.
void setUpServicesLocator({
  required bool isProductionForTartuBikesLink,
  required bool isProductionForBoltScooterLink,
  required bool isProductionForGtfsLink,
  required bool isProductionForBoltHeader,
}) {
  final getIt = GetIt.instance;
  getIt
  // Links used in app.
    ..registerLazySingleton<ApiLinks>(
      () => CustomApiLinks(
        tartuBikesLink: isProductionForTartuBikesLink
            ? ProductionApiLinks().tartuBikesLink
            : TestApiLinks().tartuBikesLink,
        boltScooterLink: isProductionForBoltScooterLink
            ? ProductionApiLinks().boltScooterLink
            : TestApiLinks().boltScooterLink,
        gtfsLink: isProductionForGtfsLink ? ProductionApiLinks().gtfsLink : TestApiLinks().gtfsLink,
        boltHeader:
            isProductionForBoltHeader ? ProductionApiLinks().boltHeader : TestApiLinks().boltHeader,
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
    // Public transport related services.
  ..registerLazySingleton(EstoniaPublicTransportApiProvider.new)
  ..registerLazySingleton(GTFSFileSource.new)
  ..registerLazySingleton(VehicleRepository.new)
  ..registerLazySingleton(() => GetStops(repository: getIt.get<VehicleRepository>()))
  ..registerLazySingleton(() => GetCalendar(repository: getIt.get<VehicleRepository>()))
  ..registerLazySingleton(FilterTripsByDirection.new);
}
