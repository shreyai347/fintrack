import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/features/receipt/repository/receipt_repository_impl.dart';
import 'package:fintrack/features/receipt/viewmodel/receipt_notifier.dart';

class ImagePreviewScreen extends ConsumerStatefulWidget {
  const ImagePreviewScreen({super.key, required this.imagePath});

  final String imagePath;

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
    if (!ok) setState(() => _error = AppStrings.receiptNotFound);
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Text(AppStrings.retake),
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
                      child: Text(AppStrings.usePhoto),
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
