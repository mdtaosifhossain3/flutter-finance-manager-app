import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
  bool centerTitle = true,

  double elevation = 0.0,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading:leading ,
    title: Text(title),
    actions: actions,
    centerTitle: centerTitle,

    elevation: elevation,
  );
}
