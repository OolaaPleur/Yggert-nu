import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../theme/bloc/theme_bloc.dart';
import '../../../map/bloc/map_bloc.dart';

/// Page, where city could be selected by user.
class CitySelectionPage extends StatelessWidget {
/// Constructor for [CitySelectionPage].
  const CitySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCity = context.read<MapBloc>().state.pickedCity;
    return Scaffold(
      backgroundColor: context.read<ThemeBloc>().isDarkModeEnabled
          ? null
          : AppStyleConstants.scaffoldColor,
      appBar: AppBar(
        backgroundColor: context.read<ThemeBloc>().isDarkModeEnabled
            ? null
            : AppStyleConstants.appBarColor,
        title: const Text('Select city'),
      ),
      body: ListView(
        children: cityToLocalKey.keys.map((city) {
          return Column(
            children: [
              ListTile(
                leading: const Text('🇪🇪', textScaleFactor: 2,),
                title: Text(cityToLocalKey[city]!(AppLocalizations.of(context)!), textScaleFactor: 1.2,),
                onTap: () {
                  context.read<MapBloc>().add(MapChangeCity(city));
                  Navigator.pop(context);
                },
                trailing: city == currentCity
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
