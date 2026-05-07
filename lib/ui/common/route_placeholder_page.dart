import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class RoutePlaceholderPage extends StatelessWidget {
  const RoutePlaceholderPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          AppStrings.placeholderSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
