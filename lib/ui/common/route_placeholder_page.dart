import 'package:flutter/material.dart';

import 'package:fintrack/l10n/app_localizations.dart';

class RoutePlaceholderPage extends StatelessWidget {
  const RoutePlaceholderPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          l10n.placeholderSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
