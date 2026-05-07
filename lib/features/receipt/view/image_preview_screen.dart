import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/features/receipt/repository/receipt_repository_impl.dart';
import 'package:fintrack/features/receipt/viewmodel/receipt_notifier.dart';

class ImagePreviewScreen extends ConsumerStatefulWidget {
  const ImagePreviewScreen({
    super.key,
    required this.imagePath,
    this.readOnly = false,
  });

  final String imagePath;

  /// When true (e.g. viewing a saved transaction receipt), do not delete the file on close.
  final bool readOnly;

  @override
  ConsumerState<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends ConsumerState<ImagePreviewScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final ok =
        await ref.read(receiptRepositoryProvider).receiptExists(widget.imagePath);
    if (!mounted) return;
    if (!ok) {
      final loc = AppLocalizations.of(context)!;
      setState(() => _error = loc.receiptNotFound);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      final theme = Theme.of(context);
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(l10n.transactionDetailViewReceipt),
        ),
        body: _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            : InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Center(
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    final bg = AppColors.scaffoldDark;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.onVivid),
                onPressed: () async {
                  await ref
                      .read(receiptRepositoryProvider)
                      .deleteReceipt(widget.imagePath);
                  ref.read(receiptNotifierProvider.notifier).clearReceipt();
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: AppColors.textMutedDark),
                      ),
                    )
                  : Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onVivid,
                        side: const BorderSide(color: AppColors.borderDark),
                      ),
                      onPressed: () async {
                        await ref
                            .read(receiptRepositoryProvider)
                            .deleteReceipt(widget.imagePath);
                        ref
                            .read(receiptNotifierProvider.notifier)
                            .clearReceipt();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: Text(l10n.retake),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accentDark,
                      ),
                      onPressed: _error != null
                          ? null
                          : () {
                              Navigator.of(context).pop(widget.imagePath);
                            },
                      child: Text(l10n.usePhoto),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
