import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:router_manager/core/app_export.dart';


class IconContainerWithTitle extends StatelessWidget {
  const IconContainerWithTitle({
    super.key,
    required this.icon,
    this.title,
  });

  final IconData icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColor.container,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              IconButton(splashRadius: 100, onPressed: () {}, icon: Icon(icon)),
            ],
          ),
        ).paddingOnly(bottom: 5),
        Text(
          title ?? '',
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: AppColor.dim),
        )
      ],
    ).paddingOnly(right: 10);
  }
}
