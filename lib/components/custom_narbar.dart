import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:router_manager/controller/home_controller.dart';

import '../core/app_export.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final HomeController controller;

  CustomBottomNavBar({
    this.index = 0,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: AppColor.bottomNavBG,
      selectedItemColor: AppColor.primary,
      unselectedItemColor: AppColor.dim,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Icon(FontAwesome.dashboard),
            ),
            label: ''),
        BottomNavigationBarItem(icon: Icon(Ionicons.link), label: ''),
        BottomNavigationBarItem(
            icon: Obx(() => Badge(
                  label: Text(controller.sms_unread.value),
                  isLabelVisible:
                      controller.sms_unread.value == "0" ? false : true,
                  child: Icon(Ionicons.chatbubble_ellipses),
                )),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(FontAwesome.address_book), label: ''),
        BottomNavigationBarItem(icon: Icon(SimpleLineIcons.settings), label: '')
      ],
      onTap: (index) {
        onTap(index);
      },
      currentIndex: index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
