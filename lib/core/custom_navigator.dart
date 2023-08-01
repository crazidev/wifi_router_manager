import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyRouter {
  to(BuildContext context, Widget widget) {
    // Get.to(() => widget);
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => widget,
    ));
  }

  replace(BuildContext context, Widget widget) {
    // Get.to(() => Contain);
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }

  removeAll(BuildContext context, Widget widget) {
    // Get.to(() => widget);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }

  pop(BuildContext context) {
    Navigator.pop(context);
  }
}
