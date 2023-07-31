import 'package:flutter/material.dart';
import 'package:router_manager/core/app_export.dart';


class TitleTextAndValue extends StatelessWidget {
  const TitleTextAndValue({
    super.key,
    required this.title,
    this.value,
    this.end = false,
  });

  final String title;
  final String? value;
  final bool? end;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          end! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: AppColor.dim),
        ),
        Text(
          value ?? '',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
