import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:router_manager/controller/devices_controller.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/controller/sms_controller.dart';

import '../core/app_export.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final int index;
  final ValueChanged<int> onTap;
  // final HomeController controller;

  CustomBottomNavBar({
    this.index = 0,
    required this.onTap,
    // required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var ctr = ref.watch(homeProvider);

    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: AppColor.bottomNavBG,
      selectedItemColor: AppColor.primary,
      unselectedItemColor: AppColor.dim,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Icon(FontAwesome.dashboard)),
            label: ''),
        BottomNavigationBarItem(
            icon: Badge(
                label: Text('${ctr.devices.connected}'),
                isLabelVisible: true,
                child: const Icon(Ionicons.link)),
            label: ''),
        BottomNavigationBarItem(
            icon: Badge(
                label: Text(ctr.sms_unread.toString()),
                isLabelVisible: ctr.sms_unread == "0" ? false : true,
                child: const Icon(Ionicons.chatbubble_ellipses)),
            label: ''),
        const BottomNavigationBarItem(
            icon: Icon(Ionicons.keypad_outline), label: ''),
        const BottomNavigationBarItem(
            icon: Icon(SimpleLineIcons.settings), label: '')
      ],
      onTap: (index) {
        if (index == 2) {
          ref.read(smsProvider).fetchSMS();
        }

        if (index == 1) {
          ref.invalidate(fetchBlockDevicesProvider);
        }
        onTap(index);
      },
      currentIndex: index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
