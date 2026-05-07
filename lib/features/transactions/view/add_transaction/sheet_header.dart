import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

import '../../viewmodel/transaction_provider.dart';

class AddTransactionSheetHandle extends StatelessWidget {
  const AddTransactionSheetHandle({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 32,
        height: 3,
        margin: const EdgeInsets.only(top: 10, bottom: 14),
        decoration: BoxDecoration(
          color: dark ? AppColors.borderDark : AppColors.borderLight,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class AddTransactionStepHeader extends ConsumerWidget {
  const AddTransactionStepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.dark,
    this.compact = false,
  });

  final int currentStep;
  final int totalSteps;
  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final w = ref.watch(addTransactionWizardProvider);
    final title = w.editingId != null
        ? l10n.editTransaction
        : l10n.addTransaction;
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    return Row(
      children: [
        if (!compact) ...[
          Text(
            title,
            style: TextStyle(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
        ] else
          const Spacer(),
        Text(
          '${currentStep + 1} / $totalSteps',
          style: TextStyle(color: hint, fontSize: 13),
        ),
      ],
    );
  }
}

class AddTransactionStepPills extends StatelessWidget {
  const AddTransactionStepPills({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.dark,
  });

  final int currentStep;
  final int totalSteps;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final inactive =
        dark ? AppColors.borderDark : AppColors.borderLight;
    return Row(
      children: List.generate(totalSteps, (i) {
        final active = i <= currentStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 6,
              decoration: BoxDecoration(
                color: active ? accent : inactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
