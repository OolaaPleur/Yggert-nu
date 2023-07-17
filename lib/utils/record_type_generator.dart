import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/constants.dart';

/// Class, contains function which generate localized dropdowns for intro screen.
class RecordTypeGenerator {
  /// Function, generates localized dropdowns.
  List<LocalizedCityName> generate(BuildContext context) {
    final result = <LocalizedCityName>[];

    cityToLocalKey.forEach((city, localKey) {
      result.add(
        LocalizedCityName(
          key: city.name,
          value: localKey(AppLocalizations.of(context)!),
        ),
      );
    });

    return result;
  }
}

/// Object for localized city, key is City enum String, value is localized
/// city name String.
class LocalizedCityName extends Equatable {
  /// Constructor for [LocalizedCityName].
  const LocalizedCityName({required this.key, required this.value});

  /// Key is City enum String.
  final String key;

  /// Value is localized city name String.
  final String value;

  @override
  List<Object> get props => [key, value];
}
