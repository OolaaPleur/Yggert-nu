import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../theme/bloc/theme_bloc.dart';
import '../../../theme/bloc/theme_event.dart';

/// Widget dropdown in Settings, changes theme of an app.
class DarkModeSwitch extends StatelessWidget {
  /// Constructor for [DarkModeSwitch].
  const DarkModeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled)
          ? null
          : Theme.of(context).secondaryHeaderColor,
      child: SwitchListTile(
        key: const Key('dark_mode_switcher'),
        title: Row(
          children: [
            const Icon(Icons.brightness_6),
            const SizedBox(
              width: 10,
            ),
            Text(
              AppLocalizations.of(context)!.settingsChangeTheme,
            ),
          ],
        ),
        value: context.read<ThemeBloc>().isDarkModeEnabled,
        onChanged: (bool value) {
          context.read<ThemeBloc>().add(ToggleThemeEvent());
        },
      ),
    );
  }
}
