import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/Models/categoriemodel.dart';
import 'package:marketplace_app/Models/product_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get categories from Firestore
  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) {
        // Pass the document ID to the fromFirestore method
        return CategoryModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error retrieving categories: $e');
    }
  }



  
}
