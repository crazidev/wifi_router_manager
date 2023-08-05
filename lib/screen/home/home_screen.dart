import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/components/icon_con_with_title.dart';
import 'package:router_manager/components/network_bar.dart';
import 'package:router_manager/components/stats_container.dart';
import 'package:router_manager/components/title_text_and_value.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/color_constant.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  void dispose() {
    Get.delete<HomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    homeController.context = context;
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
                    IconContainerWithTitle(
                      icon: Icons.power_settings_new,
                      title: 'Power off',
                    ),
                    IconContainerWithTitle(
                      icon: Icons.restart_alt,
                      title: 'Restart',
                    ),
                    IconContainerWithTitle(
                      icon: Icons.flight,
                      title: 'Flight',
                    ),
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
                                          Navigator.pop(context);
                                          Navigator.pop(context);
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
                        value: 'MTN-NG',
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
                NetworkStatusAndSwitcher(controller: homeController),
                Spacer(),
                GetBuilder(
                    id: 'stats',
                    init: homeController,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            StatsContainer(
                              icon: SimpleLineIcons.cloud_download,
                              title: 'Download',
                              value: homeController.connectedDevices?.dlSpeed
                                      .replaceAll(RegExp('[^0-9.]'), '') ??
                                  "0",
                              subtitle: homeController.connectedDevices?.dlSpeed
                                      .replaceAll(RegExp('[^A-Za-z/]'), '') ??
                                  "kb/s",
                            ),
                            StatsContainer(
                              icon: SimpleLineIcons.screen_desktop,
                              title: 'Connected Devices',
                              value:
                                  '${homeController.connectedDevices?.dhcp_list_info.length ?? 0}',
                              subtitle:
                                  'Max: ${homeController.connectedDevices?.maxNum4 ?? "0"}',
                            ),
                            StatsContainer(
                              icon: SimpleLineIcons.cloud_upload,
                              title: 'Upload',
                              value: homeController.connectedDevices?.ulSpeed
                                      .replaceAll(RegExp('[^0-9.]'), '') ??
                                  "0",
                              subtitle: homeController.connectedDevices?.ulSpeed
                                      .replaceAll(RegExp('[^A-Za-z/]'), '') ??
                                  "kb/s",
                            ),
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, right: 25, left: 25),
                  child: Column(
                    children: [
                      GetBuilder(
                          init: homeController,
                          builder: (context) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TitleTextAndValue(
                                  title: 'IMEL',
                                  value: homeController
                                          .connectedDevices?.module_imei ??
                                      '*************',
                                ),
                                TitleTextAndValue(
                                  title: 'IP Address',
                                  value:
                                      homeController.connectedDevices?.lanIp ??
                                          '***.***.**.**',
                                  end: true,
                                ),
                              ],
                            );
                          }),
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
}

class NetworkStatusAndSwitcher extends StatelessWidget {
  const NetworkStatusAndSwitcher({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        id: 'network_details',
        init: controller,
        builder: (_) {
          return AvatarGlow(
            endRadius: 90.0,
            duration: Duration(milliseconds: 2000),
            showTwoGlows: true,
            glowColor: Colors.white,
            animate: false,
            // animate: controller.data_switch.value == "0" ? false : true,
            repeatPauseDuration: Duration(milliseconds: 400),
            shape: BoxShape.circle,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Container(
                    width: 130,
                    height: 130,
                    color: AppColor.container.withOpacity(.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NetworkBar(
                          index: int.tryParse(
                              controller.networkD?.signal_lvl ?? "0"),
                        ).paddingOnly(bottom: 10, top: 10),
                        Text(
                          controller.data_switch.value == "0"
                              ? "offline"
                              : controller.networkD?.network_type_str ??
                                  'offline',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(),
                        ),
                        // SizedBox(
                        //   width: 40,
                        //   child: FittedBox(
                        //     child: Switch(
                        //       value: controller.data_switch.value == "0"
                        //           ? false
                        //           : true,
                        //       onChanged: (value) {
                        //         controller.data_switch == "0"
                        //             ? controller.toggleDataMode()
                        //             : showDialog(
                        //                 context: context,
                        //                 builder: (_) => CupertinoAlertDialog(
                        //                       content: Text(
                        //                           'Do you want to turn off mobile data?'),
                        //                       actions: [
                        //                         TextButton(
                        //                             onPressed: () {
                        //                               Navigator.pop(context);
                        //                             },
                        //                             child: Text('Cancel')),
                        //                         TextButton(
                        //                             onPressed: () {
                        //                               Navigator.pop(context);
                        //                               controller
                        //                                   .toggleDataMode();
                        //                             },
                        //                             child: Text('Proceed'))
                        //                       ],
                        //                     ));
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    child: IconButton.filled(
                        enableFeedback: true,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.data_switch == "1"
                              ? null
                              : AppColor.dim,
                        ),
                        onPressed: () {
                          controller.data_switch == "0"
                              ? controller.toggleDataMode()
                              : showDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                        content: Text(
                                            'Do you want to turn off mobile data?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                controller.toggleDataMode();
                                              },
                                              child: Text('Proceed'))
                                        ],
                                      ));
                        },
                        icon: Icon(
                          Icons.wifi_rounded,
                          color: controller.data_switch == "1"
                              ? Colors.white
                              : null,
                        ))),
              ],
            ),
          );
        });
  }
}
