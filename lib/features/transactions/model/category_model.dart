import 'package:flutter/material.dart';

import 'package:fintrack/core/utils/extensions.dart';
import 'package:fintrack/generated/database/app_database.dart' as db;

typedef CategoryEntry = db.Category;

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorHex,
    required this.isDefault,
    required this.createdAt,
  });

  final int id;
  final String name;
  final int iconCodePoint;
  final String colorHex;
  final bool isDefault;
  final DateTime createdAt;

  factory CategoryModel.fromDrift(CategoryEntry entry) {
    return CategoryModel(
      id: entry.id,
      name: entry.name,
      iconCodePoint: entry.iconCodePoint,
      colorHex: entry.colorHex,
      isDefault: entry.isDefault,
      createdAt: entry.createdAt,
    );
  }

  /// Uses only const [IconData] so `flutter build` can tree-shake icon fonts.
  IconData get iconData {
    switch (iconCodePoint) {
      case 0xe533:
        return const IconData(0xe533, fontFamily: 'MaterialIcons');
      case 0xe531:
        return const IconData(0xe531, fontFamily: 'MaterialIcons');
      case 0xe59c:
        return const IconData(0xe59c, fontFamily: 'MaterialIcons');
      case 0xe237:
        return const IconData(0xe237, fontFamily: 'MaterialIcons');
      case 0xe3f5:
        return const IconData(0xe3f5, fontFamily: 'MaterialIcons');
      case 0xe40d:
        return const IconData(0xe40d, fontFamily: 'MaterialIcons');
      case 0xe263:
        return const IconData(0xe263, fontFamily: 'MaterialIcons');
      case 0xe5c4:
        return const IconData(0xe5c4, fontFamily: 'MaterialIcons');
      default:
        return const IconData(0xe5c4, fontFamily: 'MaterialIcons');
    }
  }

  Color get color => colorHex.toColor();
}
