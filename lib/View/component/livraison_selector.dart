import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Utils/themes.dart';

class LivraisonSelector extends StatefulWidget {
  final Function(int) onFraisChange; // Fonction de rappel

  const LivraisonSelector({Key? key, required this.onFraisChange}) : super(key: key);

  @override
  _LivraisonSelectorState createState() => _LivraisonSelectorState();
}

class _LivraisonSelectorState extends State<LivraisonSelector> {
  String? selectedCommune;
  String? selectedQuartier;
  int fraisLivraison = 0;

  final Map<String, List<Map<String, dynamic>>> communes = {
    'Commune 1': [
  {'name': 'Banconi', 'frais': 1500},
  {'name': 'Boulkassombougou', 'frais': 1500},
  {'name': 'Djélibougou', 'frais': 1500},
  {'name': 'Doumanzana', 'frais': 1500},
  {'name': 'Fadjiguila', 'frais': 1500},
  {'name': 'Sotuba', 'frais': 1500},
  {'name': 'Korofina Nord', 'frais': 1500},
  {'name': 'Korofina Sud', 'frais': 1500},
  {'name': 'Sikoroni 1', 'frais': 1500},
],
    'Commune 2': [
  {'name': 'Niaréla', 'frais': 1300},
  {'name': 'Bagadadji', 'frais': 1300},
  {'name': 'Médina-coura', 'frais': 1300},
  {'name': 'Bozola', 'frais': 1300},
  {'name': 'Missira', 'frais': 1300},
  {'name': 'Hippodrome', 'frais': 1300},
  {'name': 'Quinzambougou', 'frais': 1300},
  {'name': 'Bakaribougou', 'frais': 1300},
  {'name': 'TSF', 'frais': 1300},
  {'name': 'Zone industrielle', 'frais': 1300},
  {'name': 'Bougouba', 'frais': 1300},
],

    'Commune 3': [
  {'name': 'Darsalam', 'frais': 1200},
  {'name': "N'Tomikorobougou", 'frais': 1200},
  {'name': 'Ouolofobougou-Bolibana', 'frais': 1000},
  {'name': 'Centre commercial', 'frais': 1000},
  {'name': 'Bamako-Coura', 'frais': 1000},
  {'name': 'Bamako-Coura-Bolibana', 'frais': 1000},
  {'name': 'Dravela', 'frais': 1000},
  {'name': 'Dravela-Bolibana', 'frais': 1300},
  {'name': 'Badialan I', 'frais': 1000},
  {'name': 'Badialan II', 'frais': 1000},
  {'name': 'Badialan III', 'frais': 1000},
  {'name': 'Niominanbougou', 'frais': 1800},
  // {'name': 'Sogonifing', 'frais': 1800},
  {'name': 'Samé', 'frais': 2000},
  {'name': 'Sirakoro-Dounfing', 'frais': 2000},
  {'name': 'Koulouba', 'frais': 1500},
  {'name': 'Point G', 'frais': 1500},
  // {'name': 'Kodabougou', 'frais': 1800},
  // {'name': 'Kouliniko', 'frais': 1800},
],

    'Commune 4': [
  {'name': 'Taliko', 'frais': 1500},
  {'name': 'Lassa', 'frais': 1500},
  {'name': 'Sibiribougou', 'frais': 1500},
  {'name': 'Djikoroni-Para', 'frais': 1200},
  {'name': 'Sébénikoro', 'frais': 1200},
  {'name': 'Hamdallaye', 'frais': 1200},
  {'name': 'Lafiabougou', 'frais': 1200},
  {'name': 'Kalabambougou', 'frais': 1500},
],

'Commune 5': [
  {'name': 'Badalabougou', 'frais': 1000},
  // {'name': 'Sema I', 'frais': 1000},
  {'name': 'Quartier Mali', 'frais': 1000},
  {'name': 'Torokorobougou', 'frais': 1000},
  {'name': 'Baco-Djicoroni', 'frais': 1000},
  {'name': 'Sabalibougou', 'frais': 1000},
  {'name': 'Daoudabougou', 'frais': 1000},
  {'name': 'Kalaban-Coura', 'frais': 1500},
],


  'Commune 6': [
  {'name': 'Faladié', 'frais': 1500},
  {'name': 'Banankabougou', 'frais': 1500},
  {'name': 'Sogoniko', 'frais': 1500},
  {'name': 'Dianéguéla', 'frais': 2000},
  {'name': 'Missabougou', 'frais': 2000},
  {'name': 'Niamakoro', 'frais': 1500},
  {'name': 'Soko-rodji', 'frais': 2500},
  {'name': 'Sénou', 'frais': 2500},
  {'name': 'Yirimadio', 'frais': 2000},
  {'name': 'Magnambougou', 'frais': 2000},
],


  };

 @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adresse de livraison',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
             dropdownColor: AppColors.primaryColor,
            value: selectedCommune,
            hint: Text('Sélectionnez une commune', style: TextStyle(color: Colors.white)),
            items: communes.keys.map((commune) {
              return DropdownMenuItem<String>(
                value: commune,
                child: Text(commune, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCommune = value;
                selectedQuartier = null;
                fraisLivraison = 0;
              });
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.primaryColor,
            value: selectedQuartier,
            hint: Text('Sélectionnez un quartier', style: TextStyle(color: Colors.white)),
            items: selectedCommune != null
                ? communes[selectedCommune]!.map((quartier) {
                    return DropdownMenuItem<String>(
                      value: quartier['name'],
                      child: Text(quartier['name'], style: TextStyle(color: Colors.white)),
                    );
                  }).toList()
                : [],
            onChanged: (value) {
              setState(() {
                selectedQuartier = value;
                fraisLivraison = communes[selectedCommune]!
                    .firstWhere((quartier) => quartier['name'] == value)['frais'];
                widget.onFraisChange(fraisLivraison); // Appel de la fonction callback
              });
            },
          ),
        ],
      ),
    );
  }
}
