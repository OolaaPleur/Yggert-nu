import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../map/bloc/map_bloc.dart';

/// Defines app bar title in home screen.
class AppBarTitle extends StatelessWidget {
  /// Constructor for [AppBarTitle].
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
       key: const Key('app_bar_title'),
      builder: (context, state) {
        final pickedCity = context.read<MapBloc>().state.pickedCity;
        final cityName = cityToLocalKey[pickedCity]!(AppLocalizations.of(context)!);
        return Text(
          cityName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        );
      },
    );
  }
}
