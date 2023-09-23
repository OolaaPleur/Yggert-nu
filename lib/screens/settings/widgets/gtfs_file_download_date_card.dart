import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../theme/bloc/theme_bloc.dart';
import '../gtfs_bloc/gtfs_bloc.dart';

/// Text widget in Settings, shows when/if GTFS info was loaded.
class GtfsFileDownloadDateCard extends StatelessWidget {
  /// Constructor for [GtfsFileDownloadDateCard].
  const GtfsFileDownloadDateCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.select((ThemeBloc bloc) => bloc.isDarkMode)
          ? null
          : Theme.of(context).secondaryHeaderColor,
      child: BlocProvider(
        create: (context) => GtfsBloc(),
        child: BlocBuilder<GtfsBloc, GtfsState>(
          builder: (context, state) {
            context.read<GtfsBloc>().add(
                  GetGtfsData(
                    localizedString: AppLocalizations.of(context)!.settingsGtfsFileWasDownloaded,
                  ),
                );
            if (state is GtfsNoData) {
              return ListTile(
                title: Text(
                  AppLocalizations.of(context)!.settingsNoGtfsFile,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            } else if (state is GtfsDataLoaded) {
              return ListTile(
                title: Text(
                  state.result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
