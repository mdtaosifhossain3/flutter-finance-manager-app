import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? color;
  final Widget? progressIndicator;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.color,
    this.progressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: color ?? Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: progressIndicator ?? const CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
