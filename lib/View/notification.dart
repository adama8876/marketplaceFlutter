
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/Utils/themes.dart';

class Pushnotification extends StatelessWidget {
  const Pushnotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,

        title: Text('Notification', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),
      
    );
  }
}