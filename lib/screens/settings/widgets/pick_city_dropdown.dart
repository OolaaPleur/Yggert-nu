import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/bloc/theme_bloc.dart';
import '../../map/bloc/map_bloc.dart';
import 'dropdown_menu_item.dart';

/// Widget dropdown in Settings, changes city.
class PickCityDropdown extends StatelessWidget {
  /// Constructor for [PickCityDropdown].
  const PickCityDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (previous, current) {
        return previous.pickedCity != current.pickedCity;
      },
      builder: (context, state) {
        return Card(
          color: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled)
              ? null
              : const Color(0xFF66cda2),
          child: ExpansionTile(
            title: context.read<MapBloc>().state.pickedCity == City.tartu
                ? Text(
                    AppLocalizations.of(context)!.settingsTartu,
                    style: const TextStyle(fontSize: 18),
                  )
                : Text(AppLocalizations.of(context)!.settingsTallinn),
            subtitle: Text(AppLocalizations.of(context)!.changeCity),
            leading: const Icon(Icons.location_city),
            children: <Widget>[
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      City.tartu,
                      AppLocalizations.of(context)!.settingsTartu,
                    ),
                    onTap: () {
                      context.read<MapBloc>().add(const MapChangeCity(City.tartu));
                      ExpansionTileController.maybeOf(context)!.collapse();
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      City.tallinn,
                      AppLocalizations.of(context)!.settingsTallinn,
                    ),
                    onTap: () {
                      context.read<MapBloc>().add(const MapChangeCity(City.tallinn));
                      ExpansionTileController.maybeOf(context)!.collapse();
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
