import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:router_manager/core/color_constant.dart';
import 'package:router_manager/screen/settings/wifi_settings_screen.dart';

class PerformanceScreen extends ConsumerWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List ranges = [
      "Short Wi-Fi Range",
      "Medium Wi-Fi Range",
      "Long Wi-Fi Range"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              children: ranges
                  .map(
                    (e) => RadioListTile(
                        value: '',
                        groupValue: '',
                        contentPadding: EdgeInsets.zero,
                        title: Text(e),
                        onChanged: (e) {}),
                  )
                  .toList(),
            ),
            Gap(20),
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
