import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

class QrShareWidget extends StatelessWidget {
  const QrShareWidget({super.key, required this.qrData});

  final String qrData;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = Theme.of(context).brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.scanToView,
            style: TextStyle(
              color: title,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          QrImageView(
            data: qrData,
            size: 200,
            backgroundColor: AppColors.cardLight,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.cardDark,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.cardDark,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentLight,
            ),
            onPressed: () =>
                SharePlus.instance.share(ShareParams(text: qrData)),
            child: Text(l10n.shareSummary),
          ),
        ],
      ),
    );
  }
}
