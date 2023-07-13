import 'package:flutter/material.dart';

import '../auth_bloc/auth_bloc.dart';
import 'avatar.dart';

/// Defines User circle avatar.
class UserAvatar extends StatefulWidget {
/// Constructor for [UserAvatar].
  const UserAvatar({required this.authState, super.key});
  /// [AuthState] BLoC, needed here to acquire user photo.
  final AuthState authState;

  @override
  UserAvatarState createState() => UserAvatarState();
}
/// User widget class.
class UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 900),
      firstChild: widget.authState.userCredential?.user?.photoURL != null
          ? Avatar(
        imageProvider: NetworkImage(widget.authState.userCredential!.user!.photoURL!),
      )
          : const Avatar(
        imageProvider: AssetImage('assets/default_avatar.jpg'),
      ),
      secondChild: const Avatar(
        imageProvider: AssetImage('assets/default_avatar.jpg'),
      ),
      crossFadeState: widget.authState.userCredential?.user?.photoURL != null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}
