import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/constants.dart';
import '../../../../l10n/app_localizations.dart';
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
      backgroundColor: context.read<ThemeBloc>().isDarkMode
          ? null
          : AppStyleConstants.scaffoldColor,
      appBar: AppBar(
        backgroundColor: context.read<ThemeBloc>().isDarkMode
            ? null
            : AppStyleConstants.appBarColor,
        title: Text(AppLocalizations.of(context)!.selectCity),
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
                  context.read<MapBloc>().add(const MapMarkersPlacingOnMap());
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
