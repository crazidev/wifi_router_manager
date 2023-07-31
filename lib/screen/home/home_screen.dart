import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/core/color_constant.dart';
import 'package:router_manager/components/network_bar.dart';
import 'package:router_manager/components/stats_container.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:router_manager/components/icon_con_with_title.dart';
import 'package:router_manager/components/title_text_and_value.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                      icon: Icons.logout,
                      title: 'Logout',
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
                        // end: true,
                      ).paddingOnly(right: 20),
                      TitleTextAndValue(
                        title: 'Signal Strength',
                        value: '-110dBm',
                        // end: true,
                      ),
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: AppColor.container,
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 10, vertical: 10),
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10))),
                //         child: Column(
                //           children: [
                //             Icon(
                //               Icons.dialpad,
                //               size: 20,
                //             ).paddingOnly(bottom: 5),
                //             Text(
                //               "USSD",
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .labelSmall!
                //                   .copyWith(),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      StatsContainer(
                        icon: SimpleLineIcons.cloud_download,
                        title: 'Download',
                        value: '30.0',
                        subtitle: 'mbps',
                      ),
                      StatsContainer(
                        icon: SimpleLineIcons.screen_desktop,
                        title: 'Connected Devices',
                        value: '20',
                        subtitle: 'Max: 20',
                      ),
                      StatsContainer(
                        icon: SimpleLineIcons.cloud_upload,
                        title: 'Upload',
                        value: '26.1',
                        subtitle: 'mbps',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(bottom: 0, right: 25, left: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleTextAndValue(
                            title: 'IMEL',
                            value: '862624050960255',
                          ),
                          TitleTextAndValue(
                            title: 'IP Address',
                            value: '225.912.92.2',
                            end: true,
                          ),
                        ],
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
}

class NetworkStatusAndSwitcher extends StatelessWidget {
  const NetworkStatusAndSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: 90.0,
      duration: Duration(milliseconds: 2000),
      showTwoGlows: true,
      // animate: false,
      repeatPauseDuration: Duration(milliseconds: 400),
      shape: BoxShape.circle,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Container(
              width: 130,
              height: 130,
              color: AppColor.container,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NetworkBar(
                    index: 2,
                  ).paddingOnly(bottom: 10, top: 10),
                  // Switch(
                  //   value: true,
                  //   onChanged: (value) {},
                  // ),
                  Text(
                    '4G LTD',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: IconButton.filled(
                  enableFeedback: true,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.dim,
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.wifi_rounded))),
        ],
      ),
    );
  }
}
