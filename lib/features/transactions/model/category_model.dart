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

  IconData get iconData =>
      IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  Color get color => colorHex.toColor();
}
