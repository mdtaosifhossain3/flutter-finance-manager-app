// import 'package:flutter/material.dart';
// import 'dart:math';
//
// class SegmentedProgressBar extends StatelessWidget {
//   final double spending;
//
//   const SegmentedProgressBar({super.key, required this.spending});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CustomPaint(
//         painter: _SegmentedProgressPainter(),
//         size: const Size(200, 200),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "\$${spending.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 "Spending",
//                 style: TextStyle(color: Colors.grey, fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _SegmentedProgressPainter extends CustomPainter {
//   final double strokeWidth = 16;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     final double startAngle = -pi / 2; // start from top
//     final double sweep = 2 * pi / 3; // each arc ~120°
//
//     final Paint paint1 = Paint()
//       ..color = Colors.grey.shade400
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;
//
//     final Paint paint2 = Paint()
//       ..color = const Color(0xFF5B7FFF) // Blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;
//
//     final Paint paint3 = Paint()
//       ..color = const Color(0xFF8B5CF6) // Purple
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;
//
//     // First segment (grey)
//     canvas.drawArc(rect.deflate(20), startAngle, sweep, false, paint1);
//     // Second segment (blue)
//     canvas.drawArc(rect.deflate(20), startAngle + sweep + 0.3, sweep, false, paint2);
//     // Third segment (purple)
//     canvas.drawArc(rect.deflate(20), startAngle + 2 * (sweep + 0.3), sweep, false, paint3);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
