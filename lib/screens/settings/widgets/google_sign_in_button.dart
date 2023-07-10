// import 'package:auth_buttons/auth_buttons.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../theme/bloc/theme_bloc.dart';
// import '../../../theme/bloc/theme_state.dart';
//
// class GoogleSignInButton extends StatelessWidget {
//   const GoogleSignInButton({super.key, required this.user});
//   final User user;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Align(
//             child: user != null
//                 ? Padding(
//               padding: const EdgeInsets.only(bottom: 18.0),
//               child: Text(
//                 user!.displayName!,
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             )
//                 : GoogleAuthButton(
//               onPressed: signInWithGoogle,
//               style: const AuthButtonStyle(textStyle: TextStyle()),
//               darkMode: context.read<ThemeBloc>().isDarkModeEnabled,
//             ),
//           ),
//         );
//       },
//     )
//   }
// }
