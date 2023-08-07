// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:router_manager/components/custom_narbar.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/screen/devices/devices.dart';
import 'package:router_manager/screen/home/home_screen.dart';
import 'package:router_manager/screen/sms/sms_screen.dart';

import 'screen/ussd/ussd_screen.dart';

class DashboardNavigator extends StatelessWidget {
  DashboardNavigator({super.key});
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bottomNavBG,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35)),
              child: Obx(() => IndexedStack(
                    index: controller.navIndex.value,
                    children: [
                      HomeScreen(),
                      Devices(),
                      SMSscreen(),
                      UssdScreen(),
                      const Placeholder()
                    ],
                  )),
            ),
          ),
          Obx(
            () => CustomBottomNavBar(
              controller: controller,
              index: controller.navIndex.value,
              onTap: (int value) {
                controller.navIndex.value = value;
              },
            ),
          )
        ],
      ),
    );
  }
}
