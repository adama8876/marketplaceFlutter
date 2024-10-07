// product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String mainImageUrl;
  final String? secondImageUrl;
  final String? thirdImageUrl;
  final String? fourthImageUrl;
  final int price;
  final int quantity;
  final String categoryId;
  final String subcategoryId;
  final DateTime createdAt;
  final List<String> variantData;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.mainImageUrl,
    this.secondImageUrl,
    this.thirdImageUrl,
    this.fourthImageUrl,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.subcategoryId,
    required this.createdAt,
    required this.variantData,
  });

  // Factory method to create a Product from Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  print('Firestore data: $data'); // Log the data for inspection

  return Product(
    id: doc.id,
    name: data['name']?.toString() ?? '',
    description: data['description']?.toString() ?? '',
    mainImageUrl: data['mainImageUrl']?.toString() ?? '',
    secondImageUrl: data['secondImageUrl']?.toString(),
    thirdImageUrl: data['thirdImageUrl']?.toString(),
    fourthImageUrl: data['fourthImageUrl']?.toString(),
    price: data['price'] ?? 0,
    quantity: data['quantity'] ?? 0,
    categoryId: data['categoryId']?.toString() ?? '',
    subcategoryId: data['subcategoryId']?.toString() ?? '',
    createdAt: (data['createdAt'] as Timestamp).toDate(),
    variantData: (data['variantData'] as List<dynamic>).map((item) => item.toString()).toList(),
  );
}


}
