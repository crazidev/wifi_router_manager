import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:router_manager/core/app_export.dart';


class StatsContainer extends StatelessWidget {
  const StatsContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final IconData icon;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          color: AppColor.container, borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor.primary,
            size: 20,
          ).paddingOnly(bottom: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: AppColor.primary),
          ).paddingOnly(bottom: 15),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(),
          ).paddingOnly(bottom: 10),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: AppColor.dim),
          )
        ],
      ),
    ));
  }
}
