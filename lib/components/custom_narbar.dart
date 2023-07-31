import 'package:get/get.dart';
import '../core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  CustomBottomNavBar({
    this.index = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: AppColor.bottomNavBG,
      selectedItemColor: AppColor.primary,
      unselectedItemColor: AppColor.dim,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Icon(FontAwesome.dashboard),
            ),
            label: ''),
        BottomNavigationBarItem(icon: Icon(Ionicons.link), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Ionicons.chatbubble_ellipses), label: ''),
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
