import 'package:flutter/material.dart';

class AddTransactionStepScroll extends StatelessWidget {
  const AddTransactionStepScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                child,
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
