import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yggert_nu/utils/build_context_ext.dart';

import '../../../theme/bloc/theme_bloc.dart';

/// Widget, shows name and version of the app.
class AppInfoText extends StatelessWidget {
  /// Constructor for [AppInfoText].
  const AppInfoText({super.key});

  /// Gets app name and app version.
  Future<String> appInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName;
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    return '$appName: $version+$buildNumber';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: appInfo(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Card(
              color: context.select((ThemeBloc bloc) => bloc.isDarkMode)
                  ? null
                  : Theme.of(context).secondaryHeaderColor,
              child: ListTile(
                title: Text(
                  '${context.localizations.error} ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          }
          return Card(
            color: context.select((ThemeBloc bloc) => bloc.isDarkMode)
                ? null
                : Theme.of(context).secondaryHeaderColor,
            child: ListTile(
              title: Text(
                snapshot.data!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ); // Display the version info
        } else {
          return const CircularProgressIndicator(); // Show a loader until the data is loaded
        }
      },
    );
  }
}
