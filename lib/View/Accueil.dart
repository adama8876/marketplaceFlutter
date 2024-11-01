// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:marketplace_app/View/Homepage.dart';
import 'package:marketplace_app/View/bottomnavbar.dart';
import 'package:marketplace_app/View/categorie.dart';
import 'package:marketplace_app/View/favoris.dart';
import 'package:marketplace_app/View/notification.dart';
import 'package:marketplace_app/View/userinfo.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Homepage(),
    Categorie(),
    Favoris(),
    // Pushnotification(),
    Userinfo()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
