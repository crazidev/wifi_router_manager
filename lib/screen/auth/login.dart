import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/dashhboard_navigator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 20 / 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Router Manager",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.electrolize(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    // color: AppColor.primary,
                  ),
                ),
              ],
            ).marginOnly(bottom: 10),
            Text(
              "Login to MTN Boardband Device Interface",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: AppColor.dim,
                fontSize: 18,
                // color: AppColor.primary,
              ),
            ).marginOnly(bottom: 70),
            TextField(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: AppColor.container,
              ),
            ).marginOnly(bottom: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardNavigator()));
                },
                child: Text(
                  "Proceed",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.dim,
                    fixedSize: Size(double.maxFinite, 50)))
          ],
        ),
      ),
    );
  }
}
