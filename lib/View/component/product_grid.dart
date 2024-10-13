// // product_grid.dart

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:marketplace_app/Models/product_model.dart';
// import 'package:marketplace_app/Utils/themes.dart';
// import 'package:marketplace_app/View/component/ProductDetailsPage.dart';

// class ProductGrid extends StatelessWidget {
//   final List<Product> products;

//   const ProductGrid({required this.products});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.73,
//         ),
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductDetailsPage(product: product),
//                 ),
//               );
//             },
//             child: _buildProductCard(
//               imageUrl: product.mainImageUrl,
//               name: product.name,
//               price: product.price,
//               index: index,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProductCard({
//     required String imageUrl,
//     required String name,
//     required int price,
//     required int index,
//   }) {
//     return Card(
//       color: Colors.grey[300],
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 10, left: 15, right: 15),
//             child: Container(
//               height: 150,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(imageUrl),
//                   fit: BoxFit.cover,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             name,
//             style: GoogleFonts.poppins(
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Text(
//                   '$price FCFA',
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 0),
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.favorite_border_outlined,
//                     color: Colors.grey,
//                     size: 30,
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
