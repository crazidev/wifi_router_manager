import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:router_manager/components/custom_key_pad.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/core/helper.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/screen/sms/sms_screen.dart';
import 'package:router_manager/screen/devices/devices.dart';
import 'package:router_manager/screen/home/home_screen.dart';
import 'package:router_manager/components/custom_narbar.dart';
import 'package:router_manager/controller/home_controller.dart';

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
  TextEditingController textcontroller = TextEditingController(text: "*556#");
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Obx(
            () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          code.join(),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (code.isNotEmpty)
                          IconButton(
                              // splashRadius: 100,
                              // style:
                              //     IconButton.styleFrom(fixedSize: Size(70, 70)),
                              onPressed: () {
                                code.removeLast();
                              },
                              icon: const Icon(
                                Icons.backspace,
                              ))
                      ],
                    )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Helper().showPreloader(context);
                  await controller.sendUSSD(textcontroller.text);
                  await controller.fetchUSSD();
                  controller.cancelUSSD();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.container,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.call,
                      size: 20,
                    ).paddingOnly(bottom: 5),
                    Text(
                      "USSD",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
