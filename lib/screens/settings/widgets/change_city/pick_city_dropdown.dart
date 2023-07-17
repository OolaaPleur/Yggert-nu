import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../theme/bloc/theme_bloc.dart';
import '../../../map/bloc/map_bloc.dart';
import 'city_selection_page.dart';

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
        final pickedCity = context.read<MapBloc>().state.pickedCity;
        final cityName = cityToLocalKey[pickedCity]!(AppLocalizations.of(context)!);
        return Card(
          color: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled)
              ? null
              : Theme.of(context).secondaryHeaderColor,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => const CitySelectionPage()),
              );
            },
            title: Text(cityName),
            subtitle: Text(AppLocalizations.of(context)!.changeCity),
            leading: const Icon(Icons.location_city),
            trailing: const Icon(Icons.keyboard_arrow_right),
            splashColor: Colors.transparent,
          ),
        );
      },
    );
  }
}
