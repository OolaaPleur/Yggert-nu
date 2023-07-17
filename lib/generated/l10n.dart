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
  String get tallinn {
    return Intl.message(
      'Tallinn',
      name: 'tallinn',
      desc: 'City name, Tallinn, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Haapsalu`
  String get haapsalu {
    return Intl.message(
      'Haapsalu',
      name: 'haapsalu',
      desc: 'City name, Haapsalu, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Tartu`
  String get tartu {
    return Intl.message(
      'Tartu',
      name: 'tartu',
      desc: 'City name, Tartu, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Jõhvi`
  String get johvi {
    return Intl.message(
      'Jõhvi',
      name: 'johvi',
      desc: 'City name, Jõhvi, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Kohtla-Järve`
  String get kohtlaJarve {
    return Intl.message(
      'Kohtla-Järve',
      name: 'kohtlaJarve',
      desc: 'City name, Kohtla-Järve, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Kuressaare`
  String get kuressaare {
    return Intl.message(
      'Kuressaare',
      name: 'kuressaare',
      desc: 'City name, Kuressaare, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Narva`
  String get narva {
    return Intl.message(
      'Narva',
      name: 'narva',
      desc: 'City name, Narva, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Pärnu`
  String get parnu {
    return Intl.message(
      'Pärnu',
      name: 'parnu',
      desc: 'City name, Pärnu, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Rakvere`
  String get rakvere {
    return Intl.message(
      'Rakvere',
      name: 'rakvere',
      desc: 'City name, Rakvere, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Viljandi`
  String get viljandi {
    return Intl.message(
      'Viljandi',
      name: 'viljandi',
      desc: 'City name, Viljandi, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
      args: [],
    );
  }

  /// `Võru`
  String get voru {
    return Intl.message(
      'Võru',
      name: 'voru',
      desc: 'City name, Võru, shown in 1) settings 2) at home screen app bar 3) at introduction screen in dropdown list.',
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

  /// `Server error. Cant fetch Tuul scooters data.`
  String get snackbarCantFetchTuulScootersData {
    return Intl.message(
      'Server error. Cant fetch Tuul scooters data.',
      name: 'snackbarCantFetchTuulScootersData',
      desc: 'Text used in snackbar, if Tuul scooters data can\'t be downloaded.',
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

  /// `No Internet connection. Please check your connection, press refresh button and try again.`
  String get snackbarNoInternetConnection {
    return Intl.message(
      'No Internet connection. Please check your connection, press refresh button and try again.',
      name: 'snackbarNoInternetConnection',
      desc: 'Text used in snackbar when device has internet connection problems.',
      args: [],
    );
  }

  /// `No Internet connection. Please check your connection and try again.`
  String get snackbarNoInternetConnectionInSettings {
    return Intl.message(
      'No Internet connection. Please check your connection and try again.',
      name: 'snackbarNoInternetConnectionInSettings',
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

  /// `Price: {price}/min`
  String modalBottomSheetScooterPrice(Object price) {
    return Intl.message(
      'Price: $price/min',
      name: 'modalBottomSheetScooterPrice',
      desc: 'Text used in modal bottom sheet in scooter markers to give user information about scooter per-minute price.',
      args: [price],
    );
  }

  /// `Start price: {price}`
  String modalBottomSheetScooterStartPrice(Object price) {
    return Intl.message(
      'Start price: $price',
      name: 'modalBottomSheetScooterStartPrice',
      desc: 'Text used in modal bottom sheet in scooter markers to give user information about scooter start price.',
      args: [price],
    );
  }

  /// `Reserve {price}/min`
  String modalBottomSheetScooterReservePrice(Object price) {
    return Intl.message(
      'Reserve $price/min',
      name: 'modalBottomSheetScooterReservePrice',
      desc: 'Text used in modal bottom sheet in scooter markers to give user information about scooter reserve price.',
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

  /// `Welcome to the Yggert Nu!`
  String get introFirstScreenHeader {
    return Intl.message(
      'Welcome to the Yggert Nu!',
      name: 'introFirstScreenHeader',
      desc: 'Text used on intro page as header for first screen.',
      args: [],
    );
  }

  /// `Experience a revolution in urban mobility. Seamlessly integrate your travel with rental scooters, bikes, cars, and public transport all in one app.`
  String get introFirstScreenBody {
    return Intl.message(
      'Experience a revolution in urban mobility. Seamlessly integrate your travel with rental scooters, bikes, cars, and public transport all in one app.',
      name: 'introFirstScreenBody',
      desc: 'Text used on intro page as body for first screen.',
      args: [],
    );
  }

  /// `All Your Transport Options in One Place`
  String get introSecondScreenHeader {
    return Intl.message(
      'All Your Transport Options in One Place',
      name: 'introSecondScreenHeader',
      desc: 'Text used on intro page as header for second screen.',
      args: [],
    );
  }

  /// `Find the fastest and most convenient mode of transportation tailored to your needs. All available rentals and public transit options are integrated onto one convenient map.`
  String get introSecondScreenBody {
    return Intl.message(
      'Find the fastest and most convenient mode of transportation tailored to your needs. All available rentals and public transit options are integrated onto one convenient map.',
      name: 'introSecondScreenBody',
      desc: 'Text used on intro page as body for second screen.',
      args: [],
    );
  }

  /// `Unified Transport Services`
  String get introSecondAndHalfScreenHeader {
    return Intl.message(
      'Unified Transport Services',
      name: 'introSecondAndHalfScreenHeader',
      desc: 'Text used on intro page as header for second and half screen.',
      args: [],
    );
  }

  /// `Please note, Yggert Nu aggregates data from various transport apps, and rental bookings are made through the respective provider's app which will need to be installed on your device.`
  String get introSecondAndHalfScreenBody {
    return Intl.message(
      'Please note, Yggert Nu aggregates data from various transport apps, and rental bookings are made through the respective provider\'s app which will need to be installed on your device.',
      name: 'introSecondAndHalfScreenBody',
      desc: 'Text used on intro page as header for second and half screen.',
      args: [],
    );
  }

  /// `Always Be on Time`
  String get introThirdScreenHeader {
    return Intl.message(
      'Always Be on Time',
      name: 'introThirdScreenHeader',
      desc: 'Text used on intro page as header for third screen.',
      args: [],
    );
  }

  /// `Never miss a bus again. Check the local bus stops for upcoming schedules and arrivals when no immediate transportation is nearby.`
  String get introThirdScreenBody {
    return Intl.message(
      'Never miss a bus again. Check the local bus stops for upcoming schedules and arrivals when no immediate transportation is nearby.',
      name: 'introThirdScreenBody',
      desc: 'Text used on intro page as body for third screen.',
      args: [],
    );
  }

  /// `Customize to Your Liking`
  String get introFourthScreenHeader {
    return Intl.message(
      'Customize to Your Liking',
      name: 'introFourthScreenHeader',
      desc: 'Text used on intro page as header for fourth screen.',
      args: [],
    );
  }

  /// `Choose your preferred city, switch between light or dark theme, and select your language. Personalize your experience with our easily accessible settings.`
  String get introFourthScreenBody {
    return Intl.message(
      'Choose your preferred city, switch between light or dark theme, and select your language. Personalize your experience with our easily accessible settings.',
      name: 'introFourthScreenBody',
      desc: 'Text used on intro page as body for fourth screen.',
      args: [],
    );
  }

  /// `Save Your Preferences`
  String get introFifthScreenHeader {
    return Intl.message(
      'Save Your Preferences',
      name: 'introFifthScreenHeader',
      desc: 'Text used on intro page as header for fifth screen.',
      args: [],
    );
  }

  /// `Sign in using your Google account. Your preferences are saved to provide a consistent, personalized experience every time you use Yggert Nu.`
  String get introFifthScreenBody {
    return Intl.message(
      'Sign in using your Google account. Your preferences are saved to provide a consistent, personalized experience every time you use Yggert Nu.',
      name: 'introFifthScreenBody',
      desc: 'Text used on intro page as body for fifth screen.',
      args: [],
    );
  }

  /// `Ready for the Journey?`
  String get introSixthScreenHeader {
    return Intl.message(
      'Ready for the Journey?',
      name: 'introSixthScreenHeader',
      desc: 'Text used on intro page as header for sixth screen.',
      args: [],
    );
  }

  /// `Welcome to a smarter, more integrated world of transport. Start your journey with Yggert Nu now!`
  String get introSixthScreenBody {
    return Intl.message(
      'Welcome to a smarter, more integrated world of transport. Start your journey with Yggert Nu now!',
      name: 'introSixthScreenBody',
      desc: 'Text used on intro page as body for sixth screen.',
      args: [],
    );
  }

  /// `Done`
  String get doneButtonText {
    return Intl.message(
      'Done',
      name: 'doneButtonText',
      desc: 'Text used on the \'Done\' button on the final intro screen.',
      args: [],
    );
  }

  /// `Picked city`
  String get onboardingTitleTextCity {
    return Intl.message(
      'Picked city',
      name: 'onboardingTitleTextCity',
      desc: '',
      args: [],
    );
  }

  /// `City for which data is loaded`
  String get onboardingBodyTextCity {
    return Intl.message(
      'City for which data is loaded',
      name: 'onboardingBodyTextCity',
      desc: '',
      args: [],
    );
  }

  /// `Tap to customize map settings`
  String get onboardingBodyTextCustomize {
    return Intl.message(
      'Tap to customize map settings',
      name: 'onboardingBodyTextCustomize',
      desc: '',
      args: [],
    );
  }

  /// `Tap to refresh markers`
  String get onboardingBodyTextRefresh {
    return Intl.message(
      'Tap to refresh markers',
      name: 'onboardingBodyTextRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Use filters`
  String get onboardingTitleTextFilters {
    return Intl.message(
      'Use filters',
      name: 'onboardingTitleTextFilters',
      desc: '',
      args: [],
    );
  }

  /// `For example this button shows/hides scooters`
  String get onboardingBodyTextFiltersExample {
    return Intl.message(
      'For example this button shows/hides scooters',
      name: 'onboardingBodyTextFiltersExample',
      desc: '',
      args: [],
    );
  }

  /// `Good luck on the road!`
  String get onboardingTitleTextGoodLuck {
    return Intl.message(
      'Good luck on the road!',
      name: 'onboardingTitleTextGoodLuck',
      desc: '',
      args: [],
    );
  }

  /// `Show scooters with charge lower than 30%?`
  String get showScootersLowerCharge {
    return Intl.message(
      'Show scooters with charge lower than 30%?',
      name: 'showScootersLowerCharge',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yesButton {
    return Intl.message(
      'Yes',
      name: 'yesButton',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get noButton {
    return Intl.message(
      'No',
      name: 'noButton',
      desc: '',
      args: [],
    );
  }

  /// `Start tutorial again?`
  String get startTutorialAgain {
    return Intl.message(
      'Start tutorial again?',
      name: 'startTutorialAgain',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `User data downloaded successfully`
  String get userDataDownloadedSuccessfully {
    return Intl.message(
      'User data downloaded successfully',
      name: 'userDataDownloadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `User data uploaded successfully`
  String get userDataUploadedSuccessfully {
    return Intl.message(
      'User data uploaded successfully',
      name: 'userDataUploadedSuccessfully',
      desc: '',
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