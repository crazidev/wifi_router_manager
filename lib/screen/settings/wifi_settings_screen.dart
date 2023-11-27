// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';

import 'package:router_manager/core/color_constant.dart';

import '../../controller/wifi_settings_notifier_provider.dart';

class WifiSettingsScreen extends ConsumerWidget {
  const WifiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var ctr = ref.watch(WifiSettingsNotifierProvider);
    List securityMode = ["Open", "WPA2(AES)-PSK", "WPA-PSK/WPA2-PSK"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wi-Fi Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              lableText: 'Network Name (SSID)',
              controller: ctr.networkName,
            ),
            const Gap(20),
            CustomTextField(
              lableText: 'Security Mode',
              readOnly: true,
              controller: ctr.mode,
              suffix: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: AppColor.bg,
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => CBottomSheet(
                              title: 'Security Mode',
                              child: Column(
                                children: securityMode
                                    .map((e) => CListTIle(
                                          title: e,
                                          onTap: () {
                                            ref
                                                .read(
                                                    WifiSettingsNotifierProvider)
                                                .mode
                                                .text = e;
                                            Navigator.pop(context);
                                          },
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.arrow_drop_down)),
            ),
            const Gap(20),
            CustomTextField(
              lableText: 'Max Station Number',
              controller: ctr.maxConnection,
              keyboardType: TextInputType.number,
            ),
            const Gap(20),
            CustomTextField(
              lableText: 'Password',
              controller: ctr.password,
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

class CListTIle extends StatelessWidget {
  const CListTIle({
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
          dense: true,
          title: Text(title),
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tileColor: AppColor.container,
          trailing: const Icon(Icons.arrow_right_rounded),
          iconColor: AppColor.dim,
        ),
        const Gap(10)
      ],
    );
  }
}

class CBottomSheet extends StatelessWidget {
  const CBottomSheet({
    super.key,
    this.title,
    this.desc,
    required this.child,
  });

  final String? title;
  final String? desc;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  '$title',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              if (desc != null)
                Text(
                  '$desc',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.grey),
                ),
              const Gap(20),
              child
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.required = false,
      this.lableText,
      this.hintText,
      this.onTap,
      this.controller,
      this.prefix,
      this.suffix,
      this.enabled = true,
      this.readOnly = false,
      this.keyboardType})
      : super(key: key);

  final bool required;
  final String? lableText;
  final String? hintText;
  final Function()? onTap;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (lableText != null) ...[
              Text(
                lableText ?? '',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500, color: AppColor.primary),
              ),
              if (required)
                Text(
                  'Required',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.red),
                ),
            ]
          ],
        ),
        const Gap(2),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintText: hintText,
              suffixIcon: suffix,
              prefixIcon: prefix,
              fillColor: AppColor.container,
            ),
          ),
        ),
      ],
    );
  }
}
