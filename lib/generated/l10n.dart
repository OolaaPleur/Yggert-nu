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

  /// `All`
  String get settingsGlobalFilterAll {
    return Intl.message(
      'All',
      name: 'settingsGlobalFilterAll',
      desc: 'Text shown in global filter settings, means show by default all trips.',
      args: [],
    );
  }

  /// `Today`
  String get settingsGlobalFilterToday {
    return Intl.message(
      'Today',
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
      desc: 'Text shown in local filter settings, means show by default all trips.',
      args: [],
    );
  }

  /// `Today`
  String get settingsLocalFilterToday {
    return Intl.message(
      'Today',
      name: 'settingsLocalFilterToday',
      desc: 'Text shown in local filter settings, means show by default only today trips.',
      args: [],
    );
  }

  /// `Tallinn`
  String get settingsTallinn {
    return Intl.message(
      'Tallinn',
      name: 'settingsTallinn',
      desc: 'Text shown in local filter settings, means show by default only today trips.',
      args: [],
    );
  }

  /// `Tartu`
  String get settingsTartu {
    return Intl.message(
      'Tartu',
      name: 'settingsTartu',
      desc: 'Text shown in local filter settings, means show by default only today trips.',
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
      desc: 'Text used on press to see stoptimes button.',
      args: [],
    );
  }

  /// `Language`
  String get settingsLanguage {
    return Intl.message(
      'Language',
      name: 'settingsLanguage',
      desc: 'Text used on press to see stoptimes button.',
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
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