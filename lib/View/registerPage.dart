import 'package:flutter/material.dart';
import 'package:marketplace_app/Services/auth_service.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/boutiqueregister.dart';
import 'package:marketplace_app/View/component/Validator.dart';
import 'package:marketplace_app/View/connectionpage.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:marketplace_app/services/auth_service.dart'; // Importez votre AuthService

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      String prenom = _prenomController.text;
      String nom = _nomController.text;
      String email = _emailController.text;
      String telephone = _telephoneController.text;
      String password = _passwordController.text;

      bool success = await AuthService().signUp(prenom, nom, email, telephone, password);
      if (success) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Succès',
          text: 'Votre compte a été créé avec succès !',
          showConfirmBtn: false,
          showCancelBtn: false,
        );

        await Future.delayed(const Duration(seconds: 3));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConnectionPage()),
        );
      } else {
        
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erreur',
          text: 'Erreur lors de la création du compte',
          showConfirmBtn: true,
          confirmBtnText: 'OK',
          onConfirmBtnTap: () {
            
            Navigator.pop(context); 
          },
        );
      }
    }
  }

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
                child: Form(
                  key: _formKey, // Utilisation de la clé de formulaire
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      // Prénom
                      TextFormField(
                        controller: _prenomController,
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF033D62),
                          ),
                        ),
                        
                        validator: FormValidators.validatePrenom,
                      ),
                      // Nom
                      TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF033D62),
                          ),
                        ),
                        validator: FormValidators.validateNom,
                      ),
                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF033D62),
                          ),
                        ),
                        validator: FormValidators.validateEmail,
                      ),
                      // Téléphone
                      TextFormField(
                        controller: _telephoneController,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF033D62),
                          ),
                        ),
                        validator: FormValidators.validateTelephone,
                      ),
                      // Mot de passe
                      TextFormField(
                        controller: _passwordController,
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
                        validator: FormValidators.validateMotDePasse,
                      ),
                      // Bouton de création de compte
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: _signup,
                        child: Container(
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
                      ),
                      // Autres éléments de l'interface
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 20),
                          child: Row(
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
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
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
                                    color: Colors.red,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoutiqueRegister(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          backgroundColor: const Color.fromARGB(172, 76, 175, 79),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Voulez-vous créer un compte vendeur ?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
