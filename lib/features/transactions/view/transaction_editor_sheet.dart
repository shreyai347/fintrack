import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/core/utils/validators.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../model/recurring_transaction_model.dart';
import '../repository/transaction_repository_impl.dart';
import '../viewmodel/transaction_provider.dart';

Future<void> openTransactionEditorSheet(
  BuildContext context,
  WidgetRef ref, {
  required bool isEditing,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        minChildSize: 0.55,
        maxChildSize: 0.98,
        builder: (_, scroll) {
          return TransactionEditorBody(
            scrollController: scroll,
            isEditing: isEditing,
          );
        },
      );
    },
  );
}

class TransactionEditorBody extends ConsumerStatefulWidget {
  const TransactionEditorBody({
    super.key,
    required this.scrollController,
    required this.isEditing,
  });

  final ScrollController scrollController;
  final bool isEditing;

  @override
  ConsumerState<TransactionEditorBody> createState() =>
      _TransactionEditorBodyState();
}

class _TransactionEditorBodyState extends ConsumerState<TransactionEditorBody> {
  late final TextEditingController _noteCtrl;
  bool _noteSynced = false;

  @override
  void initState() {
    super.initState();
    _noteCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = ref.watch(transactionWizardProvider);
    final wiz = ref.read(transactionWizardProvider.notifier);
    if (w.step != 4) {
      _noteSynced = false;
    } else if (!_noteSynced) {
      _noteSynced = true;
      _noteCtrl.value = TextEditingValue(
        text: w.note,
        selection: TextSelection.collapsed(offset: w.note.length),
      );
    }

    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    const labels = [
      AppStrings.transactionsStepAmount,
      AppStrings.transactionsStepCategory,
      AppStrings.transactionsStepSchedule,
      AppStrings.transactionsStepReceipt,
      AppStrings.transactionsStepNotes,
    ];

    Future<void> save() async {
      final errAmt = Validators.validateAmount(w.amountRaw);
      if (errAmt != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errAmt)));
        return;
      }
      if (w.categoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.transactionsSelectCategory)),
        );
        return;
      }
      final errNote = Validators.validateNote(w.note);
      if (errNote != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errNote)));
        return;
      }
      final amt = double.parse(w.amountRaw);
      final signed = w.isExpense ? -amt.abs() : amt.abs();
      final repo = ref.read(transactionRepositoryProvider);
      try {
        int? ruleId = w.baseline?.recurringRuleId;
        if (w.recurring != null && ruleId == null) {
          ruleId = await repo.addRecurringRule(
            RecurringRulesCompanion.insert(
              frequency: w.recurring!.name,
              nextDueDate: w.date,
              isActive: const Value(true),
            ),
          );
        }
        if (w.recurring == null) {
          ruleId = null;
        }

        if (widget.isEditing && w.editingId != null) {
          await ref.read(transactionNotifierProvider.notifier).updateTransaction(
                TransactionsCompanion(
                  id: Value(w.editingId!),
                  amount: Value(signed),
                  categoryId: Value(w.categoryId!),
                  note: Value(w.note.trim().isEmpty ? null : w.note.trim()),
                  date: Value(w.date),
                  receiptPath: Value(w.receiptPath),
                  isRecurring: Value(w.recurring != null),
                  recurringRuleId: Value(ruleId),
                ),
              );
        } else {
          await ref.read(transactionRepositoryProvider).add(
                TransactionsCompanion.insert(
                  amount: signed,
                  categoryId: w.categoryId!,
                  note: Value(w.note.trim().isEmpty ? null : w.note.trim()),
                  date: w.date,
                  receiptPath: Value(w.receiptPath),
                  isRecurring: Value(w.recurring != null),
                  recurringRuleId: Value(ruleId),
                ),
              );
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.transactionsSaved)),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e')),
          );
        }
      }
    }

    Future<void> confirmDelete() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppStrings.transactionsDeleteConfirmTitle),
          content: Text(AppStrings.transactionsDeleteConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(AppStrings.transactionsCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(AppStrings.transactionsDelete),
            ),
          ],
        ),
      );
      if (ok == true && context.mounted && w.editingId != null) {
        await ref
            .read(transactionNotifierProvider.notifier)
            .deleteTransaction(w.editingId!);
        if (context.mounted) Navigator.of(context).pop();
      }
    }

    Widget stepBody() {
      switch (w.step) {
        case 0:
          return Column(
            children: [
              Text(
                CurrencyFormatter.format(double.tryParse(w.amountRaw) ?? 0),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: Text(AppStrings.transactionsAmountExpense),
                    selected: w.isExpense,
                    onSelected: (_) => wiz.toggleExpense(true),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(AppStrings.transactionsAmountIncome),
                    selected: !w.isExpense,
                    onSelected: (_) => wiz.toggleExpense(false),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _EditorNumPad(
                onDigit: wiz.appendDigit,
                onDot: wiz.appendDot,
                onDel: wiz.deleteDigit,
              ),
            ],
          );
        case 1:
          final cats = ref.watch(categoriesProvider);
          return cats.when(
            data: (list) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: list.map((c) {
                final sel = w.categoryId == c.id;
                return FilterChip(
                  avatar: CategoryIcon(category: c, size: 22),
                  label: Text(c.name),
                  selected: sel,
                  onSelected: (_) => wiz.selectCategory(c.id),
                  selectedColor: accent,
                  checkmarkColor: AppColors.onVivid,
                  labelStyle: TextStyle(color: sel ? AppColors.onVivid : null),
                );
              }).toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
          );
        case 2:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(DateFormatter.formatDisplay(w.date)),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: w.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) wiz.setDate(d);
                },
              ),
              DropdownButton<String>(
                value: w.recurring == null ? 'none' : w.recurring!.name,
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'none',
                    child: Text(AppStrings.transactionsRecurringNone),
                  ),
                  DropdownMenuItem(
                    value: FrequencyType.daily.name,
                    child: Text(AppStrings.transactionsRecurringDaily),
                  ),
                  DropdownMenuItem(
                    value: FrequencyType.weekly.name,
                    child: Text(AppStrings.transactionsRecurringWeekly),
                  ),
                  DropdownMenuItem(
                    value: FrequencyType.monthly.name,
                    child: Text(AppStrings.transactionsRecurringMonthly),
                  ),
                ],
                onChanged: (v) {
                  if (v == null || v == 'none') {
                    wiz.setRecurring(null);
                  } else {
                    wiz.setRecurring(
                      FrequencyType.values.firstWhere((e) => e.name == v),
                    );
                  }
                },
              ),
            ],
          );
        case 3:
          final border =
              dark ? AppColors.borderDark : AppColors.borderLight;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: dark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final path = await Navigator.pushNamed<String?>(
                      context,
                      AppRoutes.receiptCamera,
                    );
                    if (path != null) wiz.setReceiptPath(path);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file, color: accent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppStrings.attachReceipt,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Icon(Icons.chevron_right, color: accent),
                      ],
                    ),
                  ),
                ),
              ),
              if (w.receiptPath != null) ...[
                const SizedBox(height: 12),
                _ReceiptPreviewRow(
                  path: w.receiptPath!,
                  onClear: () => wiz.setReceiptPath(null),
                ),
              ],
            ],
          );
        default:
          return TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
            onChanged: wiz.setNote,
          );
      }
    }

    return Material(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: ListView(
          controller: widget.scrollController,
          children: [
            if (widget.isEditing)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: confirmDelete,
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  label: Text(
                    AppStrings.transactionsDelete,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            Row(
              children: List.generate(5, (i) {
                final active = w.step == i;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 6,
                      decoration: BoxDecoration(
                        color: active ? accent : accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            Text(labels[w.step], style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 12),
            stepBody(),
            const SizedBox(height: 16),
            Row(
              children: [
                if (w.step > 0)
                  OutlinedButton(
                    onPressed: () => wiz.setStep(w.step - 1),
                    child: const Text('Back'),
                  ),
                const Spacer(),
                if (w.step < 4)
                  FilledButton(
                    onPressed: () => wiz.setStep(w.step + 1),
                    child: const Text('Next'),
                  )
                else
                  FilledButton(
                    onPressed: save,
                    child: Text(AppStrings.transactionsSave),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptPreviewRow extends StatelessWidget {
  const _ReceiptPreviewRow({
    required this.path,
    required this.onClear,
  });

  final String path;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final exists = File(path).existsSync();
    if (!exists) {
      return Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppStrings.receiptNotFound,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
          ),
        ],
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(path),
            height: 80,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: AppColors.cardDark.withValues(alpha: 0.85),
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: AppColors.onVivid,
              onPressed: onClear,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditorNumPad extends StatelessWidget {
  const _EditorNumPad({
    required this.onDigit,
    required this.onDot,
    required this.onDel,
  });

  final void Function(String) onDigit;
  final VoidCallback onDot;
  final VoidCallback onDel;

  @override
  Widget build(BuildContext context) {
    Widget key(String label, VoidCallback onTap) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(children: [key('1', () => onDigit('1')), key('2', () => onDigit('2')), key('3', () => onDigit('3'))]),
        Row(children: [key('4', () => onDigit('4')), key('5', () => onDigit('5')), key('6', () => onDigit('6'))]),
        Row(children: [key('7', () => onDigit('7')), key('8', () => onDigit('8')), key('9', () => onDigit('9'))]),
        Row(children: [key('.', onDot), key('0', () => onDigit('0')), key('⌫', onDel)]),
      ],
    );
  }
}
