// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/product_model.dart';
import 'package:marketplace_app/Services/auth_service.dart';
import 'package:marketplace_app/Services/product_service.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/component/ProductDetailsPage.dart';
import 'package:marketplace_app/View/component/image_carousel.dart';
import 'package:marketplace_app/Models/subcategory_model.dart';
import 'package:marketplace_app/View/pagePanier.dart';
import 'package:marketplace_app/Services/PanierService.dart';

// import 'package:marketplace_app/View/pagePanier.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> _images = [
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
  ];

  List<Product> _products = [];
  final ProductService _productService = ProductService();

  final CartService _panierService = CartService();

  List<Subcategory> _subcategories = [];
  String _selectedSubcategory = 'All';
  final SubcategoryService _subcategoryService = SubcategoryService();



  TextEditingController _searchController = TextEditingController();
List<Product> _filteredProducts = [];









  

  // List to track favorite status of each product
  List<bool> _isFavorite = [];

  @override
  void initState() {
    super.initState();
    _fetchSubcategories();
    _fetchProducts(); // Fetch products on initialization
     _filteredProducts = _products;
  }

 // Fetch products from Firestore
Future<void> _fetchProducts() async {
  try {
    List<Product> products = await _productService.fetchProducts();
    print('Fetched products: $products');
    setState(() {
      _products = products;
      _filteredProducts = products; // Mettre à jour la liste filtrée initialement
      _isFavorite = List<bool>.filled(_products.length, false);
    });
  } catch (e) {
    print('Error fetching products: $e');
  }
}




    void _filterProducts(String query) {
  List<Product> filteredList = _products.where((product) {
    return product.name.toLowerCase().contains(query.toLowerCase());
  }).toList();

  setState(() {
    _filteredProducts = filteredList;  // Met à jour la liste filtrée
  });
}








  // Fetch subcategories from Firestore
  Future<void> _fetchSubcategories() async {
    try {
      List<Subcategory> subcategories =
          await _subcategoryService.fetchSubcategories();
      setState(() {
        _subcategories = subcategories;
      });
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSubcategoryList(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImageCarousel(),
                  SizedBox(height: 30),
                  _buildProductGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white, 
    elevation: 0, 
    scrolledUnderElevation: 0,
    toolbarHeight: 80,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'BaikaSugu',
          style: GoogleFonts.lobster(
            color: AppColors.primaryColor,
            fontSize: 40,
            fontWeight: FontWeight.normal,
          ),
        ),
        GestureDetector(
          onTap: () {
            String userId = FirebaseAuth.instance.currentUser!.uid;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Pagepanier(userId: userId),
              ),
            );
          },
          child: StreamBuilder<int>(
            stream: _panierService.getCartItemCount(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              int cartItemCount = snapshot.data ?? 0; // Use snapshot to get the cart count
              return badges.Badge(
                badgeContent: Text(
                  cartItemCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(5),
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.grey,
                  size: 30,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}


  // Method to build the cart icon with the item count
  Widget _buildCartIcon(String count) {
    return badges.Badge(
      badgeContent: Text(
        count,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: Colors.red,
        padding: EdgeInsets.all(5),
      ),
      child: Icon(
        Icons.shopping_cart_outlined,
        color: Colors.grey,
        size: 30,
      ),
    );
  }



  // Search Bar Builder Method
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
            onChanged: (value) {
              _filterProducts(value);  // Appelle la fonction de filtrage à chaque changement
            },
              decoration: InputDecoration(
                hintText: 'Rechercher un produit',
                hintStyle: TextStyle(
                  color: const Color.fromARGB(176, 158, 158, 158),
                ),
                prefixIcon: Icon(Icons.search, size: 35),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.tune,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Subcategory List Builder Method
  Widget _buildSubcategoryList() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5, bottom: 20, right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSubcategoryButton('All', 'All'),
            ..._subcategories.map((subcategory) {
              return _buildSubcategoryButton(subcategory.name, subcategory.name);
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Method to build individual subcategory buttons
  Widget _buildSubcategoryButton(String displayText, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedSubcategory = value;
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
            color: _selectedSubcategory == value
                ? Colors.white
                : const Color.fromARGB(202, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  // Image Carousel Builder Method
  Widget _buildImageCarousel() {
    return Card(
      elevation: 10,
      shadowColor: AppColors.primaryColor,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        child: ImageCarousel(
          images: _images,
        ),
      ),
    );
  }

  // Product Grid Builder Method
  // Product Grid Builder Method
Widget _buildProductGrid() {
  print('Products in grid: $_filteredProducts'); // Mise à jour pour voir la liste filtrée
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: .61,
      ),
      itemCount: _filteredProducts.length, // Utiliser _filteredProducts
      itemBuilder: (context, index) {
        final product = _filteredProducts[index]; // Utiliser _filteredProducts
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


  // Product Card Builder Method
  Widget _buildProductCard({
  required String imageUrl,
  required String name,
  required int price,
  required int index,
}) {
  return Card(
    elevation: 5,
    shadowColor: AppColors.primaryColor,
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
            height: 175, // Adjusted height to fit content better
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
        
        SizedBox(height: 5), // Adjusted spacing

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
                  _isFavorite[index]
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
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
