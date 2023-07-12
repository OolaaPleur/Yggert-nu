import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../theme/bloc/theme_bloc.dart';
import '../../map/bloc/map_bloc.dart';
import 'dropdown_menu_item.dart';
/// Widget dropdown in Settings, changes filter for trips.
class ShowTripsForTodayDropdown extends StatelessWidget {
  /// Constructor for [ShowTripsForTodayDropdown].
  const ShowTripsForTodayDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (previous, current) {
        return previous.globalShowTripsForToday != current.globalShowTripsForToday;
      },
      builder: (context, state) {
        return Card(
          color: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled)
              ? null
              : const Color(0xFF66cda2),
          child: ExpansionTile(subtitle: Text(AppLocalizations.of(context)!.changeFilter),
            title:
                context.read<MapBloc>().state.globalShowTripsForToday == GlobalShowTripsForToday.all
                    ? Text(AppLocalizations.of(context)!.settingsGlobalFilterAll)
                    : Text(AppLocalizations.of(context)!.settingsGlobalFilterToday),
            children: <Widget>[
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      GlobalShowTripsForToday.all,
                      AppLocalizations.of(context)!.settingsGlobalFilterAll,
                    ),
                    onTap: () {
                      context.read<MapBloc>().add(
                            const MapChangeTimetableMode(
                              GlobalShowTripsForToday.all,
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
                      GlobalShowTripsForToday.today,
                      AppLocalizations.of(context)!.settingsGlobalFilterToday,
                    ),
                    onTap: () {
                      context.read<MapBloc>().add(
                            const MapChangeTimetableMode(
                              GlobalShowTripsForToday.today,
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
