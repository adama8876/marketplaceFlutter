import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id; // Add this line
  final String name;
  final String imageUrl;
  final DateTime createdAt;

  CategoryModel({
    required this.id, // Include id in the constructor
    required this.name,
    required this.imageUrl,
    required this.createdAt,
  });

  // Method to convert a Firestore document to CategoryModel
  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CategoryModel(
      id: documentId, // Assign the document ID to the id field
      name: data['name'],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
