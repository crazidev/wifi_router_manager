import 'package:avatar_glow/avatar_glow.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:router_manager/components/network_bar.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/app_export.dart';

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
              child: Consumer(
                builder: (context, ref, child) {
                  var bar = ref
                      .read(homeProvider.select((value) => value.networkBar));

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NetworkBar(
                        index: bar.bar_length ?? 0,
                      ).paddingOnly(bottom: 10, top: 10),
                      Text(
                        bar.name != "" ? bar.name! : "offline",
                        style:
                            Theme.of(context).textTheme.labelSmall!.copyWith(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: Consumer(
                builder: (context, ref, child) {
                  var circularDataActive = ref.read(
                      homeProvider.select((value) => value.circularDataActive));
                  return IconButton.filled(
                      enableFeedback: true,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            circularDataActive ? null : AppColor.dim,
                      ),
                      onPressed: () {
                        if (!circularDataActive) {
                          ref.read(homeProvider).toggleCircularNetwork();

                          CherryToast.success(
                            title: Text(
                                'Your router is connected. Welcome back online!'),
                            shadowColor: AppColor.bg,
                            animationType: AnimationType.fromTop,
                            animationDuration: Duration(milliseconds: 700),
                            backgroundColor: AppColor.container,
                          ).show(context);
                        } else {
                          showDialog(
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
                                            ref
                                                .read(homeProvider)
                                                .toggleCircularNetwork();
                                            CherryToast.success(
                                              title: Text(
                                                  'Your router is disconnected, Goodbye for now!'),
                                              shadowColor: AppColor.bg,
                                              animationType:
                                                  AnimationType.fromTop,
                                              animationDuration:
                                                  Duration(milliseconds: 700),
                                              backgroundColor:
                                                  AppColor.container,
                                            ).show(context);
                                          },
                                          child: Text('Proceed'))
                                    ],
                                  ));
                        }
                      },
                      icon: Icon(
                        Icons.wifi_rounded,
                        color: "controller.data_switch" == "1"
                            ? Colors.white
                            : null,
                      ));
                },
              )),
        ],
      ),
    );
  }
}
