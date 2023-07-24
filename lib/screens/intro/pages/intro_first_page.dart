import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobility_app/utils/build_context_ext.dart';

import '../../../constants/constants.dart';
import '../../../theme/bloc/theme_bloc.dart';

/// First page of intro.
PageViewModel introFirstPage (BuildContext context) {
  return PageViewModel(
    decoration: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled == true)
        ? const PageDecoration()
        : PageDecoration(
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppStyleConstants.introFirstPageTopColor, AppStyleConstants.introBottomColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
    titleWidget: Column(
      children: [
        const SizedBox(
          height: AppStyleConstants.firstSizeBoxHeight,
        ),
        ClipOval(
          child: Image.asset(
            'assets/launcher_icon/launcher_icon.png',
            scale: 6,
          ),
        ),
        const SizedBox(
          height: AppStyleConstants.secondSizeBoxHeight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            context.localizations.introFirstScreenHeader,
            textScaleFactor: AppStyleConstants.introTitleTextScale,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    bodyWidget: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.introFirstScreenBody,
            textScaleFactor: AppStyleConstants.introBodyTextScale,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
