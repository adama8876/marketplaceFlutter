import 'package:flutter/material.dart';


class PaymentMethodBottomSheet extends StatelessWidget {
  final Function(String, String) onSelectPayment;

  PaymentMethodBottomSheet({required this.onSelectPayment});

   final List<Map<String, String>> paymentMethods = [
     {
      'name': 'Paiement à la livraison',
      'image': 'assets/images/livraison.png',
    },
    {
      'name': 'Orange Money',
      'image': 'assets/images/orangemoney.png',
    },
    {
      'name': 'PayPal',
      'image': 'assets/images/paypal.png',
    },

    {
      'name': 'Sama Money',
      'image': 'assets/images/sama.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300, // Fixe la hauteur du BottomSheet
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sélectionnez une méthode de paiement',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      method['image'] ?? '',
                      width: 80,
                      height: 80,
                    ),
                    title: Text(method['name'] ?? 'Méthode inconnue'),
                    onTap: () {
                      onSelectPayment(method['name'] ?? 'Méthode inconnue', method['image'] ?? '');
                      Navigator.of(context).pop(); // Ferme le BottomSheet
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
