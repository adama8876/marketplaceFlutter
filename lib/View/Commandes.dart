import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Models/commande_model.dart';
import 'package:marketplace_app/Services/commande_service.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketplace_app/View/commandesresume.dart';

class Commandes extends StatelessWidget {
  final CommandeService commandeService = CommandeService();

  Commandes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
          'Mes Commandes',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: user == null
          ? Center(child: Text('Utilisateur non connecté'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<Commande>>(
                stream: commandeService.getUserCommandes(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune commande trouvée.'));
                  }

                  final commandes = snapshot.data!;

                 return ListView.builder(
                    itemCount: commandes.length,
                    itemBuilder: (context, index) {
                      final commande = commandes[index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommandeResumePage(commande: commande),
                                ),
                              );
                            },
                            child: OrderCard(
                              status: commande.status,
                              statusColor: _getStatusColor(commande.status),
                              date: commande.dateLivraison
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                              orderNumber: commande.id,
                            ),
                          ),
                          SizedBox(height: 10), 
                        ],
                      );
                    },
                  );

                },
              ),
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "En attente":
        return Colors.green;
      case "en traitement":
        return Colors.orange;
      case "terminé":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}


class OrderCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String date;
  final String orderNumber;

  const OrderCard({
    Key? key,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.orderNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      status,
                      style: TextStyle(color: statusColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(date),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.confirmation_number, size: 20),
                    const SizedBox(width: 8),
                    Text(orderNumber),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.local_shipping,
              size: 80,
              color: Color.fromARGB(178, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
