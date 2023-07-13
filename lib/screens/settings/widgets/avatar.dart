import 'package:flutter/material.dart';

/// Defines how user avatar will look like.
class Avatar extends StatelessWidget {
/// Constructor for [Avatar].
  const Avatar({required this.imageProvider, super.key, this.radius = 80});
  /// Image, which should be in circle avatar.
  final ImageProvider imageProvider;
  /// Radius of circle.
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: radius,
        child: ClipOval(
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
            width: 2 * radius,
            height: 2 * radius,
          ),
        ),
      ),
    );
  }
}
