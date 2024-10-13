import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/product_model.dart';
import 'package:marketplace_app/Models/subcategory_model.dart';
import 'package:marketplace_app/Services/auth_service.dart';
import 'package:marketplace_app/Services/product_service.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/component/ProductDetailsPage.dart';
// import 'package:marketplace_app/ProductDetailsPage.dart'; // Import your ProductDetailsPage

class Catproducts extends StatefulWidget {
  final String categoryId; // ID de la catégorie
  final String categoryName; // Nom de la catégorie

  const Catproducts({super.key, required this.categoryId, required this.categoryName});

  @override
  State<Catproducts> createState() => _CatproductsState();
}

class _CatproductsState extends State<Catproducts> {
  late Future<List<Subcategory>> _subcategoriesFuture;
  late Future<List<Product>> _productsFuture;
  String _selectedSubcategory = 'All'; // Default selection for subcategories
  final ProductService _productService = ProductService();
  List<Product> _products = []; // Store products
  List<bool> _isFavorite = []; // To keep track of favorite products

 @override
void initState() {
  super.initState();
  _selectedSubcategory = 'All'; 
  _subcategoriesFuture = fetchSubcategoriesForCategory(widget.categoryId);
  _productsFuture = _fetchProductsBySubcategory(_selectedSubcategory); // Fetch products by 'All' initially
}

  Future<List<Subcategory>> fetchSubcategoriesForCategory(String categoryId) async {
    final SubcategoryService subcategoryService = SubcategoryService();
    return await subcategoryService.fetchSubcategories().then((subcategories) {
      return subcategories.where((subcategory) => subcategory.categoryId == categoryId).toList();
    });
  }

  Future<List<Product>> _fetchProductsBySubcategory(String subcategoryId) async {
  List<Product> products;

  if (subcategoryId == 'All') {
    products = await _productService.fetchProductsByCategory(widget.categoryId);
  } else {
    products = await _productService.fetchProductsBySubcategory(subcategoryId);
  }

  // Initialize the favorite list based on the fetched products
  _isFavorite = List<bool>.filled(products.length, false); // Only initialize if products are retrieved
  return products;
}




  Future<List<Product>> _fetchProductsByCategory(String categoryId) async {
    _products = await _productService.fetchProductsBySubcategory(categoryId);
    _isFavorite = List<bool>.filled(_products.length, false); // Initialize favorite list based on fetched products
    return _products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        title: Text(
          '#${widget.categoryName}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Subcategory>>(
            future: _subcategoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucune sous-catégorie trouvée'));
              } else {
                final subcategories = snapshot.data!;
                return _buildSubcategoryList(subcategories);
              }
            },
          ),
          Expanded(
  child: FutureBuilder<List<Product>>(
    future: _productsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Erreur: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('Aucun produit trouvé'));
      } else {
        final products = snapshot.data!;
        return _buildProductGrid(products);
      }
    },
  ),
),


        ],
      ),
    );
  }

  Widget _buildSubcategoryList(List<Subcategory> subcategories) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5, bottom: 20, right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSubcategoryButton('All', 'All'), // Button for 'All'
            ...subcategories.map((subcategory) {
              return _buildSubcategoryButton(subcategory.name, subcategory.id);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryButton(String displayText, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedSubcategory = value;
          _productsFuture = _fetchProductsBySubcategory(value); // Fetch products based on selected subcategory
        });
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        backgroundColor: _selectedSubcategory == value
            ? AppColors.primaryColor
            : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        displayText,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: _selectedSubcategory == value ? Colors.white : const Color.fromARGB(202, 0, 0, 0),
        ),
      ),
    ),
  );
}


  // Updated Product Grid Builder Method
  Widget _buildProductGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.73,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: _buildProductCard(
              imageUrl: product.mainImageUrl,
              name: product.name,
              price: product.price,
              index: index,
            ),
          );
        },
      ),
    );
  }

  // Updated Product Card Builder Method
  Widget _buildProductCard({
    required String imageUrl,
    required String name,
    required int price,
    required int index,
  }) {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Image section
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Product name section
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 5),

          // Price and favorite icon section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '$price FCFA',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: Icon(
                    _isFavorite[index] ? Icons.favorite : Icons.favorite_border_outlined,
                    color: _isFavorite[index] ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite[index] = !_isFavorite[index];
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

