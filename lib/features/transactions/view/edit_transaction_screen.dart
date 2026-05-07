import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

import '../model/transaction_model.dart';
import '../viewmodel/transaction_provider.dart';
import '../viewmodel/transaction_state.dart';
import 'add_transaction_screen.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  const EditTransactionScreen({super.key, required this.transactionId});

  final int transactionId;

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  @override
  void dispose() {
    ref.read(addTransactionWizardProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(transactionNotifierProvider);
    final m = ref.watch(transactionByIdProvider(widget.transactionId));
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;

    Widget body;
    if (listState is TransactionLoading || listState is TransactionInitial) {
      body = const Center(child: CircularProgressIndicator());
    } else if (listState is TransactionError) {
      body = Center(child: Text(listState.message));
    } else if (m == null) {
      body = Center(child: Text(l10n.transactionNotFound));
    } else {
      body = SafeArea(
        child: _EditTransactionWizardLoader(
          key: ValueKey<int>(m.id),
          model: m,
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(l10n.editTransaction),
      ),
      body: body,
    );
  }
}

class _EditTransactionWizardLoader extends ConsumerStatefulWidget {
  const _EditTransactionWizardLoader({
    super.key,
    required this.model,
  });

  final TransactionModel model;

  @override
  ConsumerState<_EditTransactionWizardLoader> createState() =>
      _EditTransactionWizardLoaderState();
}

class _EditTransactionWizardLoaderState
    extends ConsumerState<_EditTransactionWizardLoader> {
  var _applied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(addTransactionWizardProvider.notifier).loadForEdit(widget.model);
      setState(() => _applied = true);
    });
  }

  @override
  void didUpdateWidget(covariant _EditTransactionWizardLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.id != widget.model.id) {
      _applied = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(addTransactionWizardProvider.notifier)
            .loadForEdit(widget.model);
        setState(() => _applied = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_applied) {
      return const Center(child: CircularProgressIndicator());
    }
    return const AddTransactionFlow(showDragHandle: false);
  }
}
