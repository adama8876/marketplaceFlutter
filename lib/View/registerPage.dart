import 'package:flutter/material.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/connectionpage.dart'; // Importez la page de connexion

class RegScreen extends StatelessWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF033D62),
                  Color.fromARGB(199, 44, 69, 80),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 80, left: 50),
              child: Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    // Prénom
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Prénom',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF033D62),
                        ),
                      ),
                    ),
                    // Nom
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF033D62),
                        ),
                      ),
                    ),
                    // Email
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF033D62),
                        ),
                      ),
                    ),
                    // Téléphone
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Téléphone',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF033D62),
                        ),
                      ),
                    ),
                    // Password
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF033D62),
                        ),
                      ),
                    ),
                    // Confirm Password
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF033D62),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF033D62),
                            Color.fromARGB(199, 44, 69, 80),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'CRÉER UN COMPTE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Vous avez déjà un compte?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Naviguer vers la page de connexion
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConnectionPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Connectez-vous",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            
                          ],

                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                          ElevatedButton(
                                  onPressed: () {
                                    // Action à effectuer lors du clic
                                    print("Bouton cliqué : Voulez-vous créer un compte vendeur ?");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    backgroundColor: Colors.white, // Couleur du bouton
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // Forme arrondie du bouton
                                    ),
                                    // elevation: 5, // Effet d'ombre lors du clic
                                  ),
                                  child: const Text(
                                    'Voulez-vous créer un compte vendeur ?',
                                    style: TextStyle(
                                      fontSize: 16, 
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold 
                                    ),
                                  ),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
