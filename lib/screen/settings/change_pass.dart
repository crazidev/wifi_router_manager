import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:router_manager/core/color_constant.dart';
import 'package:router_manager/screen/settings/wifi_settings_screen.dart';

class ChangePassScreen extends ConsumerWidget {
  const ChangePassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CustomTextField(
              lableText: 'Current Password',
            ),
            const Gap(15),
            const CustomTextField(
              lableText: 'New Password',
            ),
            const Gap(15),
            const CustomTextField(
              lableText: 'Confirm Password',
            ),
            const Gap(20),
            ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.dim,
                    fixedSize: const Size(double.maxFinite, 50)),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}
