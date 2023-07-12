// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(charge) => "Battery Charge: ${charge}%";

  static m1(app) => "Go to ${app} app";

  static m2(price) => "Price: ${price}";

  static m3(count) => "Bikes: ${count}";

  static m4(count) => "Pedelec Bikes: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "changeCity" : MessageLookupByLibrary.simpleMessage("Pick a city"),
    "changeFilter" : MessageLookupByLibrary.simpleMessage("Change filter"),
    "changeLanguage" : MessageLookupByLibrary.simpleMessage("Change language"),
    "fri" : MessageLookupByLibrary.simpleMessage("Fri"),
    "geolocationPermissionDenied" : MessageLookupByLibrary.simpleMessage("Permission denied, you cannot see your location on map."),
    "homeAppBarRefreshIcon" : MessageLookupByLibrary.simpleMessage("Refresh"),
    "homeAppBarSettingsIcon" : MessageLookupByLibrary.simpleMessage("Settings"),
    "homeBikeFAB" : MessageLookupByLibrary.simpleMessage("Bike filter"),
    "homeScooterFAB" : MessageLookupByLibrary.simpleMessage("Scooters filter"),
    "homeStopFAB" : MessageLookupByLibrary.simpleMessage("Stop filter"),
    "mapScreenGpsFAB" : MessageLookupByLibrary.simpleMessage("Get geolocation"),
    "microMobilityCouldNotLoad" : MessageLookupByLibrary.simpleMessage("Could not load required info."),
    "modalBottomSheetScooterCharge" : m0,
    "modalBottomSheetScooterGoToApp" : m1,
    "modalBottomSheetScooterPrice" : m2,
    "modalBottomSheetTartuBikesBikeCount" : m3,
    "modalBottomSheetTartuBikesPedelecCount" : m4,
    "mon" : MessageLookupByLibrary.simpleMessage("Mon"),
    "sat" : MessageLookupByLibrary.simpleMessage("Sat"),
    "settingsAppBarTitle" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsChangeTheme" : MessageLookupByLibrary.simpleMessage("Change theme"),
    "settingsGlobalFilterAll" : MessageLookupByLibrary.simpleMessage("Show all"),
    "settingsGlobalFilterToday" : MessageLookupByLibrary.simpleMessage("Show for today"),
    "settingsGtfsFileWasDownloaded" : MessageLookupByLibrary.simpleMessage("GTFS file was downloaded "),
    "settingsLanguageEnglish" : MessageLookupByLibrary.simpleMessage("English"),
    "settingsLanguageEstonian" : MessageLookupByLibrary.simpleMessage("Estonian"),
    "settingsLanguageRussian" : MessageLookupByLibrary.simpleMessage("Russian"),
    "settingsLocalFilterAll" : MessageLookupByLibrary.simpleMessage("All"),
    "settingsLocalFilterToday" : MessageLookupByLibrary.simpleMessage("Today"),
    "settingsNoGtfsFile" : MessageLookupByLibrary.simpleMessage("No GTFS file"),
    "settingsTallinn" : MessageLookupByLibrary.simpleMessage("Tallinn"),
    "settingsTartu" : MessageLookupByLibrary.simpleMessage("Tartu"),
    "signInWithGoogle" : MessageLookupByLibrary.simpleMessage("Sign in with Google"),
    "snackbarCantFetchBoltScootersData" : MessageLookupByLibrary.simpleMessage("Server error. Cant fetch Bolt scooters data."),
    "snackbarCantFetchTartuSmartBikeData" : MessageLookupByLibrary.simpleMessage("Server error. Cant fetch Tartu Smart bike data."),
    "snackbarCityIsNotPicked" : MessageLookupByLibrary.simpleMessage("No city was picked."),
    "snackbarDeviceIsNotSupported" : MessageLookupByLibrary.simpleMessage("Device is not supported."),
    "snackbarNoGtfsFileIsPresent" : MessageLookupByLibrary.simpleMessage("No file is present, press refresh button to download."),
    "snackbarNoInternetConnection" : MessageLookupByLibrary.simpleMessage("No Internet connection. Please check your connection and try again."),
    "snackbarNoNeedToDownload" : MessageLookupByLibrary.simpleMessage("You have the latest GTFS data."),
    "someErrorOccurred" : MessageLookupByLibrary.simpleMessage("Some error occurred. Please try again later."),
    "stopMarkerShowAllForwardStoptimesButton" : MessageLookupByLibrary.simpleMessage("Press to see stoptimes"),
    "stopSearchHintText" : MessageLookupByLibrary.simpleMessage("Enter stop name."),
    "sun" : MessageLookupByLibrary.simpleMessage("Sun"),
    "thu" : MessageLookupByLibrary.simpleMessage("Thu"),
    "tue" : MessageLookupByLibrary.simpleMessage("Tue"),
    "wed" : MessageLookupByLibrary.simpleMessage("Wed")
  };
}
