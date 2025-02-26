
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yggert_nu/constants/constants.dart';

import '../../../theme/bloc/theme_bloc.dart';
import '../../../utils/record_type_generator.dart';
import '../../../utils/string_to_enum.dart';
import '../../map/bloc/map_bloc.dart';

/// Second page of intro.
PageViewModel introSecondPage (BuildContext context) {
  final recordTypes = RecordTypeGenerator().generate(context);
  return PageViewModel(
    decoration: context.select((ThemeBloc bloc) => bloc.isDarkMode == true)
        ? const PageDecoration()
        : PageDecoration(
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFfff8b7), AppStyleConstants.introBottomColor],
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
            'assets/intro/intro_city.png',
            scale: 6,
            semanticLabel: 'One bus and one tram',
          ),
        ),
        const SizedBox(
          height: AppStyleConstants.secondSizeBoxHeight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            AppLocalizations.of(context)!.introSecondScreenHeader,
            textScaler: const TextScaler.linear(AppStyleConstants.introBodyTextScale),
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
        const SizedBox(
          height: 40,
        ),
        DropdownButton<String>(
          key: const Key('intro_dropdown_button'),
          menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
          value: context.select((MapBloc bloc) => bloc.state.pickedCity.name),
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            // This is called when the user selects an item.
            context.read<MapBloc>().add(MapChangeCity(getMyEnumFromStr(newValue!)!));
          },
          items: recordTypes
              .map<DropdownMenuItem<String>>(
                (recordType) => DropdownMenuItem<String>(
              value: recordType.key,
              child: Text(recordType.value),
            ),
          )
              .toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.changeCity,
          textScaleFactor: AppStyleConstants.introBodyTextScale,
        ),
      ],
    ),
  );
}
