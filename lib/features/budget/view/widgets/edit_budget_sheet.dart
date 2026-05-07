import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/utils/category_localizations.dart';
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
  var _formatting = false;

  @override
  void initState() {
    super.initState();
    final initialPlain = widget.budget.limitAmount ==
            widget.budget.limitAmount.roundToDouble()
        ? widget.budget.limitAmount.toStringAsFixed(0)
        : widget.budget.limitAmount.toString();
    _controller = TextEditingController(
      text: CurrencyFormatter.formatIndianInputDisplay(
        CurrencyFormatter.formatInput(initialPlain),
      ),
    );
    _controller.addListener(_onLimitTextChanged);
  }

  void _onLimitTextChanged() {
    if (_formatting) return;
    final plain = CurrencyFormatter.formatInput(
      _controller.text.replaceAll(',', ''),
    );
    final formatted =
        CurrencyFormatter.formatIndianInputDisplay(plain, allowEmpty: true);
    if (formatted != _controller.text) {
      _formatting = true;
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      _formatting = false;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onLimitTextChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.canEdit) return;
    final raw = _controller.text.trim();
    final err = Validators.validateAmount(raw);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    final normalized =
        CurrencyFormatter.formatInput(raw.replaceAll(',', ''));
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.validationAmountInvalid)),
      );
      return;
    }
    if (parsed <= widget.budget.spentAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.limitBelowSpent)),
      );
      return;
    }
    try {
      await widget.onSave(parsed);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.budgetUpdated)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    if (!widget.canEdit) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            l10n.budgetViewOnlyPast,
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
              l10n.editBudget,
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
                    localizedCategoryName(l10n, widget.category.name),
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
              '${l10n.currentLimit}: ${CurrencyFormatter.format(widget.budget.limitAmount)}',
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
                labelText: l10n.newLimit,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _submit(context),
              child: Text(l10n.saveBudget),
            ),
          ],
        ),
      ),
    );
  }
}
