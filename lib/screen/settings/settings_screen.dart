import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:router_manager/components/icon_con_with_title.dart';
import 'package:router_manager/core/color_constant.dart';
import 'package:router_manager/core/custom_navigator.dart';
import 'package:router_manager/screen/settings/change_pass.dart';
import 'package:router_manager/screen/settings/performance_screen.dart';
import 'package:router_manager/screen/settings/wifi_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     IconContainerWithTitle(
            //       icon: Icons.flight,
            //       title: 'Flight Mode',
            //       onTap: () {},
            //     ),
            //     IconContainerWithTitle(
            //       icon: Icons.restart_alt,
            //       title: 'Reboot',
            //       onTap: () {},
            //     ),
            //     IconContainerWithTitle(
            //       icon: Ionicons.power,
            //       title: 'Reboot',
            //       onTap: () {},
            //     ),
            //   ],
            // ),
            SettingsTile(
              title: 'Wi-Fi Settings',
              onTap: () {
                MyRouter().to(context, WifiSettingsScreen());
              },
            ),
            SettingsTile(
              title: 'Performance Settings',
              onTap: () {
                MyRouter().to(context, PerformanceScreen());
              },
            ),
            SettingsTile(
              title: 'Change Password',
              onTap: () {
                MyRouter().to(context, ChangePassScreen());
              },
            )
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: AppColor.container,
          iconColor: AppColor.dim,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title),
          onTap: onTap,
          trailing: const Icon(Icons.arrow_right_rounded),
        ),
        Gap(20)
      ],
    );
  }
}
