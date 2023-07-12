// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static m0(charge) => "Заряд батареи: ${charge}%";

  static m1(app) => "Перейти в ${app}";

  static m2(price) => "Стоимость: ${price}";

  static m3(count) => "Велосипедов: ${count}";

  static m4(count) => "Электрических: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "changeCity" : MessageLookupByLibrary.simpleMessage("Выбери город"),
    "changeFilter" : MessageLookupByLibrary.simpleMessage("Выбери фильтр"),
    "changeLanguage" : MessageLookupByLibrary.simpleMessage("Выбери язык"),
    "fri" : MessageLookupByLibrary.simpleMessage("Пт"),
    "geolocationPermissionDenied" : MessageLookupByLibrary.simpleMessage("Нет разрешения на геолокацию, вы не можете увидеть свое местоположение."),
    "homeAppBarRefreshIcon" : MessageLookupByLibrary.simpleMessage("Обновить"),
    "homeAppBarSettingsIcon" : MessageLookupByLibrary.simpleMessage("Настройки"),
    "homeBikeFAB" : MessageLookupByLibrary.simpleMessage("Фильтр велосипедов"),
    "homeScooterFAB" : MessageLookupByLibrary.simpleMessage("Фильтр самокатов"),
    "homeStopFAB" : MessageLookupByLibrary.simpleMessage("Фильтр остановок"),
    "mapScreenGpsFAB" : MessageLookupByLibrary.simpleMessage("Получить геолокацию"),
    "microMobilityCouldNotLoad" : MessageLookupByLibrary.simpleMessage("Не получилось загрузить нужную информацию."),
    "modalBottomSheetScooterCharge" : m0,
    "modalBottomSheetScooterGoToApp" : m1,
    "modalBottomSheetScooterPrice" : m2,
    "modalBottomSheetTartuBikesBikeCount" : m3,
    "modalBottomSheetTartuBikesPedelecCount" : m4,
    "mon" : MessageLookupByLibrary.simpleMessage("Пн"),
    "sat" : MessageLookupByLibrary.simpleMessage("Сб"),
    "settingsAppBarTitle" : MessageLookupByLibrary.simpleMessage("Настройки"),
    "settingsChangeTheme" : MessageLookupByLibrary.simpleMessage("Сменить тему"),
    "settingsGlobalFilterAll" : MessageLookupByLibrary.simpleMessage("Показать все"),
    "settingsGlobalFilterToday" : MessageLookupByLibrary.simpleMessage("Показать на сегодня"),
    "settingsGtfsFileWasDownloaded" : MessageLookupByLibrary.simpleMessage("Файл GTFS был загружен"),
    "settingsLanguageEnglish" : MessageLookupByLibrary.simpleMessage("Английский"),
    "settingsLanguageEstonian" : MessageLookupByLibrary.simpleMessage("Эстонский"),
    "settingsLanguageRussian" : MessageLookupByLibrary.simpleMessage("Русский"),
    "settingsLocalFilterAll" : MessageLookupByLibrary.simpleMessage("Все"),
    "settingsLocalFilterToday" : MessageLookupByLibrary.simpleMessage("Сегодня"),
    "settingsNoGtfsFile" : MessageLookupByLibrary.simpleMessage("GTFS файлы не найдены"),
    "settingsTallinn" : MessageLookupByLibrary.simpleMessage("Таллинн"),
    "settingsTartu" : MessageLookupByLibrary.simpleMessage("Тарту"),
    "signInWithGoogle" : MessageLookupByLibrary.simpleMessage("Войти через Google"),
    "snackbarCantFetchBoltScootersData" : MessageLookupByLibrary.simpleMessage("Ошибка сервера. Невозможно загрузить данные о Bolt самокатах."),
    "snackbarCantFetchTartuSmartBikeData" : MessageLookupByLibrary.simpleMessage("Ошибка сервера. Невозможно загрузить данные о велосипедах Tartu Smart bike."),
    "snackbarCityIsNotPicked" : MessageLookupByLibrary.simpleMessage("Город не выбран"),
    "snackbarDeviceIsNotSupported" : MessageLookupByLibrary.simpleMessage("Устройство не поддерживается."),
    "snackbarNoGtfsFileIsPresent" : MessageLookupByLibrary.simpleMessage("GTFS файлов нет, нажмите кнопку обновить для загрузки."),
    "snackbarNoInternetConnection" : MessageLookupByLibrary.simpleMessage("Нет интернет-соединения. Пожалуйста проверьте его и попробуйте снова."),
    "snackbarNoNeedToDownload" : MessageLookupByLibrary.simpleMessage("У вас самые свежие GTFS данные."),
    "someErrorOccurred" : MessageLookupByLibrary.simpleMessage("Произошла неизвестная ошибка. Попробуйте снова позже."),
    "stopMarkerShowAllForwardStoptimesButton" : MessageLookupByLibrary.simpleMessage("Показать остановки"),
    "stopSearchHintText" : MessageLookupByLibrary.simpleMessage("Введите название остановки."),
    "sun" : MessageLookupByLibrary.simpleMessage("Вс"),
    "thu" : MessageLookupByLibrary.simpleMessage("Чт"),
    "tue" : MessageLookupByLibrary.simpleMessage("Вт"),
    "wed" : MessageLookupByLibrary.simpleMessage("Ср")
  };
}
