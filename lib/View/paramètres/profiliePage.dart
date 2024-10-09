import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_app/Services/auth_service.dart';
import 'dart:io';
// import 'package:marketplace_app/Services/auth_service.dart'; // Import your AuthService
import 'package:marketplace_app/Utils/themes.dart';
import 'package:marketplace_app/models/user_model.dart';
// import 'package:marketplace_app/Models/user_model.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? _profileImage; // Variable to hold the selected image
  UserModel? _currentUser; // To store the current user information
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Cleanup controllers to avoid memory leaks
  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to fetch user data
  Future<void> _fetchUserData() async {
    _currentUser = await _authService.getUserData();
    if (_currentUser != null) {
      setState(() {
        _prenomController.text = _currentUser!.prenom ?? '';
        _nomController.text = _currentUser!.nom ?? '';
        _emailController.text = _currentUser!.email ?? '';
        _phoneController.text = _currentUser!.telephone ?? '';
        _profileImageUrl = _currentUser!.profileImage; // Récupère l'URL de l'image de profil
      });
    }
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  // Method to handle save action
  Future<void> _saveChanges() async {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showMessage('Veuillez entrer et confirmer votre mot de passe pour enregistrer les modifications.');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage('Les mots de passe ne correspondent pas.');
      return;
    }

    // Réauthentifier l'utilisateur avec le mot de passe saisi
    UserModel user = UserModel(email: _emailController.text, password: _passwordController.text);
    bool authenticated = await _authService.reauthenticateUser(user);

    if (authenticated) {
      // Téléchargement de l'image de profil si elle existe
      String? profileImageUrl;
      if (_profileImage != null) {
        profileImageUrl = await _authService.uploadProfileImage(_profileImage!);
      }

      // Mettre à jour les données de l'utilisateur, y compris l'URL de l'image
      await _authService.updateUserData(
        _emailController.text,
        _prenomController.text,
        _nomController.text,
        _phoneController.text,
        profileImageUrl: profileImageUrl, // Ajoute l'URL de l'image
      );

      _showMessage('Les modifications ont été enregistrées avec succès.');
    } else {
      _showMessage('Mot de passe incorrect. Les modifications n\'ont pas été enregistrées.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Mon profil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) // Affiche l'image sélectionnée
                          : (_profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!) // Affiche l'image de profil à partir de l'URL
                              : AssetImage('assets/images/profile.jpg')) as ImageProvider, // Image par défaut
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // First Name Field
              _buildLabel('Prénom'),
              _buildTextField('Veuillez entrez votre prénom...', _prenomController),

              SizedBox(height: 20),

              // Last Name Field
              _buildLabel('Nom'),
              _buildTextField('Veuillez entrez votre nom...', _nomController),

              SizedBox(height: 20),

              // Email Field
              _buildLabel('Adresse mail'),
              _buildTextField('adama@gmail.com', _emailController, enabled: false),

              SizedBox(height: 20),

              // Phone Number Field
              _buildLabel('Numéro de téléphone'),
              _buildTextField('83938876', _phoneController),

              SizedBox(height: 20),

              // Password Field
              _buildLabel('Mot de passe'),
              _buildTextField('************', _passwordController, obscureText: true),

              SizedBox(height: 20),

              // Confirm Password Field
              _buildLabel('Confirmer mot de passe'),
              _buildTextField('Veuillez entrez votre mdp pour confirmer les changements', _confirmPasswordController, obscureText: true),

              SizedBox(height: 30),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Enregistrer les modifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a label for each input field
  Widget _buildLabel(String labelText) {
    return Text(
      labelText,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  // Method to build a text field
  Widget _buildTextField(String hintText, TextEditingController controller, {bool enabled = true, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
