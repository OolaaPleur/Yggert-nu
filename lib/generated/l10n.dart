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

  /// `Tartu Mobility App`
  String get homeAppBarTitle {
    return Intl.message(
      'Tartu Mobility App',
      name: 'homeAppBarTitle',
      desc: 'Text shown in home appBar',
      args: [],
    );
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