import 'package:cloud_firestore/cloud_firestore.dart';

class Commande {
  final String id; 
  final List<String> adresse;
  final DateTime dateLivraison;
  final List<OrderItem> items; 
  final List<PaymentDetail> paymentDetails;
  final String status;
  final int totalAmount;
  final String userId;

  Commande({
    required this.id,
    required this.adresse,
    required this.dateLivraison,
    required this.items,
    required this.paymentDetails,
    required this.status,
    required this.totalAmount,
    required this.userId,
  });

  // Méthode pour convertir l'objet en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'adresse': adresse,
      'dateLivraison': dateLivraison.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
      'paymentDetails': paymentDetails.map((payment) => payment.toMap()).toList(),
      'status': status,
      'totalAmount': totalAmount,
      'userId': userId,
    };
  }

  // Factory pour créer un Order à partir d'un Map et de l'ID
  factory Commande.fromMap(Map<String, dynamic> map, String id) {
    return Commande(
      id: id, // Passer l'ID ici
      adresse: List<String>.from(map['adresse']),
      dateLivraison: DateTime.parse(map['dateLivraison']),
      items: List<OrderItem>.from(map['items'].map((item) => OrderItem.fromMap(item))),
      paymentDetails: List<PaymentDetail>.from(map['paymentDetails'].map((payment) => PaymentDetail.fromMap(payment))),
      status: map['status'],
      totalAmount: map['totalAmount'],
      userId: map['userId'],
    );
  }
}

// Modèle pour les items de commande
class OrderItem {
  final String productId;
  final String? variant; 
  final int price;
  final int quantity;
  final String status;

  OrderItem({
    required this.productId,
    required this.price,
     this.variant,
    required this.quantity,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'variant': variant, 
      'price': price,
      'quantity': quantity,
      'status': status,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      variant: map['variant'],
      price: map['price'],
      quantity: map['quantity'],
      status: map['status'],
    );
  }
}

// Modèle pour les détails de paiement
class PaymentDetail {
  final String method;
  final int sousTotal;

  PaymentDetail({
    required this.method,
    required this.sousTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'sousTotal': sousTotal,
    };
  }

  factory PaymentDetail.fromMap(Map<String, dynamic> map) {
    return PaymentDetail(
      method: map['method'],
      sousTotal: map['sousTotal'],
    );
  }
}
