import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSizeWidget customAppBar({
  required String title,
  List<Widget>? actions,
  bool centerTitle = true,

  double elevation = 0.0,
}) {
  return AppBar(
    title: Text(title),
    actions: actions,
    centerTitle: centerTitle,

    elevation: elevation,
  );
}
