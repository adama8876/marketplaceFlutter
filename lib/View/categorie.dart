// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/categoriemodel.dart';
import 'package:marketplace_app/Services/categorie_service.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/catProducts.dart';

class Categorie extends StatefulWidget {
  const Categorie({super.key});

  @override
  _CategorieState createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<CategoryModel>> _categoriesFuture;
  List<CategoryModel> _categories = []; 
  List<CategoryModel> _filteredCategories = []; 
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.getCategories();
    _searchController.addListener(_onSearchChanged); 
  }

  @override
  void dispose() {
    _searchController.dispose(); 
    super.dispose();
  }

  void _onSearchChanged() {
    // Méthode appelée à chaque changement dans la barre de recherche
    setState(() {
      _filteredCategories = _categories
          .where((category) => category.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        title: Text(
          'Catégories',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune catégorie trouvée'));
          } else {
            _categories = snapshot.data!;
            // Si la liste filtrée est vide, utilisez la liste complète au départ
            _filteredCategories = _filteredCategories.isEmpty && _searchController.text.isEmpty ? _categories : _filteredCategories;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildSearchBar(),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: _buildCategorieGrid(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategorieGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        return _buildCategorieCard(_filteredCategories[index]);
      },
    );
  }

  Widget _buildCategorieCard(CategoryModel category) {
    return InkWell(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Catproducts(
            categoryId: category.id, 
            categoryName: category.name, 
          ),
        ),
      );
        
      },
      splashColor: Colors.blue.withAlpha(50), // Effet visuel de l'onde
      borderRadius: BorderRadius.circular(12.0), // Pour arrondir les bords de l'effet d'onde
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section de l'image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Section du texte (nom de la catégorie)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    category.name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "200 produits",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController, // Connectez le contrôleur ici
              decoration: InputDecoration(
                hintText: 'Rechercher une catégorie',
                hintStyle: TextStyle(
                  color: const Color.fromARGB(176, 158, 158, 158),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  size: 35,
                  color: AppColors.primaryColor,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
