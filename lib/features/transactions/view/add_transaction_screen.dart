import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/features/transactions/view/add_transaction/bottom_actions.dart';
import 'package:fintrack/features/transactions/view/add_transaction/persist_new_transaction.dart';
import 'package:fintrack/features/transactions/view/add_transaction/sheet_header.dart';
import 'package:fintrack/features/transactions/view/add_transaction/steps/step_amount.dart';
import 'package:fintrack/features/transactions/view/add_transaction/steps/step_category.dart';
import 'package:fintrack/features/transactions/view/add_transaction/steps/step_receipt.dart';
import 'package:fintrack/features/transactions/view/add_transaction/steps/step_review.dart';
import 'package:fintrack/features/transactions/view/add_transaction/steps/step_schedule.dart';

import '../viewmodel/transaction_provider.dart';

/// Full-screen add flow layered in [MainShell] so the bottom bar and FAB stay visible.
void openAddTransactionOverlay(WidgetRef ref) {
  ref.read(addTransactionWizardProvider.notifier).reset();
  ref.read(addTransactionOverlayVisibleProvider.notifier).show();
}

Future<void> showAddTransactionSheet(BuildContext context, WidgetRef ref) async {
  ref.read(addTransactionWizardProvider.notifier).reset();
  await Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (ctx) => AddTransactionScaffold(
        onClose: () {
          ref.read(addTransactionWizardProvider.notifier).reset();
          Navigator.of(ctx).pop();
        },
      ),
    ),
  );
}

class AddTransactionScaffold extends ConsumerWidget {
  const AddTransactionScaffold({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title = ref.watch(addTransactionWizardProvider).editingId != null
        ? l10n.editTransaction
        : l10n.addTransaction;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
        title: Text(title),
      ),
      body: SafeArea(
        top: false,
        child: AddTransactionFlow(
          showDragHandle: false,
          embeddedInScaffoldAppBar: true,
        ),
      ),
    );
  }
}

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showAddTransactionSheet(context, ref);
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class AddTransactionFlow extends ConsumerStatefulWidget {
  const AddTransactionFlow({
    super.key,
    required this.showDragHandle,
    this.embeddedInScaffoldAppBar = false,
  });

  final bool showDragHandle;
  final bool embeddedInScaffoldAppBar;

  @override
  ConsumerState<AddTransactionFlow> createState() =>
      _AddTransactionFlowState();
}

class _AddTransactionFlowState extends ConsumerState<AddTransactionFlow> {
  late PageController _pageController;
  late bool _pageControllerExpenseMode;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(addTransactionWizardProvider).isExpense;
    _pageControllerExpenseMode = initial;
    _pageController = PageController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddTransactionSheetState>(
      addTransactionWizardProvider,
      (prev, next) {
        if (prev?.isExpense == next.isExpense &&
            prev?.currentStep != next.currentStep) {
          _pageController.animateToPage(
            next.currentStep,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        final last =
            AddTransactionWizardNotifier.lastStepIndex(next.isExpense);
        if (next.currentStep == last &&
            (_noteController.text != next.note ||
                (prev?.currentStep != last && next.currentStep == last))) {
          _noteController.value = TextEditingValue(
            text: next.note,
            selection: TextSelection.collapsed(offset: next.note.length),
          );
        }
      },
    );

    final w = ref.watch(addTransactionWizardProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final totalSteps = AddTransactionWizardNotifier.stepCount(w.isExpense);

    if (_pageControllerExpenseMode != w.isExpense) {
      _pageControllerExpenseMode = w.isExpense;
      _pageController.dispose();
      _pageController = PageController(initialPage: w.currentStep);
    }

    final pages = <Widget>[
      AddTransactionStepAmount(dark: dark),
      if (w.isExpense) AddTransactionStepCategory(dark: dark),
      AddTransactionStepSchedule(dark: dark),
      AddTransactionStepReceipt(dark: dark),
      AddTransactionStepReview(
        dark: dark,
        noteController: _noteController,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showDragHandle) AddTransactionSheetHandle(dark: dark),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddTransactionStepHeader(
                currentStep: w.currentStep,
                totalSteps: totalSteps,
                dark: dark,
                compact: widget.embeddedInScaffoldAppBar,
              ),
              const SizedBox(height: 10),
              AddTransactionStepPills(
                currentStep: w.currentStep,
                totalSteps: totalSteps,
                dark: dark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: AddTransactionBottomActions(
            dark: dark,
            onSave: () => persistNewTransaction(context, ref, _noteController),
          ),
        ),
      ],
    );
  }
}
