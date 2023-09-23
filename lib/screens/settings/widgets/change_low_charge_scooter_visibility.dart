import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/bloc/theme_bloc.dart';
import '../../map/bloc/map_bloc.dart';
import 'dropdown_menu_item.dart';

/// Widget in settings, responsible for showing scooters
/// with low charge.
class ChangeLowChargeScooterVisibility extends StatelessWidget {
  /// Constructor for [ChangeLowChargeScooterVisibility].
  const ChangeLowChargeScooterVisibility({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (previous, current) {
        return previous.lowChargeScooterVisibility != current.lowChargeScooterVisibility;
      },
      builder: (context, state) {
        return Card(
          color: context.select((ThemeBloc bloc) => bloc.isDarkMode)
              ? null
              : Theme.of(context).secondaryHeaderColor,
          child: ExpansionTile(
            subtitle: Text(
                AppLocalizations.of(context)!.showScootersLowerCharge,),
            title: context.read<MapBloc>().state.lowChargeScooterVisibility == true
                ? Text(AppLocalizations.of(context)!.yesButton)
                : Text(AppLocalizations.of(context)!.noButton),
            children: <Widget>[
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      true,
                      AppLocalizations.of(context)!.yesButton,
                    ),
                    onTap: () {
                      context.read<MapBloc>().add(
                            const MapChangeLowChargeScooterVisibility(
                              visibility: true,
                            ),
                          );
                      ExpansionTileController.maybeOf(context)!.collapse();
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      false,
                      AppLocalizations.of(context)!.noButton,
                    ),
                    onTap: () {
                      context.read<MapBloc>().add(
                            const MapChangeLowChargeScooterVisibility(
                              visibility: false,
                            ),
                          );
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
