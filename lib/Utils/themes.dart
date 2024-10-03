// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Couleur principale
  static const Color primaryColor = Color(0xFF2C3E50); // Bleu foncé

  // Couleur de fond
  static const Color backgroundColor = Color(0xFFDFCACA); // Couleur de fond principale
  static const Color overlayBackgroundColor = Color(0x4D6A6A6A); // Gris avec 30% d'opacité

  // Couleurs supplémentaires
  static const Color textColorPrimary = Color(0xFF212121); // Texte principal - Noir
  static const Color textColorSecondary = Color(0xFF757575); // Texte secondaire - Gris
}

class AppTextStyles {
  // Définir les styles de texte avec la police "Poppins"
  static const TextStyle headline1 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColorPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textColorPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16.0,
    color: AppColors.textColorPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14.0,
    color: AppColors.textColorSecondary,
    fontFamily: 'Poppins',
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Poppins',
  );
}



class AppTheme {
  // Définir le thème principal
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    hintColor: AppColors.primaryColor,
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textColorPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: AppColors.textColorPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: AppColors.textColorSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}


