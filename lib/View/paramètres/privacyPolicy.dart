import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Utils/themes.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Politique de confidentialité',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Introduction
            _buildSectionHeader('Introduction', Icons.info),
            _buildSectionContent(
              'Bienvenue sur Baikasugu! Votre confidentialité est importante pour nous. '
              'Cette politique explique comment nous collectons, utilisons et protégeons vos données personnelles.',
            ),
            SizedBox(height: 20),

            // Section 2: Informations que Nous Collectons
            _buildSectionHeader('Informations que Nous Collectons', Icons.person),
            _buildSectionContent(
              'Nous collectons les informations suivantes :\n'
              '• Informations personnelles: nom, adresse e-mail, numéro de téléphone.\n'
              '• Données de paiement: traitées de manière sécurisée.\n'
              '• Données de navigation: adresse IP, cookies pour améliorer l’expérience utilisateur.',
            ),
            SizedBox(height: 20),

            // Section 3: Utilisation des Informations
            _buildSectionHeader('Utilisation des Informations', Icons.verified_user),
            _buildSectionContent(
              'Les informations collectées sont utilisées pour :\n'
              '• Fournir et améliorer nos services.\n'
              '• Traiter les transactions et envoyer des notifications.\n'
              '• Personnaliser l\'expérience utilisateur.\n'
              '• Protéger les utilisateurs et prévenir les fraudes.',
            ),
            SizedBox(height: 20),

            // Section 4: Partage des Informations
            _buildSectionHeader('Partage des Informations', Icons.share),
            _buildSectionContent(
              'Vos informations ne sont jamais vendues. Elles peuvent être partagées uniquement dans les cas suivants :\n'
              '• Avec des fournisseurs de services (paiement, livraison).\n'
              '• Conformité légale.\n'
              '• Transactions commerciales (fusion, acquisition).',
            ),
            SizedBox(height: 20),

            // Section 5: Sécurité des Données
            _buildSectionHeader('Sécurité des Données', Icons.security),
            _buildSectionContent(
              'Nous utilisons des mesures de sécurité avancées pour protéger vos informations. Cependant, aucune méthode n’est totalement sécurisée.',
            ),
            SizedBox(height: 20),

            // Section 6: Vos Droits
            _buildSectionHeader('Vos Droits', Icons.privacy_tip),
            _buildSectionContent(
              'Vous avez le droit de :\n'
              '• Accéder, corriger ou supprimer vos données.\n'
              '• Retirer votre consentement à tout moment.',
            ),
            SizedBox(height: 20),

            // Section 7: Contactez-Nous
            _buildSectionHeader('Contactez-Nous', Icons.contact_mail),
            _buildSectionContent(
              'Pour toute question, contactez-nous à :\n'
              '[Baikasugu.com]\n'
              '[Bamako, Hamdallaye ACI 2000]\n'
              '[baikasugu@gmail.com]\n'
              '[+223 83938876]',
            ),
            SizedBox(height: 30),

            // Action Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Accepter et Continuer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build section headers with icons
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Method to build section content
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 16,
        color: const Color.fromARGB(169, 0, 0, 0),
        height: 1.5,
      ),
    );
  }
}
