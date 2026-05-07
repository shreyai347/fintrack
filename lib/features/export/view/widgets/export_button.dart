import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.isLoading,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Material(
      color: card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isLoading ? null : onTap,
        splashColor: AppColors.accentDark.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.accentDark.withValues(alpha: 0.2),
                child: Icon(icon, color: AppColors.accentDark),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: title,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: muted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
