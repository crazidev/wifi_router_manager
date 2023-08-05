import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:router_manager/core/app_export.dart';

class Helper {
  void showPreloader(context, {String? title}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: title != null ? 150 : 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.container,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      title == null
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                      // TextButton(
                      //     onPressed: () {
                      //       Get.back();
                      //     },
                      //     child: Text("Dismise"))
                    ],
                  ),
                ),
              ),
            ));
  }

  void hidePreloader() {
    Get.back();
  }

  void closeKeyboard() {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      print("Keyboard closed");
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

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
