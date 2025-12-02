import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
  bool centerTitle = true,

  double elevation = 0.0,
  TextStyle? titleStyle,
  Color? backgroundColor,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: leading,
    title: Text(title, style: titleStyle),
    actions: actions,
    centerTitle: centerTitle,
    elevation: elevation,
    backgroundColor: backgroundColor,
  );
}
