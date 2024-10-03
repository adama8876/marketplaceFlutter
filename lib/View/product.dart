// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// class ProductDetailsPage extends StatelessWidget {
//   const ProductDetailsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Image
//                 LayoutBuilder(
//                   builder: (context, constraints) {
//                     final double screenHeight = MediaQuery.of(context).size.height;
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 16.0),
//                       width: double.infinity,
//                       height: screenHeight * 0.5, // 30% of the screen height
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12.0),
//                         image: const DecorationImage(
//                           image: AssetImage('assets/testeur.jfif'), // Replace with actual image path
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 // Product Title and Price
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Text(
//                       'Chemise en jeans',
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2C3E50),
//                       ),
//                     ),
//                     Text(
//                       '17500 F CFA',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 // Description
//                 const Text(
//                   'Description:',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E50),
//                   ),
//                 ),
//                 const SizedBox(height: 8.0),
//                 const Text(
//                   'The attention to user experience in your designs is remarkable. Each element feels purposeful and well-crafted. It\'s evident that you prioritize the end user. 🧑‍💻 The attention to user experience in your designs is remarkable...',
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 // Colors
//                 const Text(
//                   'COULEURS:',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E50),
//                   ),
//                 ),
//                 const SizedBox(height: 8.0),
//                 Row(
//                   children: [
//                     _buildColorOption(Colors.red),
//                     _buildColorOption(Colors.orange),
//                     _buildColorOption(Colors.green),
//                     _buildColorOption(Colors.blue),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 // Sizes
//                 const Text(
//                   'TAILLES:',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E50),
//                   ),
//                 ),
//                 const SizedBox(height: 80.0), // Extra space to avoid content being hidden behind the button
//               ],
//             ),
//           ),
//           // Add to Cart Button fixed at the bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // Add to cart action
//                   },
//                   style: ElevatedButton.styleFrom(
//                     // primary: const Color(0xFF2C3E50),
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   icon: const Icon(Icons.shopping_cart),
//                   label: const Text(
//                     'Ajouter au Panier',
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to build color options
//   Widget _buildColorOption(Color color) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8.0),
//       width: 24,
//       height: 24,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
