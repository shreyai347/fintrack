import 'package:flutter/material.dart';

import 'package:fintrack/core/constants/app_colors.dart';

Future<bool> showFintrackConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
  bool destructiveConfirm = false,
}) async {
  final dark = Theme.of(context).brightness == Brightness.dark;
  final bg = dark ? AppColors.cardDark : AppColors.cardLight;
  final titleC =
      dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  final bodyC = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
  final cancelC = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
  final border = dark ? AppColors.borderDark : AppColors.borderLight;

  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) => AlertDialog(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: border, width: 0.5),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleC,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(color: bodyC, fontSize: 14, height: 1.35),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancelLabel, style: TextStyle(color: cancelC)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: destructiveConfirm
                ? AppColors.error
                : (dark ? AppColors.accentDark : AppColors.accentLight),
            foregroundColor: AppColors.onVivid,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result == true;
}
