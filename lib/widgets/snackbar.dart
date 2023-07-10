import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../exceptions/exceptions.dart';

/// Class, defines how snackbar look like in app.
class AppSnackBar {
  /// Constructor for [AppSnackBar].
  AppSnackBar(this.context, this.exception);

  /// Context for localizations and snackbar showing.
  late final BuildContext context;
  /// Exception, for which snackbar is displayed.
  late final AppException exception;

  /// Function, takes [exception] as argument and returns appropriate
  /// error text.
  List<InlineSpan>? errorText(AppException exception) {
    switch (exception.runtimeType) {
      case NoNeedToDownload:
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarNoNeedToDownload)];
      case CantFetchBoltScootersData:
        {
          final words = AppLocalizations.of(context)!.snackbarCantFetchBoltScootersData;
          const highlightedWords = 'Bolt';
          final messageSpans = words.split(' ').map((word) {
            return highlightedWords.contains(word)
                ? TextSpan(
              text: '$word ',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            )
                : TextSpan(text: '$word ');
          }).toList();
          return messageSpans;
        }
      case CantFetchTartuSmartBikeData:
        {
          final words = AppLocalizations.of(context)!.snackbarCantFetchTartuSmartBikeData;
          const highlightedWords = 'Tartu Smart';
          final messageSpans = words.split(' ').map((word) {
            return highlightedWords.contains(word)
                ? TextSpan(
              text: '$word ',
              style:
              const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
            )
                : TextSpan(text: '$word ');
          }).toList();
          return messageSpans;
        }
      case NoInternetConnection:
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarNoInternetConnection)];
      case DeviceIsNotSupported:
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarDeviceIsNotSupported)];
      case CityIsNotPicked:
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarCityIsNotPicked)];
      case NoGtfsFileIsPresent:
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarNoGtfsFileIsPresent)];
      case SomeErrorOccurred:
        return [TextSpan(text: AppLocalizations.of(context)!.someErrorOccurred)];
    }
    return null;
  }

  /// Returns snackbar.
  SnackBar showSnackBar() {
    return SnackBar(
      duration: const Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: errorText(exception),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          )
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: const StadiumBorder(),
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      dismissDirection: DismissDirection.none,
    );
  }
}
