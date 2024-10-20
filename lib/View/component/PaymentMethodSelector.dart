import 'package:flutter/material.dart';
import 'package:marketplace_app/View/component/PaymentMethodDialog.dart';

class PaymentMethodSelector extends StatefulWidget {
  @override
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String selectedPaymentMethod = 'Aucune méthode sélectionnée'; // Méthode par défaut
  String selectedPaymentImage = ''; // Image de la méthode par défaut

  // Affichage du BottomSheet
  void _showPaymentBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PaymentMethodBottomSheet(
          onSelectPayment: (String paymentMethod, String image) {
            setState(() {
              selectedPaymentMethod = paymentMethod;
              selectedPaymentImage = image;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ajoute de l'espace entre le texte et le bouton
              children: [
                Text(
                  'Méthode de paiement',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _showPaymentBottomSheet,
                  child: Text('Changer'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                if (selectedPaymentImage.isNotEmpty)
                  Image.asset(
                    selectedPaymentImage,
                    width: 80,
                    height: 80,
                  ),
                SizedBox(width: 8),
                Text(
                  selectedPaymentMethod,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




