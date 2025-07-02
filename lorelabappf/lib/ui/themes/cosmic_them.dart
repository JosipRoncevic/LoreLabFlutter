import 'package:flutter/material.dart';

class CosmicTheme {
  // Colors
  static const Color deepSpace = Color(0xFF0B0C1A);
  static const Color cosmicPurple = Color(0xFF2D1B69);
  static const Color starWhite = Color(0xFFF8FAFC);
  static const Color galaxyPink = Color(0xFFEC4899);
  static const Color deleteRed = Color.fromARGB(255, 224, 5, 5);
  static const Color editGreen = Color.fromARGB(255, 0, 166, 8);
  static const Color characterBlue = Color.fromARGB(255, 32, 209, 249);
  
  // Simple gradient for backgrounds
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF0B0C1A),
    ],
  );

  // Galaxy image background
  static BoxDecoration backgroundImageDecoration = const BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/icon/galaxy_image.png"),
      fit: BoxFit.cover,
    ),
  );

//Logo path
 static const String logoAsset = "assets/icon/logo.png";

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 250, 231, 22),
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: starWhite,
  );

  // Theme Data
  static ThemeData get themeData => ThemeData(
    primaryColor: cosmicPurple,
    scaffoldBackgroundColor: deepSpace,
    appBarTheme: AppBarTheme(
      backgroundColor: cosmicPurple,
      foregroundColor: starWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headingStyle,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: deepSpace,
      selectedItemColor: galaxyPink,
      unselectedItemColor: starWhite.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: galaxyPink,
      foregroundColor: starWhite,
    ),
    textTheme: TextTheme(
      headlineLarge: headingStyle,
      bodyLarge: bodyStyle,
    ),
  );

  // Background decoration
  static BoxDecoration get backgroundDecoration => BoxDecoration(
    gradient: backgroundGradient,
  );

  // List item card decoration
  static BoxDecoration get listItemDecoration => BoxDecoration(
    color: cosmicPurple.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: galaxyPink.withOpacity(0.2),
      width: 5,
    ),
    boxShadow: [
      BoxShadow(
        color: cosmicPurple.withOpacity(0.2),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get listItemDecoration2 => BoxDecoration(
    color: cosmicPurple.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color.fromARGB(255, 32, 209, 249).withOpacity(0.2),
      width: 5,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 6, 12, 126).withOpacity(0.2),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );
    static BoxDecoration get listItemDecoration3 => BoxDecoration(
    color: cosmicPurple.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color.fromARGB(255, 188, 251, 30).withOpacity(0.2),
      width: 5,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 7, 149, 25).withOpacity(0.2),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  // List item text style
  static const TextStyle listTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: starWhite,
  );

  static const TextStyle listSubtitleStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFFE2E8F0),
  );
}