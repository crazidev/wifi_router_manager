import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/components/shake_widget.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  AuthController authController = Get.put(AuthController());

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
            SizedBox(height: size.height * 15 / 100),
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
            ).marginOnly(bottom: 40),
            Obx(() => ShakeWidget(
                  child: Text(
                    authController.errorMsg.value,
                    style: TextStyle(color: Colors.red),
                  ),
                )),
            TextField(
              autofocus: false,
              controller: authController.password,
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
                  authController.login();
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => DashboardNavigator()));
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
