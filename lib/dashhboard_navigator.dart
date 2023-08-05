// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:router_manager/components/custom_key_pad.dart';
import 'package:router_manager/components/custom_narbar.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/core/helper.dart';
import 'package:router_manager/screen/devices/devices.dart';
import 'package:router_manager/screen/home/home_screen.dart';
import 'package:router_manager/screen/sms/sms_screen.dart';

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
                      ContactScreen(),
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

class ContactScreen extends StatelessWidget {
  ContactScreen({
    super.key,
  });
  var code = [].obs;
  TextEditingController textcontroller = TextEditingController();
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Spacer(),
          Obx(
            () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: textcontroller,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                      decoration: InputDecoration(
                          isDense: true, border: InputBorder.none),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       code.join(),
                    //       style: Theme.of(context).textTheme.displaySmall,
                    //     ),
                    //   ],
                    // ),
                  ],
                )),
          ),
          CustomKeyPad(
            codeLength: null,
            onChange: (value) {
              textcontroller.text = value;
            },
            onComplete: () {},
            otp: code,
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (textcontroller.text == "") return;
                      Helper().showPreloader(context);
                      await controller.sendUSSD(textcontroller.text);
                      await controller.fetchUSSD();
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (_) => UssdDialog(controller: controller));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.container,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        fixedSize: Size(50, 62),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.call,
                          size: 25,
                        ),
                        // Text(
                        //   "USSD",
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .labelSmall!
                        //       .copyWith(),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(left: 170),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if (code.isNotEmpty)
                      IconButton(
                          onPressed: () {
                            code.removeLast();
                            textcontroller.text = code.join();
                          },
                          icon: const Icon(
                            Icons.backspace,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class UssdDialog extends StatelessWidget {
  UssdDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;
  TextEditingController reply = TextEditingController();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.bg,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            controller.ussdRes.trim(),
          ).marginOnly(bottom: 20),
          if (controller.ussd_reply)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                textInputAction: TextInputAction.send,
                controller: reply,
                onSubmitted: (value) async {
                  if (reply.text == "") return;
                  Navigator.pop(context);
                  controller.sendUSSD(reply.text.toString().trim());
                  await controller.fetchUSSD();
                  showDialog(
                      context: controller.context,
                      builder: (_) => UssdDialog(controller: controller));
                },
                decoration: InputDecoration(
                  fillColor: AppColor.bottomNavBG,
                  border: InputBorder.none,
                  filled: true,
                  isDense: true,
                ),
              ),
            ),
        ],
      ),
      contentPadding: EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
      ),
      actionsPadding: EdgeInsets.only(bottom: 10, right: 5),
      actions: [
        TextButton(
            onPressed: () {
              controller.cancelUSSD();
              Navigator.pop(controller.context);
            },
            child: Text('Close')),
        if (controller.ussd_reply)
          TextButton(
              onPressed: () async {
                if (reply.text == "") return;
                Navigator.pop(context);
                controller.sendUSSD(reply.text.toString().trim());
                await controller.fetchUSSD();
                showDialog(
                    context: controller.context,
                    builder: (_) => UssdDialog(controller: controller));
              },
              child: Text('Reply'))
      ],
    );
  }
}
