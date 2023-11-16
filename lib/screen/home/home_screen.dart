import 'package:avatar_glow/avatar_glow.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/components/icon_con_with_title.dart';
import 'package:router_manager/components/network-status-swither.dart';
import 'package:router_manager/components/network_bar.dart';
import 'package:router_manager/components/stats_container.dart';
import 'package:router_manager/components/title_text_and_value.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/color_constant.dart';
import 'package:router_manager/core/custom_navigator.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';
import 'package:router_manager/screen/auth/login.dart';
import 'package:router_manager/screen/home/stream/home_stream.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

late BuildContext homeScreenContext;

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int mapBatteryPercentageToLevel(int batteryPercentage) {
    // Ensure the battery percentage is within the valid range [0, 100]
    batteryPercentage = batteryPercentage.clamp(0, 100);

    // Map the battery percentage to a level between 1 and 5
    return ((batteryPercentage / 100) * 10).ceil();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(homeStreamProvider);
    homeScreenContext = context;
    var ctr = ref.watch(homeProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/Vector_2646.jpg',
              // fit: BoxFit.,
              opacity: AlwaysStoppedAnimation(0.2),
              width: 1300,
              // height: ,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconContainerWithTitle(
                    //   icon: Icons.power_settings_new,
                    //   title: 'Power off',
                    // ),
                    IconContainerWithTitle(
                      icon: () {
                        return FindPercentage(ctr);
                      }(),
                      titleInside: '${ctr.battery_level}%',
                      title: '',
                      onTap: () {},
                    ),
                    IconContainerWithTitle(
                      icon: Icons.restart_alt,
                      title: 'Reboot',
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  content:
                                      Text('Do you want to reboot the device?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          CherryToast.success(
                                            title: Text(
                                                'Rebooting, please wait...'),
                                            shadowColor: AppColor.bg,
                                            animationType:
                                                AnimationType.fromTop,
                                            animationDuration:
                                                Duration(milliseconds: 700),
                                            backgroundColor: AppColor.container,
                                          ).show(context);
                                        },
                                        child: Text('Reboot'))
                                  ],
                                ));
                      },
                    ),
                    // IconContainerWithTitle(
                    //   icon: Icons.flight,
                    //   title: 'Flight',
                    // ),
                    IconContainerWithTitle(
                      icon: Ionicons.log_out_outline,
                      title: 'Logout',
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  content: Text('Do you want to logout?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          ref.read(authProvider).isLoggedIn =
                                              false;
                                          MyRouter().removeAll(
                                              context, LoginScreen());
                                        },
                                        child: Text('Logout'))
                                  ],
                                ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      TitleTextAndValue(
                        title: 'Network Provider',
                        value: ctr.network_provider,
                        end: true,
                      )
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 80),
                  child: Text(
                    "MTN Boardband\n4G Router",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.electrolize(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // color: AppColor.primary,
                    ),
                  ),
                ),
                NetworkStatusAndSwitcher(),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      StatsContainer(
                        icon: SimpleLineIcons.cloud_download,
                        title: 'Download',
                        value: ctr.downloadSpeed.$1,
                        subtitle: ctr.downloadSpeed.$2,
                      ),
                      StatsContainer(
                        icon: SimpleLineIcons.screen_desktop,
                        title: 'Connected Devices',
                        value: '${ctr.devices.connected}',
                        subtitle: 'Max: ${ctr.devices.max}',
                      ),
                      StatsContainer(
                        icon: SimpleLineIcons.cloud_upload,
                        title: 'Upload',
                        value: ctr.uploadSpeed.$1,
                        subtitle: ctr.uploadSpeed.$2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, right: 25, left: 25),
                  child: Column(
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleTextAndValue(
                                title: 'IMEL',
                                value: ctr.imei ?? '*************',
                              ),
                              TitleTextAndValue(
                                title: 'IP Address',
                                value: ctr.ipAddress ?? '***.***.**.**',
                                end: true,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData FindPercentage(HomeNotifier ctr) {
    return switch (mapBatteryPercentageToLevel(ctr.battery_level)) {
      2 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_20
          : MaterialCommunityIcons.battery_20,
      3 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_30
          : MaterialCommunityIcons.battery_30,
      4 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_40
          : MaterialCommunityIcons.battery_40,
      5 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_50
          : MaterialCommunityIcons.battery_50,
      6 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_60
          : MaterialCommunityIcons.battery_60,
      7 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_70
          : MaterialCommunityIcons.battery_70,
      8 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_80
          : MaterialCommunityIcons.battery_80,
      9 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_90
          : MaterialCommunityIcons.battery_90,
      10 => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_high
          : MaterialCommunityIcons.battery_high,
      _ => ctr.isCharging
          ? MaterialCommunityIcons.battery_charging_10
          : MaterialCommunityIcons.battery_10
    };
  }
}
