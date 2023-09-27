import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yggert_nu/utils/build_context_ext.dart';

import '../../../theme/bloc/theme_bloc.dart';

/// Widget, defines ListTile, onTap user forwarded to his email app to write email to developer.
class EmailDeveloperListTile extends StatelessWidget {
  /// Constructor for [EmailDeveloperListTile].
  const EmailDeveloperListTile({
    super.key,
  });

  /// Email address, where to write a email.
  String get emailAddress => 'artem.suvorov.dev@gmail.com';

  /// Subject of email.
  String get subject => 'Yggert Nu';

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.select((ThemeBloc bloc) => bloc.isDarkMode)
          ? null
          : Theme.of(context).secondaryHeaderColor,
      child: ListTile(
        title: Text(context.localizations.emailToMe),
        leading: const Icon(Icons.email),
        subtitle: Text(
          emailAddress,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        splashColor: Colors.transparent,
        onTap: () async {
          final uri = Uri(
            scheme: 'mailto',
            path: emailAddress,
            query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent('')}',
          );
          await launchUrl(uri);
        },
      ),
    );
  }
}
