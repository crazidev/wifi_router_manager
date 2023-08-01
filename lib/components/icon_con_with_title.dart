import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:router_manager/core/app_export.dart';

class IconContainerWithTitle extends StatelessWidget {
  const IconContainerWithTitle({
    super.key,
    required this.icon,
    this.title,
    this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String? title;
  final Color? iconColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.container,
              fixedSize: const Size(40, 50),
              minimumSize: const Size(50, 50),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
            ],
          ).paddingOnly(bottom: 2),
        ),
        Text(
          title ?? '',
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: AppColor.dim),
        )
      ],
    ).paddingOnly(bottom: 10);
  }
}
