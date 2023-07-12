// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settingsAppBarTitle {
    return Intl.message(
      'Settings',
      name: 'settingsAppBarTitle',
      desc: 'Text shown in settings appBar',
      args: [],
    );
  }

  /// `Show all`
  String get settingsGlobalFilterAll {
    return Intl.message(
      'Show all',
      name: 'settingsGlobalFilterAll',
      desc: 'Text shown in global filter settings, means show all trips.',
      args: [],
    );
  }

  /// `Show for today`
  String get settingsGlobalFilterToday {
    return Intl.message(
      'Show for today',
      name: 'settingsGlobalFilterToday',
      desc: 'Text shown in global filter settings, means show by default only today trips.',
      args: [],
    );
  }

  /// `Change theme`
  String get settingsChangeTheme {
    return Intl.message(
      'Change theme',
      name: 'settingsChangeTheme',
      desc: 'Text shown in settings, for changing theme.',
      args: [],
    );
  }

  /// `No GTFS file`
  String get settingsNoGtfsFile {
    return Intl.message(
      'No GTFS file',
      name: 'settingsNoGtfsFile',
      desc: 'Text shown in settings when no GTFS file is found on device.',
      args: [],
    );
  }

  /// `GTFS file was downloaded `
  String get settingsGtfsFileWasDownloaded {
    return Intl.message(
      'GTFS file was downloaded ',
      name: 'settingsGtfsFileWasDownloaded',
      desc: 'Text shown in settings when GTFS file as downloaded.',
      args: [],
    );
  }

  /// `All`
  String get settingsLocalFilterAll {
    return Intl.message(
      'All',
      name: 'settingsLocalFilterAll',
      desc: 'Text shown in local filter settings, means show all trips.',
      args: [],
    );
  }

  /// `Today`
  String get settingsLocalFilterToday {
    return Intl.message(
      'Today',
      name: 'settingsLocalFilterToday',
      desc: 'Text shown in local filter settings, means show only today trips.',
      args: [],
    );
  }

  /// `Tallinn`
  String get settingsTallinn {
    return Intl.message(
      'Tallinn',
      name: 'settingsTallinn',
      desc: 'City name, Tallinn, shown in 1) settings 2) at home screen app bar.',
      args: [],
    );
  }

  /// `Tartu`
  String get settingsTartu {
    return Intl.message(
      'Tartu',
      name: 'settingsTartu',
      desc: 'City name, Tartu, shown in 1) settings 2) at home screen app bar.',
      args: [],
    );
  }

  /// `Scooters filter`
  String get homeScooterFAB {
    return Intl.message(
      'Scooters filter',
      name: 'homeScooterFAB',
      desc: 'Text used as tooltip for FAB with scooter icon.',
      args: [],
    );
  }

  /// `Bike filter`
  String get homeBikeFAB {
    return Intl.message(
      'Bike filter',
      name: 'homeBikeFAB',
      desc: 'Text used as tooltip for FAB with bike icon.',
      args: [],
    );
  }

  /// `Stop filter`
  String get homeStopFAB {
    return Intl.message(
      'Stop filter',
      name: 'homeStopFAB',
      desc: 'Text used as tooltip for FAB with bus icon.',
      args: [],
    );
  }

  /// `Settings`
  String get homeAppBarSettingsIcon {
    return Intl.message(
      'Settings',
      name: 'homeAppBarSettingsIcon',
      desc: 'Text used as tooltip for gear icon button.',
      args: [],
    );
  }

  /// `Refresh`
  String get homeAppBarRefreshIcon {
    return Intl.message(
      'Refresh',
      name: 'homeAppBarRefreshIcon',
      desc: 'Text used as tooltip for refresh icon button.',
      args: [],
    );
  }

  /// `You have the latest GTFS data.`
  String get snackbarNoNeedToDownload {
    return Intl.message(
      'You have the latest GTFS data.',
      name: 'snackbarNoNeedToDownload',
      desc: 'Text used in snackbar, if GTFS data doesn\'t need to be downloaded.',
      args: [],
    );
  }

  /// `Server error. Cant fetch Bolt scooters data.`
  String get snackbarCantFetchBoltScootersData {
    return Intl.message(
      'Server error. Cant fetch Bolt scooters data.',
      name: 'snackbarCantFetchBoltScootersData',
      desc: 'Text used in snackbar, if Bolt scooters data can\'t be downloaded.',
      args: [],
    );
  }

  /// `Server error. Cant fetch Tartu Smart bike data.`
  String get snackbarCantFetchTartuSmartBikeData {
    return Intl.message(
      'Server error. Cant fetch Tartu Smart bike data.',
      name: 'snackbarCantFetchTartuSmartBikeData',
      desc: 'Text used in snackbar, if Tartu Smart bike data can\'t be downloaded.',
      args: [],
    );
  }

  /// `No Internet connection. Please check your connection and try again.`
  String get snackbarNoInternetConnection {
    return Intl.message(
      'No Internet connection. Please check your connection and try again.',
      name: 'snackbarNoInternetConnection',
      desc: 'Text used in snackbar when device has internet connection problems.',
      args: [],
    );
  }

  /// `Device is not supported.`
  String get snackbarDeviceIsNotSupported {
    return Intl.message(
      'Device is not supported.',
      name: 'snackbarDeviceIsNotSupported',
      desc: 'Text used in snackbar when device is not supported by app.',
      args: [],
    );
  }

  /// `No city was picked.`
  String get snackbarCityIsNotPicked {
    return Intl.message(
      'No city was picked.',
      name: 'snackbarCityIsNotPicked',
      desc: 'Text used in snackbar when no city was picked.',
      args: [],
    );
  }

  /// `No file is present, press refresh button to download.`
  String get snackbarNoGtfsFileIsPresent {
    return Intl.message(
      'No file is present, press refresh button to download.',
      name: 'snackbarNoGtfsFileIsPresent',
      desc: 'Text used in snackbar when no GTFS file is present.',
      args: [],
    );
  }

  /// `Get geolocation`
  String get mapScreenGpsFAB {
    return Intl.message(
      'Get geolocation',
      name: 'mapScreenGpsFAB',
      desc: 'Text used as tooltip for FAB with gps icon.',
      args: [],
    );
  }

  /// `Press to see stoptimes`
  String get stopMarkerShowAllForwardStoptimesButton {
    return Intl.message(
      'Press to see stoptimes',
      name: 'stopMarkerShowAllForwardStoptimesButton',
      desc: 'Text used on button to see stoptimes.',
      args: [],
    );
  }

  /// `Russian`
  String get settingsLanguageRussian {
    return Intl.message(
      'Russian',
      name: 'settingsLanguageRussian',
      desc: 'Text used on dropdown, which responsible for picking russian language.',
      args: [],
    );
  }

  /// `English`
  String get settingsLanguageEnglish {
    return Intl.message(
      'English',
      name: 'settingsLanguageEnglish',
      desc: 'Text used on dropdown, which responsible for picking english language.',
      args: [],
    );
  }

  /// `Some error occurred. Please try again later.`
  String get someErrorOccurred {
    return Intl.message(
      'Some error occurred. Please try again later.',
      name: 'someErrorOccurred',
      desc: 'Text used in snackbar, when non-specified error occurred.',
      args: [],
    );
  }

  /// `Permission denied, you cannot see your location on map.`
  String get geolocationPermissionDenied {
    return Intl.message(
      'Permission denied, you cannot see your location on map.',
      name: 'geolocationPermissionDenied',
      desc: 'Text used in snackbar, when user denied geolocation permission.',
      args: [],
    );
  }

  /// `Could not load required info.`
  String get microMobilityCouldNotLoad {
    return Intl.message(
      'Could not load required info.',
      name: 'microMobilityCouldNotLoad',
      desc: 'Text used in modal bottom sheet in micro mobility related markers if there is problems loading required info.',
      args: [],
    );
  }

  /// `Battery Charge: {charge}%`
  String modalBottomSheetScooterCharge(Object charge) {
    return Intl.message(
      'Battery Charge: $charge%',
      name: 'modalBottomSheetScooterCharge',
      desc: 'Text used in modal bottom sheet in scooter markers to give user information about scooter charge.',
      args: [charge],
    );
  }

  /// `Price: {price}`
  String modalBottomSheetScooterPrice(Object price) {
    return Intl.message(
      'Price: $price',
      name: 'modalBottomSheetScooterPrice',
      desc: 'Text used in modal bottom sheet in scooter markers to give user information about scooter per-minute price.',
      args: [price],
    );
  }

  /// `Go to {app} app`
  String modalBottomSheetScooterGoToApp(Object app) {
    return Intl.message(
      'Go to $app app',
      name: 'modalBottomSheetScooterGoToApp',
      desc: 'Text used on button on modal bottom sheet in scooter markers to show user that clicking this button will redirect him to specified app.',
      args: [app],
    );
  }

  /// `Pedelec Bikes: {count}`
  String modalBottomSheetTartuBikesPedelecCount(Object count) {
    return Intl.message(
      'Pedelec Bikes: $count',
      name: 'modalBottomSheetTartuBikesPedelecCount',
      desc: 'Text used in modal bottom sheet in bike markers to give user information about number of pedelec bikes on station.',
      args: [count],
    );
  }

  /// `Bikes: {count}`
  String modalBottomSheetTartuBikesBikeCount(Object count) {
    return Intl.message(
      'Bikes: $count',
      name: 'modalBottomSheetTartuBikesBikeCount',
      desc: 'Text used in modal bottom sheet in bike markers to give user information about number of non-pedelec bikes on station.',
      args: [count],
    );
  }

  /// `Enter stop name.`
  String get stopSearchHintText {
    return Intl.message(
      'Enter stop name.',
      name: 'stopSearchHintText',
      desc: 'Text used in stop search text field.',
      args: [],
    );
  }

  /// `Mon`
  String get mon {
    return Intl.message(
      'Mon',
      name: 'mon',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tue {
    return Intl.message(
      'Tue',
      name: 'tue',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wed {
    return Intl.message(
      'Wed',
      name: 'wed',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thu {
    return Intl.message(
      'Thu',
      name: 'thu',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get fri {
    return Intl.message(
      'Fri',
      name: 'fri',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get sat {
    return Intl.message(
      'Sat',
      name: 'sat',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sun {
    return Intl.message(
      'Sun',
      name: 'sun',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: 'Text used on button, which responsible for signing in with Google.',
      args: [],
    );
  }

  /// `Pick a city`
  String get changeCity {
    return Intl.message(
      'Pick a city',
      name: 'changeCity',
      desc: 'Text used on dropdown, which responsible for changing city.',
      args: [],
    );
  }

  /// `Change language`
  String get changeLanguage {
    return Intl.message(
      'Change language',
      name: 'changeLanguage',
      desc: 'Text used on dropdown, which responsible for changing language.',
      args: [],
    );
  }

  /// `Change filter`
  String get changeFilter {
    return Intl.message(
      'Change filter',
      name: 'changeFilter',
      desc: 'Text used on dropdown, which responsible for changing language.',
      args: [],
    );
  }

  /// `Estonian`
  String get settingsLanguageEstonian {
    return Intl.message(
      'Estonian',
      name: 'settingsLanguageEstonian',
      desc: 'Text used on dropdown, which responsible for picking english language.',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'et'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}