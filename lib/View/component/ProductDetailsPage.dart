// product_details_page.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:marketplace_app/Models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.mainImageUrl),
              SizedBox(height: 20),
              Text(
                product.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '${product.price} FCFA',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              SizedBox(height: 10),
              Text(
                'Description: ${product.description}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
             
              // Display other attributes as needed
            ],
          ),
        ),
      ),
    );
  }
}
