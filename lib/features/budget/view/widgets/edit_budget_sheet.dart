import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/validators.dart';
import 'package:fintrack/features/transactions/model/category_model.dart';

import '../../model/budget_model.dart';
import '../../viewmodel/budget_provider.dart';

class EditBudgetSheet {
  static Future<void> show(
    BuildContext context, {
    required BudgetModel budget,
    required CategoryModel category,
    required bool canEdit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetCtx).bottom,
        ),
        child: Consumer(
          builder: (ctx, ref, _) => _EditBudgetBody(
            budget: budget,
            category: category,
            canEdit: canEdit,
            onSave: (value) async {
              await ref.read(budgetNotifierProvider.notifier).updateLimit(
                    budget.categoryId,
                    value,
                  );
            },
          ),
        ),
      ),
    );
  }
}

class _EditBudgetBody extends StatefulWidget {
  const _EditBudgetBody({
    required this.budget,
    required this.category,
    required this.canEdit,
    required this.onSave,
  });

  final BudgetModel budget;
  final CategoryModel category;
  final bool canEdit;
  final Future<void> Function(double newLimit) onSave;

  @override
  State<_EditBudgetBody> createState() => _EditBudgetBodyState();
}

class _EditBudgetBodyState extends State<_EditBudgetBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.budget.limitAmount == widget.budget.limitAmount.roundToDouble()
          ? widget.budget.limitAmount.toStringAsFixed(0)
          : widget.budget.limitAmount.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!widget.canEdit) return;
    final raw = _controller.text.trim();
    final err = Validators.validateAmount(raw);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    final normalized = CurrencyFormatter.formatInput(raw).replaceAll(',', '');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.validationAmountInvalid)),
      );
      return;
    }
    if (parsed <= widget.budget.spentAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.limitBelowSpent)),
      );
      return;
    }
    try {
      await widget.onSave(parsed);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.budgetUpdated)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    if (!widget.canEdit) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            AppStrings.budgetViewOnlyPast,
            style: TextStyle(color: muted),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.editBudget,
              style: TextStyle(
                color: title,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.category.color,
                  child: CategoryIcon(
                    category: widget.category,
                    size: 32,
                    iconColor: AppColors.onVivid,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.category.name,
                    style: TextStyle(
                      color: title,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${AppStrings.currentLimit}: ${CurrencyFormatter.format(widget.budget.limitAmount)}',
              style: TextStyle(color: muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              decoration: InputDecoration(
                labelText: AppStrings.newLimit,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _submit(context),
              child: Text(AppStrings.saveBudget),
            ),
          ],
        ),
      ),
    );
  }
}
