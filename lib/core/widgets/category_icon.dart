import 'package:flutter/material.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/category_icon_assets.dart';
import 'package:fintrack/features/transactions/model/category_model.dart';

/// Renders [Image.asset] when configured for the category name, else [Icon].
class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.category,
    required this.size,
    this.iconColor,
  });

  final CategoryModel category;
  final double size;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final path = CategoryIconAssets.pathForCategoryName(category.name);
    final fallbackColor = iconColor ?? AppColors.onVivid;
    if (path != null) {
      return Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          category.iconData,
          size: size * 0.85,
          color: fallbackColor,
        ),
      );
    }
    return Icon(
      category.iconData,
      size: size * 0.85,
      color: fallbackColor,
    );
  }
}
