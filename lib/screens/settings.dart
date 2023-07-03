import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobility_app/map/view/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../map/bloc/map_bloc.dart';
import '../theme/bloc/theme_bloc.dart';
import 'language_cubit/language_cubit.dart';

/// [Settings] is widget, which is accessed through actions in appbar on
/// [MapScreen]. There user can change global settings of the app.
class Settings extends StatefulWidget {
  /// Default constructor for [Settings] widget.
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _data = '';

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('gtfs_download_date') != null) {
        _data = prefs.getString('gtfs_download_date')!;
        _data =
            '${AppLocalizations.of(context)!.settingsGtfsFileWasDownloaded} ${_data.substring(0, _data.length - 4)}';
      } else {
        _data = AppLocalizations.of(context)!.settingsNoGtfsFile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var filter = context.read<MapBloc>().state.globalShowTripsForToday;
    var city = context.read<MapBloc>().state.pickedCity;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsAppBarTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: SegmentedButton<GlobalShowTripsForToday>(
                  segments: <ButtonSegment<GlobalShowTripsForToday>>[
                    ButtonSegment<GlobalShowTripsForToday>(
                      value: GlobalShowTripsForToday.all,
                      label: Text(AppLocalizations.of(context)!.settingsGlobalFilterAll),
                    ),
                    ButtonSegment<GlobalShowTripsForToday>(
                      value: GlobalShowTripsForToday.today,
                      label: Text(AppLocalizations.of(context)!.settingsGlobalFilterToday),
                    ),
                  ],
                  selected: <GlobalShowTripsForToday>{filter},
                  onSelectionChanged: (Set<GlobalShowTripsForToday> newSelection) {
                    setState(() {
                      filter = newSelection.first;
                      context.read<MapBloc>().add(MapChangeTimetableMode(filter));
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: SegmentedButton<City>(
                  segments: <ButtonSegment<City>>[
                    ButtonSegment<City>(
                      value: City.tartu,
                      label: Text(AppLocalizations.of(context)!.settingsTartu),
                    ),
                    ButtonSegment<City>(
                      value: City.tallinn,
                      label: Text(AppLocalizations.of(context)!.settingsTallinn),
                    ),
                  ],
                  selected: <City>{city},
                  onSelectionChanged: (Set<City> newSelection) {
                    setState(() {
                      city = newSelection.first;
                      context.read<MapBloc>().add(MapChangeCity(city));
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ElevatedButton.icon(
              label: Text(AppLocalizations.of(context)!.settingsChangeTheme),
              onPressed: () {
                BlocProvider.of<ThemeBloc>(context).toggleTheme();
              },
              icon: const Icon(Icons.brightness_6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(_data),
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<LanguageCubit>(context).changeLanguage(const Locale('ru', ''));
            },
            child: const Text('ru'),
          ),
          ElevatedButton(onPressed: () {
            BlocProvider.of<LanguageCubit>(context).changeLanguage(const Locale('en', ''));
          }, child: const Text('en'),),
        ],
      ),
    );
  }
}
