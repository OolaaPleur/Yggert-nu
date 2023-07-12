import 'package:flutter/material.dart';

/// Widget, defines appropriate avatar for trip card.
class PickAppropriateCircleAvatar extends StatelessWidget {
  /// Constructor for [PickAppropriateCircleAvatar].
  const PickAppropriateCircleAvatar({required this.routeType, super.key});
  /// Type of transport used in route.
  final int routeType;

  @override
  Widget build(BuildContext context) {
    CircleAvatar pickAppropriateCircleAvatar(int routeType) {
      if (routeType == 0) {
        return CircleAvatar(
          child: Image.asset('assets/public_transport/tram.png'),
        );
      } else if (routeType == 2) {
        return CircleAvatar(
          child: Image.asset('assets/public_transport/train.png'),
        );
      } else if (routeType == 3) {
        return CircleAvatar(
          child: Image.asset('assets/public_transport/county_bus.png'),
        );
      } else if (routeType == 4) {
        return CircleAvatar(
          child: Image.asset('assets/public_transport/ferry.png'),
        );
      } else if (routeType == 800) {
        return CircleAvatar(
          child: Image.asset('assets/public_transport/trolleybus.png'),
        );
      }
      return CircleAvatar(
        child: Image.asset('assets/county_bus.png'),
      );
    }
    return pickAppropriateCircleAvatar(routeType);
  }
}
