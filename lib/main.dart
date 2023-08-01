import 'package:get/get.dart';
import 'core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/screen/auth/login.dart';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle defaultFont = GoogleFonts.josefinSans();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.bg,
        colorScheme: ColorScheme.dark(),
        textTheme: TextTheme(
          labelSmall: defaultFont,
          labelMedium: defaultFont,
          labelLarge: defaultFont,
          bodySmall: defaultFont,
          bodyMedium: defaultFont,
          bodyLarge: defaultFont,
          titleSmall: defaultFont,
          titleMedium: defaultFont,
          titleLarge: defaultFont,
          headlineSmall: defaultFont,
          headlineMedium: defaultFont,
          headlineLarge: defaultFont,
        ),
      ),
      home: Container(color: AppColor.bottomNavBG, child: LoginScreen()),
    );
  }
}
