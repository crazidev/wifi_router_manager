import 'core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:router_manager/screen/home/home_screen.dart';
import 'package:router_manager/components/custom_narbar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.bg,
        colorScheme: ColorScheme.dark(),
      ),
      home: Container(
        color: AppColor.bottomNavBG,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                child: HomeScreen(),
              ),
            ),
            CustomBottomNavBar()
          ],
        ),
      ),
    );
  }
}
