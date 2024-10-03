// subcategory_model.dart
class Subcategory {
  final String id;
  final String name;
  final String categoryId;
  // final DateTime dateAdded;

  Subcategory({
    required this.id,
    required this.name,
    required this.categoryId,
    // required this.dateAdded,
  });

  // Factory method to create a Subcategory instance from a Firebase document
  factory Subcategory.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Subcategory(
      id: documentId,
      name: data['nom'] ?? '',
      categoryId: data['categorieId'] ?? '',
      // dateAdded: (data['dateAjout'] as Timestamp).toDate(),
    );
  }
}
