// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:marketplace_app/Services/favoris_service.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late FavoriteService _favoriteService;
  late Stream<int> _favoriteCountStream;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService();

    
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _favoriteCountStream = _favoriteService.getFavoriteCount(_currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF2C3E50),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: 'Categorie',
        ),
        BottomNavigationBarItem(
          icon: _currentUser != null
              ? StreamBuilder<int>(
                  stream: _favoriteCountStream,
                  builder: (context, snapshot) {
                    int favoriteCount = snapshot.data ?? 0;
                    return badges.Badge(
                      badgeContent: Text(
                        favoriteCount.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      showBadge: favoriteCount > 0,
                      child: Icon(Icons.favorite),
                    );
                  },
                )
              : Icon(Icons.favorite), 
          label: 'Favoris',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.receipt_long),
        //   label: 'Notification',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Paramètres',
        ),
      ],
    );
  }
}
