// lib/models/categoryModel/category_data_model.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryItemModel {
  /// store translation keys (not translated strings)
  final String key; // example: 'doctor'
  final String icon;
  final Color color;

  const CategoryItemModel(this.key, this.icon, this.color);

  /// translated name and group (evaluated at runtime)
  String get name => key.tr;

  /// Helper: check whether this category matches a search query.
  /// It checks both the translation key and the translated name, both lowercased.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final q = query.trim().toLowerCase();
    final translated = name.toLowerCase();
    final rawKey = key.toLowerCase();
    return translated.contains(q) || rawKey.contains(q);
  }
}
