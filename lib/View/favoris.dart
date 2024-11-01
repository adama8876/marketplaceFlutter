import 'package:flutter/material.dart';
import 'package:marketplace_app/Models/product_model.dart';
import 'package:marketplace_app/Services/favoris_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/component/ProductDetailsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Favoris extends StatefulWidget {
  const Favoris({super.key});

  @override
  _FavorisState createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  final FavoriteService _favoriteService = FavoriteService();
  List<Product> _favoriteProducts = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      _fetchFavorites();
    } else {
      setState(() {
        _favoriteProducts = [];
      });
    }
  }

  void _fetchFavorites() async {
    if (userId != null) {
      try {
        List<Product> favorites = await _favoriteService.getFavorites(userId!);
        setState(() {
          _favoriteProducts = favorites;
        });
      } catch (e) {
        print("Error fetching favorites: $e");
      }
    }
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: .65,
        ),
        itemCount: _favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = _favoriteProducts[index];
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
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Container(
              height: 175,
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),
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
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () async {
                  try {
                    await _favoriteService.removeFromFavorites(
                        userId!, _favoriteProducts[index].id);
                    setState(() {
                      _favoriteProducts.removeAt(index);
                    });
                  } catch (e) {
                    print("Error removing favorite: $e");
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        title: Text(
          'Favoris',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: _favoriteProducts.isEmpty
          ? const Center(child: Text('Aucun produit dans les favoris.'))
          : _buildProductGrid(),
    );
  }
}
