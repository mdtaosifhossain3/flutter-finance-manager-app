import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoader({
    super.key,
    this.color = AppColors.primaryBlue,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeInOut(color: color, size: size);
  }
}
