// import 'package:flutter/material.dart';
//
// class CategoryDetailScreen extends StatelessWidget {
//   final String categoryName;
//
//   const CategoryDetailScreen({super.key, required this.categoryName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$categoryName Details'),
//         backgroundColor: const Color(0xff00D09E),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.category, size: 80, color: const Color(0xff00D09E)),
//             const SizedBox(height: 20),
//             Text(
//               'Welcome to $categoryName',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'This is the $categoryName category page.',
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }