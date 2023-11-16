// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:router_manager/components/custom_narbar.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/controller/sms_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/screen/devices/devices.dart';
import 'package:router_manager/screen/home/home_screen.dart';
import 'package:router_manager/screen/sms/sms_screen.dart';
import 'package:router_manager/screen/ussd/ussd_screen.dart';

final pageIndexProvider = StateNotifierProvider<pageIndexNotifier, int>((ref) {
  return pageIndexNotifier();
});

class pageIndexNotifier extends StateNotifier<int> {
  pageIndexNotifier() : super(0);

  update(value) {
    state = value;
  }
}

class DashboardNavigator extends ConsumerWidget {
  const DashboardNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(pageIndexProvider);

    return Container(
      color: AppColor.bottomNavBG,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                child: IndexedStack(
                  index: index,
                  children: [
                    HomeScreen(),
                    Devices(),
                    SMSscreen(),

                    // const Placeholder(),

                    UssdScreen(),
                    const Placeholder()
                  ],
                )),
          ),
          CustomBottomNavBar(
            index: index,
            onTap: (int value) {
              ref.read(pageIndexProvider.notifier).update(value);
            },
          )
        ],
      ),
    );
  }
}
