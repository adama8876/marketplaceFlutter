// product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/Models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch products from Firestore
  Future<List<Product>> fetchProducts() async {
  try {
    final QuerySnapshot snapshot = await _firestore.collection('products').get();
    print('Product documents: ${snapshot.docs}'); // Add this line
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  } catch (e) {
    print('Error fetching products: $e'); // This is already present
    return [];
  }
}

}
