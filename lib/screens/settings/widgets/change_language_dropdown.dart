import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../theme/bloc/theme_bloc.dart';
import '../language_cubit/language_cubit.dart';
import 'dropdown_menu_item.dart';

/// Widget dropdown in Settings, changes language.
class ChangeLanguageDropdown extends StatelessWidget {
  /// Constructor for [ChangeLanguageDropdown].
  const ChangeLanguageDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Text changeTitle(BuildContext context) {
      if (context.read<LanguageCubit>().state.languageCode == 'en') {
        return Text(AppLocalizations.of(context)!.settingsLanguageEnglish);
      } else if (context.read<LanguageCubit>().state.languageCode == 'ru') {
        return Text(AppLocalizations.of(context)!.settingsLanguageRussian);
      } else {
        return Text(AppLocalizations.of(context)!.settingsLanguageEstonian);
      }
    }

    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, state) {
        return Card(
          color: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled)
              ? null
              : Theme.of(context).secondaryHeaderColor,
          child: ExpansionTile(
            leading: const Icon(Icons.language),
            subtitle: Text(AppLocalizations.of(context)!.changeLanguage),
            title: changeTitle(context),
            children: <Widget>[
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      'en',
                      AppLocalizations.of(context)!.settingsLanguageEnglish,
                    ),
                    onTap: () {
                      ExpansionTileController.maybeOf(context)!.collapse();
                      context.read<LanguageCubit>().changeLanguage(const Locale('en'));
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      'et',
                      AppLocalizations.of(context)!.settingsLanguageEstonian,
                    ),
                    onTap: () {
                      context.read<LanguageCubit>().changeLanguage(const Locale('et'));
                      ExpansionTileController.maybeOf(context)!.collapse();
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    title: generateDropdownMenuItem(
                      'ru',
                      AppLocalizations.of(context)!.settingsLanguageRussian,
                    ),
                    onTap: () {
                      context.read<LanguageCubit>().changeLanguage(const Locale('ru'));
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
