import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_strings.dart';

import '../viewmodel/transaction_provider.dart';
import 'transaction_editor_sheet.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  const EditTransactionScreen({super.key, required this.transactionId});

  final int transactionId;

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  var _opened = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(transactionByIdProvider(widget.transactionId));
    ref.listen(
      transactionByIdProvider(widget.transactionId),
      (previous, next) {
        next.whenData((m) {
          if (m == null || _opened) return;
          _opened = true;
          Future.microtask(() async {
            ref.read(transactionWizardProvider.notifier).load(m);
            if (!context.mounted) return;
            await openTransactionEditorSheet(context, ref, isEditing: true);
            if (context.mounted) Navigator.of(context).pop();
          });
        });
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.transactionsEditTitle)),
      body: async.when(
        data: (m) => m == null
            ? Center(child: Text(AppStrings.transactionNotFound))
            : const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
