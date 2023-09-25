import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yggert_nu/constants/constants.dart';

import '../../../theme/bloc/theme_bloc.dart';
/// Sixth page of intro.
PageViewModel introSixthPage(BuildContext context) {
  return PageViewModel(
    decoration: context.select((ThemeBloc bloc) => bloc.isDarkMode == true)
        ? const PageDecoration()
        : PageDecoration(
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFfff06a), AppStyleConstants.introBottomColor],
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
            'assets/intro/intro_google_sign_in.png',
            semanticLabel: 'G letter (Google logo)',
            scale: 6,
          ),
        ),
        const SizedBox(
          height: AppStyleConstants.secondSizeBoxHeight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            AppLocalizations.of(context)!.introFifthScreenHeader,
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
            AppLocalizations.of(context)!.introFifthScreenBody,
            textScaleFactor: AppStyleConstants.introBodyTextScale,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );}
