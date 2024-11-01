import 'package:flutter/material.dart';
import 'package:marketplace_app/View/component/PaymentMethodDialog.dart';

class PaymentMethodSelector extends StatefulWidget {
  final Function(String, String) onPaymentMethodChange; // Callback pour renvoyer la méthode de paiement sélectionnée

  const PaymentMethodSelector({Key? key, required this.onPaymentMethodChange}) : super(key: key); // Ajout du callback dans le constructeur

  @override
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String selectedPaymentMethod = 'Aucune méthode sélectionnée'; 
  String selectedPaymentImage = ''; 
  String? phoneNumber; 
  bool showPhoneInput = false;

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
              showPhoneInput = (paymentMethod == 'Orange Money' || paymentMethod == 'Sama Money');
            });
            widget.onPaymentMethodChange(paymentMethod, image); // Appel du callback pour envoyer les données
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            if (showPhoneInput) // Affichage du champ téléphone si nécessaire
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
