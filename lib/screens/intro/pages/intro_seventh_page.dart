import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yggert_nu/constants/constants.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/bloc/theme_bloc.dart';
/// Seventh page of intro.
PageViewModel introSeventhPage(BuildContext context) {
  return PageViewModel(
    decoration: context.select((ThemeBloc bloc) => bloc.isDarkMode == true)
        ? const PageDecoration()
        : PageDecoration(
            boxDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFffed51), AppStyleConstants.introBottomColor],
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
            'assets/intro/intro_end.png',
            semanticLabel: 'Road going forward into horizon',
            scale: 6,
          ),
        ),
        const SizedBox(
          height: AppStyleConstants.secondSizeBoxHeight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            AppLocalizations.of(context)!.introSixthScreenHeader,
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
            AppLocalizations.of(context)!.introSecondScreenBody,
            textScaleFactor: AppStyleConstants.introBodyTextScale,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
