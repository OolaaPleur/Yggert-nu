import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/constants.dart';
import '../exceptions/exceptions.dart';

/// Class, defines how snackbar look like in app.
class AppSnackBar {
  /// Constructor for [AppSnackBar].
  AppSnackBar(this.context, {this.exception, this.infoMessage});

  /// Context for localizations and snackbar showing.
  late final BuildContext context;

  /// Exception, for which snackbar is displayed.
  late final AppException? exception;

  /// Control flow text, for which snackbar is displayed.
  late final InfoMessage? infoMessage;

  /// Function, takes [exception] as argument and returns appropriate
  /// error text.
  List<InlineSpan>? _errorText(AppException? exception) {
    switch (exception.runtimeType) {
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
      case CantFetchTuulScootersData:
        {
          final words = AppLocalizations.of(context)!.snackbarCantFetchTuulScootersData;
          const highlightedWords = 'Tuul';
          final messageSpans = words.split(' ').map((word) {
            return highlightedWords.contains(word)
                ? TextSpan(
              text: '$word ',
              style:
              const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
            )
                : TextSpan(text: '$word ');
          }).toList();
          return messageSpans;
        }
      case CantFetchHoogScootersData:
        {
          final words = AppLocalizations.of(context)!.snackbarCantFetchHoogScootersData;
          const highlightedWords = 'Hoog';
          final messageSpans = words.split(' ').map((word) {
            return highlightedWords.contains(word)
                ? TextSpan(
              text: '$word ',
              style:
              TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.bold),
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
      case NoGtfsTextFileIsPresent:
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarNoGtfsFileIsPresent)];
      case SomeErrorOccurred:
        return [TextSpan(text: AppLocalizations.of(context)!.someErrorOccurred)];
      case NoInternetConnectionInSettings:
        return [TextSpan(text: AppLocalizations.of(context)!.snackbarNoInternetConnectionInSettings)];
    }
    return null;
  }

  List<InlineSpan>? _whichTextToShow() {
    if (exception == null) {
      switch (infoMessage) {
        case InfoMessage.noNeedToDownload:
          return [TextSpan(text: AppLocalizations.of(context)!.snackbarNoNeedToDownload)];

        case InfoMessage.geolocationPermissionDenied:
          return [TextSpan(text: AppLocalizations.of(context)!.geolocationPermissionDenied)];
        case InfoMessage.userDataUploadedSuccessfully:
          return [TextSpan(text: AppLocalizations.of(context)!.userDataUploadedSuccessfully)];
        case InfoMessage.userDataDownloadedSuccessfully:
          return [TextSpan(text: AppLocalizations.of(context)!.userDataDownloadedSuccessfully)];
        // ignore: no_default_cases
        default:
          return null;
      }
    } else if (infoMessage == null) {
      return _errorText(exception);
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
                  children: _whichTextToShow(),
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
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: const StadiumBorder(),
      width: MediaQuery.of(context).size.width * 0.9,
      dismissDirection: DismissDirection.none,
    );
  }
}
