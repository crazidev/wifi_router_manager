// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:router_manager/components/custom_key_pad.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/controller/ussd_controller.dart';
import 'package:router_manager/core/helper.dart';

import '../../core/app_export.dart';

class UssdScreen extends ConsumerWidget {
  UssdScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var ctr = ref.watch(ussdProvider);
    ref.listen(ussdProvider.select((value) => value.state), (previous, next) {
      if (next == UssdState.completed) {
        Navigator.pop(context);

        showDialog(context: context, builder: (_) => UssdDialog());
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: ctr.ussd,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                    decoration: const InputDecoration(
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
          CustomKeyPad(
            codeLength: null,
            onChange: (value) {
              ctr.ussd.text = value;
              Logger().log(value);
            },
            onComplete: () {},
            otp: ctr.ussdCode,
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // if (textcontroller.text == "") return;
                      Helper().showPreloader(context);
                      if (!ctr.canReply) {
                        await ctr.cancelUSSD();
                      }
                      await ctr.sendUSSD();
                      await ctr.fetchUSSD();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.container,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        fixedSize: const Size(50, 62),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          size: 25,
                        ),
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
                            if (ctr.ussdCode.isNotEmpty) {
                              ctr.ussdCode.removeLast();
                              ctr.ussd.text = ctr.ussdCode.join();
                              Logger().log(ctr.ussdCode);
                            }
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

class UssdDialog extends ConsumerWidget {
  UssdDialog({
    Key? key,
  }) : super(key: key);

  var isLoading = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.read(ussdProvider);
    return AlertDialog(
      backgroundColor: AppColor.bg,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(controller.ussdResponse).marginOnly(bottom: 20),
          if (controller.canReply)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.multiline,
                controller: controller.ussdReply,
                onSubmitted: (value) async {
                  if (controller.ussdReply.text == "") return;
                  Navigator.pop(context);
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
      contentPadding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
      ),
      actionsPadding: const EdgeInsets.only(bottom: 10, right: 5),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.cancelUSSD();
            },
            child: const Text('Close')),
        if (controller.canReply)
          TextButton(
              onPressed: () async {
                if (controller.ussdReply.text == "") return;
                Navigator.pop(context);
                Helper().showPreloader(context);

                await controller.sendUSSD(reply: true);
                await controller.fetchUSSD();
              },
              child: const Text('Reply'))
      ],
    );
  }
}
