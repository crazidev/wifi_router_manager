import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Helper {
  showBottomsheet({
    required Widget child,
    required BuildContext context,
    Color? backgroundColor,
    bool? isDismisiable = true,
    bool? enableDrag = true,
    bool? expand = false,
  }) {
    if (Platform.isIOS) {
      CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        backgroundColor: backgroundColor,
        isDismissible: isDismisiable,
        enableDrag: enableDrag!,
        expand: expand!,
        builder: (context) => child,
      );
    } else {
      showModalBottomSheet(
          context: context,
          isDismissible: isDismisiable!,
          enableDrag: enableDrag!,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          isScrollControlled: expand!,
          builder: (_) {
            return child;
          });
    }
  }
}
