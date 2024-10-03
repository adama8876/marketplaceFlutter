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
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      mainImageUrl: data['mainImageUrl'] ?? '',
      secondImageUrl: data['secondImageUrl'],
      thirdImageUrl: data['thirdImageUrl'],
      fourthImageUrl: data['fourthImageUrl'],
      price: data['price'] ?? 0,
      quantity: data['quantity'] ?? 0,
      categoryId: data['categoryId'] ?? '',
      subcategoryId: data['subcategoryId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      variantData: List<String>.from(data['variantData'] ?? []),
    );
  }
}
