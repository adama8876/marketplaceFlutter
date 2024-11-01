// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/commande_model.dart';
import 'package:marketplace_app/Models/product_model.dart';
import 'package:marketplace_app/Utils/themes.dart';

class CommandeResumePage extends StatefulWidget {
  final Commande commande;

  CommandeResumePage({Key? key, required this.commande}) : super(key: key);

  @override
  _CommandeResumePageState createState() => _CommandeResumePageState();
}

class _CommandeResumePageState extends State<CommandeResumePage> {
  Map<String, String> productNames = {};

  @override
  void initState() {
    super.initState();
    _loadProductNames();
  }

  Future<void> _loadProductNames() async {
    for (var item in widget.commande.items) {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(item.productId)
          .get();
      if (productDoc.exists) {
        final product = Product.fromFirestore(productDoc);
        setState(() {
          productNames[item.productId] = product.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Détails de la Commande',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Adresse de Livraison:',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
            ...widget.commande.adresse.map((adresse) => Text(adresse, style: GoogleFonts.poppins(fontSize: 16))).toList(),
            SizedBox(height: 16),

            Text(
              'Date de la commande: ${widget.commande.dateLivraison.toLocal().toString().split(' ')[0]}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Produits:',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Nom', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryColor))),
                  DataColumn(label: Text('Quantité', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryColor))),
                  DataColumn(label: Text('Prix', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryColor))),
                ],
                rows: widget.commande.items.map((item) {
                  final productName = productNames[item.productId] ?? 'Chargement...';
                  return DataRow(cells: [
                    DataCell(Text(productName, style: GoogleFonts.poppins())),
                    DataCell(Text(item.quantity.toString(), style: GoogleFonts.poppins())),
                    DataCell(Text('${item.price}', style: GoogleFonts.poppins(fontSize: 16))),
                  ]);
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Détails du Paiement:',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Méthode', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryColor))),
                DataColumn(label: Text('Sous-total', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryColor))),
              ],
              rows: widget.commande.paymentDetails.map((payment) {
                return DataRow(cells: [
                  DataCell(Text(payment.method, style: GoogleFonts.poppins())),
                  DataCell(Text('${payment.sousTotal} FCFA', style: GoogleFonts.poppins())),
                ]);
              }).toList(),
            ),
            SizedBox(height: 16),

            Text(
              'Montant Total: ${widget.commande.totalAmount} FCFA',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
