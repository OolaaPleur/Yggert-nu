import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yggert_nu/utils/build_context_ext.dart';

import '../../../exceptions/exceptions.dart';
import '../../../theme/bloc/theme_bloc.dart';

/// Widget, defines rate app list tile, leads to app page on Google Play.
class RateAppTile extends StatelessWidget {
  /// Constructor for [RateAppTile].
  const RateAppTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.select((ThemeBloc bloc) => bloc.isDarkMode)
          ? null
          : Theme.of(context).secondaryHeaderColor,
      child: ListTile(
        leading: const Icon(Icons.star),
        title: Text(context.localizations.rateUsOnGooglePlay),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(context.localizations.yourFeedbackMotivatesMeToMakeTheAppEvenBetter),
        splashColor: Colors.transparent,
        onTap: () {
          _launchURL(context);
        },
      ),
    );
  }

  Future<void> _launchURL(BuildContext context) async {
    const packageName = 'com.oolaa.yggert.nu';
    const url = 'https://play.google.com/store/apps/details?id=$packageName';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw const CouldNotLaunch();
    }
  }
}
