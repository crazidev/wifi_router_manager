import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:router_manager/core/app_export.dart';

class NetworkBar extends StatelessWidget {
  const NetworkBar({
    super.key,
    this.index = 0,
  });

  final int? index;

  @override
  Widget build(BuildContext context) {
    double margin = 4.3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (i) => Container(
          height: () {
            switch (i) {
              case 0:
                return 5.0;
              case 1:
                return 8.0;
              case 2:
                return 12.0;
              case 3:
                return 15.0;
              case 4:
                return 18.0;
            }
          }(),
          width: 3,
          color: i < index! ? AppColor.primary : AppColor.dim,
        ).marginOnly(right: i == 5 ? 0 : margin),
      ),
    );
  }
}
