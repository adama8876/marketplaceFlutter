// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Services/PanierService.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/Commandes.dart';
import 'package:marketplace_app/View/component/PaymentMethodSelector.dart';
import 'package:marketplace_app/View/component/livraison_selector.dart';
import 'package:marketplace_app/Models/commande_model.dart'; // Assurez-vous d'importer le modèle
import 'package:marketplace_app/Services/commande_service.dart';
import 'package:marketplace_app/View/userinfo.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart'; // Assurez-vous d'importer le service

class CommandeDetails extends StatefulWidget {
  final List<Map<String, dynamic>> articles; // List of articles passed as a parameter

  const CommandeDetails({super.key, required this.articles}); // Accept articles in the constructor

  @override
  _CommandeDetailsState createState() => _CommandeDetailsState();
}

class _CommandeDetailsState extends State<CommandeDetails> {
  String? selectedCommune;
  String? selectedQuartier;
  String selectedPaymentMethod = 'Aucune méthode sélectionnée'; 
  String selectedPaymentImage = ''; 

  int fraisLivraison = 0; 

  void showErrorDialog(String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: 'Erreur',
    text: message,
  );
}


  void updateFraisLivraison(int frais, String? commune, String? quartier) {
    setState(() {
      fraisLivraison = frais;
      selectedCommune = commune;
      selectedQuartier = quartier;
    });
  }

  void updatePaymentMethod(String method, String image) {
    setState(() {
      selectedPaymentMethod = method;
      selectedPaymentImage = image;
    });
  }

  Future<void> confirmOrder() async {
  // Vérification des champs requis
  if (selectedCommune == null || selectedCommune!.isEmpty) {
    showErrorDialog('Veuillez renseigner votre adresse de livraison.');
    return;
  }

  if (selectedQuartier == null || selectedQuartier!.isEmpty) {
    showErrorDialog('Veuillez renseigner votre adresse de livraison.');
    return;
  }

  if (selectedPaymentMethod == 'Aucune méthode sélectionnée') {
    showErrorDialog('Veuillez sélectionner un mode de paiement.');
    return;
  }

  if (widget.articles.isEmpty) {
    showErrorDialog('Votre panier est vide.');
    return;
  }

  

  // Calcul du sous-total et du total de la commande
  final int sousTotal = widget.articles.fold<int>(0, (sum, item) {
    return sum + (item['price'] as int) * (item['quantity'] as int);
  });

  final int totalCommande = sousTotal + fraisLivraison;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String userId = currentUser?.uid ?? '';

  // Création de la commande
  Commande order = Commande(
    id: '',
    adresse: [selectedCommune ?? '', selectedQuartier ?? ''],
    dateLivraison: DateTime.now(),
    items: widget.articles.map((article) {
      return OrderItem(
        productId: article['productId'],
        price: article['price'],
        quantity: article['quantity'],
        variant: article['variant'],
        status: 'en_cours',
      );
    }).toList(),
    paymentDetails: [
      PaymentDetail(
        method: selectedPaymentMethod,
        sousTotal: sousTotal,
      ),
    ],
    status: 'En attente',
    totalAmount: totalCommande,
    userId: userId,
  );

  try {
    await CommandeService().createCommande(order);
    
  await CartService().clearCart(userId);
  

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      showCancelBtn: false,
      showConfirmBtn: false,
      title: 'Succès',
      text: 'Commande créée avec succès!',
      barrierDismissible: false
    );

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Commandes()),
      );
    });

  } catch (e) {
    showErrorDialog('Erreur lors de la création de la commande: $e');
  }
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
                      onFraisChange: (frais, commune, quartier) {
                        updateFraisLivraison(frais, commune, quartier);
                      },
                    ),
                    PaymentMethodSelector(
                      onPaymentMethodChange: (method, image) {
                        updatePaymentMethod(method, image);
                      },
                    ),
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
                  confirmOrder(); // Appeler la méthode pour créer la commande
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
