import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                'assets/Vector_2646.jpg',
                // fit: BoxFit.,
                opacity: AlwaysStoppedAnimation(0.1),
                width: 1300,
                // height: ,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Row(
                        children: [
                          IconContainerWithTitle(
                            icon: Icons.power_settings_new,
                            title: 'Power off',
                          ),
                          IconContainerWithTitle(
                            icon: Icons.restart_alt,
                            title: 'Restart',
                          ),
                        ],
                      ),
                      TitleTextAndValue(
                        title: 'Network Provider',
                        value: 'MTN-NG',
                        end: true,
                      ),
                      TitleTextAndValue(
                        title: 'Signal Strength',
                        value: '-110dBm',
                        end: true,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                AvatarGlow(
                  endRadius: 100.0,
                  duration: Duration(milliseconds: 2000),
                  showTwoGlows: true,
                  glowColor: AppColor.primary,
                  // animate: false,
                  repeatPauseDuration: Duration(milliseconds: 400),
                  shape: BoxShape.circle,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Container(
                          width: 140,
                          height: 140,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(),
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
                ),
                Spacer(),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(

                //     children: [
                //       Container(
                //         padding:
                //             EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                //         decoration: BoxDecoration(
                //             color: AppColor.container,
                //             borderRadius: BorderRadius.circular(20)),
                //         margin: EdgeInsets.symmetric(horizontal: 3),
                //         child: Column(children: [
                //           Icon(Icons.dail)
                //         ],),
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
                  padding: EdgeInsets.only(bottom: 35, right: 25, left: 25),
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
          ],
        ),
      ),
    );
  }
}
