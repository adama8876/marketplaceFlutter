// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Assurez-vous d'ajouter ce package
import 'package:marketplace_app/Services/user_service.dart';
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/View/component/Validator.dart';
import 'package:quickalert/quickalert.dart';

class BoutiqueRegister extends StatelessWidget {
  const BoutiqueRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const LogoSection(),
                FormSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LogoSection extends StatelessWidget {
  const LogoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // 40% de la hauteur de l'écran
      width: double.infinity,
      color: Colors.transparent, // Fond transparent si nécessaire
      child: Image.asset(
        'assets/images/iconshop1.png', // Assurez-vous que ce chemin est correct
        fit: BoxFit.cover, // L'image prend tout l'espace du Container
      ),
    );
  }
}

class FormSection extends StatefulWidget {
  const FormSection({Key? key}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController boutiqueNomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? profileImage;

  final UserService userService = UserService();

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = image.path; // Update the path of the selected image
      });
    }
  }

  void resetForm() {
    boutiqueNomController.clear();
    emailController.clear();
    telephoneController.clear();
    passwordController.clear();
    descriptionController.clear();
    setState(() {
      profileImage = null; // Réinitialiser l'image de profil
    });
  }

  Future<void> createVendor() async {
    // Effectuer la validation des champs du formulaire
    if (_formKey.currentState?.validate() ?? false) {
      // Vérifier si l'image de profil est sélectionnée
      if (profileImage == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Veuillez sélectionner une image de profil.',
        );
        return;
      }

      // Si tous les champs sont valides, procéder à la création du vendeur
      final success = await userService.createVendor(
        email: emailController.text,
        password: passwordController.text,
        telephone: telephoneController.text,
        boutiqueNom: boutiqueNomController.text,
        description: descriptionController.text,
        profileImage: profileImage!,
      );

      // Gérer le résultat de la création
      if (success) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Votre demande de création de boutique a été envoyée!',
        );
        resetForm();
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Erreur lors de la création de votre boutique. Veuillez réessayer.',
        );
      }
    } else {
      // Si la validation échoue, vous pouvez ajouter un message d'erreur ici si nécessaire
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomTextField(
                controller: boutiqueNomController,
                label: 'Nom de la boutique',
                validator: FormValidators.validateNomBoutique,
              ),
              CustomTextField(
                controller: emailController,
                label: 'Email',
                validator: FormValidators.validateEmail,
              ),
              CustomTextField(
                controller: telephoneController,
                label: 'Téléphone',
                validator: FormValidators.validateTelephone,
              ),
              ExperienceDropdown(),
              CustomTextField(
                controller: passwordController,
                label: 'Mot de passe',
                validator: FormValidators.validateMotDePasse,
                obscureText: true,
                suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
              ),
              CustomTextField(
                controller: descriptionController,
                label: 'Description de la boutique',
                validator: FormValidators.validateDescription,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              // Champ pour sélectionner l'image de profil
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      profileImage == null
                          ? 'Choisir une image de profil'
                          : 'Image choisie: ${profileImage!.split('/').last}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SubmitButton(
                onPressed: createVendor, // Appel de la méthode createVendor
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final int maxLines;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF033D62),
          ),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: validator,
      ),
    );
  }
}

class ExperienceDropdown extends StatelessWidget {
  const ExperienceDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          labelText: 'Années d\'expérience',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF033D62),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 1, child: Text('1 an')),
          DropdownMenuItem(value: 2, child: Text('2 ans')),
          DropdownMenuItem(value: 3, child: Text('3 ans')),
          DropdownMenuItem(value: 4, child: Text('4 ans')),
          DropdownMenuItem(value: 5, child: Text('5 ans ou plus')),
        ],
        onChanged: (value) {
          // Handle dropdown selection
        },
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF033D62), Color(0xFF6EB8D6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: const Center(
          child: Text(
            'Soumettre',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
