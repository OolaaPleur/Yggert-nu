import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../map/bloc/map_bloc.dart';
import 'onboarding_widget.dart';

/// Defines refresh icon for home screen.
class RefreshIcon extends StatelessWidget {
  /// Constructor for [RefreshIcon].
  const RefreshIcon({super.key});

  /// Defines refresh icon behaviour.
  Widget refreshIcon(BuildContext context) {
    const Widget icon = SizedBox(
      width: 24,
      height: 24,
      child: Icon(Icons.refresh_sharp),
    );

    const Widget spinner = SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Colors.blue,
        strokeWidth: 2,
      ),
    );

    if (context.select((MapBloc bloc) => bloc.state.tripStatus == TripStatus.loading) ||
        context.select((MapBloc bloc) => bloc.state.status == MapStateStatus.loading) ||
        context.select((MapBloc bloc) => bloc.state.filteringStatus == true)) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: icon,
        secondChild: spinner,
        crossFadeState: CrossFadeState.showSecond,
        layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Positioned(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
        },
      );
    } else {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: icon,
        secondChild: spinner,
        crossFadeState: CrossFadeState.showFirst,
        layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Positioned(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('refresh_icon_button'),
      focusNode: refreshIconFocusNode,
      tooltip: AppLocalizations.of(context)!.homeAppBarRefreshIcon,
      onPressed: () {
        context.read<MapBloc>().add(const MapMarkersPlacingOnMap());
      },
      icon: refreshIcon(context),
    );
  }
}
