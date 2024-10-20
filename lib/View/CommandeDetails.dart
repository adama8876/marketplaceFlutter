// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/component/PaymentMethodSelector.dart';
import 'package:marketplace_app/View/component/livraison_selector.dart';

class CommandeDetails extends StatefulWidget {
  final List<Map<String, dynamic>> articles; // List of articles passed as a parameter

  const CommandeDetails({super.key, required this.articles}); // Accept articles in the constructor

  @override
  _CommandeDetailsState createState() => _CommandeDetailsState();
}

class _CommandeDetailsState extends State<CommandeDetails> {
  int fraisLivraison = 0; 

  void updateFraisLivraison(int frais) {
    setState(() {
      fraisLivraison = frais; 
    });
  }

  @override
  Widget build(BuildContext context) {
  
    final int sousTotal = widget.articles.fold<int>(0, (sum, item) {
      
      return sum + (item['price'] as int) * (item['quantity'] as int); // Cast to int
    });

    final int totalCommande = sousTotal + fraisLivraison;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Détails de la commande',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0), 
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mes Articles',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      itemCount: widget.articles.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final article = widget.articles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(article['image'], width: 50, height: 50),
                            title: Text(
                              article['name'],
                              style: GoogleFonts.poppins(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              'Quantité: ${article['quantity'] ?? 1}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            trailing: Text(
                              '${article['price'] ?? 0} F',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sous-Total', style: GoogleFonts.poppins(fontSize: 16)),
                            Text('$sousTotal F', style: GoogleFonts.poppins(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Frais de Livraison', style: GoogleFonts.poppins(fontSize: 16)),
                            Text('$fraisLivraison F', style: GoogleFonts.poppins(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Commande', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('$totalCommande F', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    LivraisonSelector(
                      onFraisChange: updateFraisLivraison,
                    ),
                    PaymentMethodSelector(),
                  ],
                ),
              ),
            ),
          ),
         Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), 
                    ),
                    minimumSize: Size(double.infinity, 50), 
                    elevation: 5, 
                  ),
                  child: Text(
                    'Confirmer la commande', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}
