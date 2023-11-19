import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/core/custom_navigator.dart';
import 'package:router_manager/core/helper.dart';
import 'package:router_manager/dashhboard_navigator.dart';
import 'package:router_manager/main.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';
import 'package:router_manager/screen/home/stream/home_stream.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authController = ref.watch(authProvider);
    ref.watch(statusStreamProvider);
    ref.listen(authProvider.select((value) => value.isLoggedIn), (prev, next) {
      if (next == true) {
        MyRouter().replace(context, DashboardNavigator());
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Router Manager",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.electrolize(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ).marginOnly(bottom: 10),
            // Text(
            //   "Login to MTN Boardband Device Interface",
            //   textAlign: TextAlign.center,
            //   style: GoogleFonts.lato(
            //     color: AppColor.dim,
            //     fontSize: 18,
            //     // color: AppColor.primary,
            //   ),
            // ).marginOnly(bottom: 20),
            Text(
              authController.lockdown_msg ?? '',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.dim,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Consumer(builder: (context, ref, child) {
                ref.watch(authProvider.select((value) => value.device));

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.dim,
                          child: const Icon(
                            Icons.router_outlined,
                            size: 30,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          ref
                              .read(authProvider)
                              .device
                              .toString()
                              .split('.')
                              .last,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Helper().showBottomsheet(
                              child: SelectDeviceSheet(
                                onSelect: (Device value) {
                                  authController.setDevice(value);
                                },
                              ),
                              context: context);
                        },
                        icon: const Icon(Icons.expand_more))
                  ],
                );
              }),
            ),
            const Gap(20),
            Consumer(
              builder: (context, ref, child) {
                return TextField(
                  autofocus: false,
                  controller: authController.passwordCtr,

                  // canRequestFocus: false,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Password',
                    isDense: true,
                    errorText: authController.errorMsg,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.dim, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColor.primary.withOpacity(0.5), width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: AppColor.container,
                  ),
                  onChanged: (value) {
                    if (authController.errorMsg != null) {
                      authController.errorMsg = null;
                    }
                  },
                ).marginOnly(bottom: 20);
              },
            ),
            if (!authController.disableAuth)
              ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    ref.read(authProvider).isLoggedIn = false;
                    authController.authenticate();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.dim,
                      fixedSize: const Size(double.maxFinite, 50)),
                  child: const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ))
          ],
        ),
      ),
    );
  }
}

class SelectDeviceSheet extends StatelessWidget {
  const SelectDeviceSheet({
    super.key,
    required this.onSelect,
  });

  final ValueChanged<Device> onSelect;

  @override
  Widget build(BuildContext context) {
    List devices = Device.values;

    return Wrap(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: devices
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      onSelect(e);
                      MyRouter().pop(context);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColor.dim,
                                  child: const Icon(
                                    Icons.router_outlined,
                                    size: 30,
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  e.toString().split('.').last,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      )
    ]);
  }
}
