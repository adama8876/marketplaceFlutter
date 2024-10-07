// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:marketplace_app/Services/auth_service.dart';
import 'package:marketplace_app/Utils/themes.dart';
// import 'package:marketplace_app/View/Accueil.dart';
import 'package:marketplace_app/View/connectionpage.dart';
import 'package:marketplace_app/View/param%C3%A8tres/privacyPolicy.dart';
import 'package:marketplace_app/View/param%C3%A8tres/profiliePage.dart';

class Userinfo extends StatefulWidget {
  const Userinfo({Key? key}) : super(key: key);

  @override
  _UserinfoState createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  final AuthService _authService = AuthService();
  String? _prenom;
  String? _nom;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

 Future<void> _fetchUserData() async {
  var user = await _authService.getUserData();
  print('Fetched user: ${user?.prenom}, ${user?.nom}, ${user?.profileImage}'); // Debugging line
  setState(() {
    _prenom = user?.prenom;
    _nom = user?.nom;
    _profileImageUrl = user?.profileImage; // Récupère l'URL de l'image de profil
  });
}


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[30],
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Paramètres',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                                      onTap: () {
                                        if (_profileImageUrl != null) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              backgroundColor: Colors.transparent,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  child: Image.network(
                                                    _profileImageUrl!,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: _profileImageUrl != null
                                            ? NetworkImage(_profileImageUrl!) // Affiche l'image de profil à partir de l'URL
                                            : AssetImage('assets/images/profile.jpg') as ImageProvider, // Image par défaut
                                      ),
                                    ),


                  SizedBox(height: 10),
                  Text(
                        '${_prenom ?? 'Prénom'} ${_nom ?? 'Nom'}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSettingsButton(
                  context,
                  icon: Icons.person,
                  text: 'Mon profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                _buildSettingsButton(
                  context,
                  icon: Icons.lock,
                  text: 'Poli & confi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                    );
                  },
                ),
                _buildSettingsButton(
                  context,
                  icon: Icons.shopping_cart,
                  text: 'Mes commandes',
                  onTap: () {
                    // Navigate to orders page
                  },
                ),
                _buildSettingsButton(
                  context,
                  icon: Icons.notifications,
                  text: 'Notifications',
                  onTap: () {
                    // Navigate to notifications page
                  },
                ),
                _buildSettingsButton(
                  context,
                  icon: Icons.logout,
                  text: 'Se déconnecter',
                  onTap: () async {
                    try {
                      // Call the logout method from AuthService
                      await AuthService().signOut();

                      // Navigate to the login page after logout
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConnectionPage()),
                    );
                    } catch (e) {
                      print('Error during sign out: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context,
      {required IconData icon, required String text, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey[400],
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
