import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/bloc/theme_bloc.dart';
import '../auth_bloc/auth_bloc.dart';
/// Widget in Settings, defines button, clicking which gives opportunity
/// to log in with Google.
class GoogleSignInButton extends StatelessWidget {
  /// Constructor for [GoogleSignInButton].
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            child: context.select((AuthBloc authBloc) => authBloc.state.userCredential?.user) != null
                ? Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                context.select((AuthBloc authBloc) => authBloc.state.userCredential!.user!.displayName)!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
                : GoogleAuthButton(
              text: AppLocalizations.of(context)!.signInWithGoogle,
              onPressed: () {
                context.read<AuthBloc>().add(SignInWithGoogleEvent());
              },
              style: const AuthButtonStyle(textStyle: TextStyle()),
              darkMode: context.select((ThemeBloc bloc) => bloc.isDarkModeEnabled),
            ),
          ),
        );

  }
}
