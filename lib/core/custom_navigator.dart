import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyRouter {
  to(BuildContext context, Widget widget) {
    Navigator.push(
        context, MaterialWithModalsPageRoute(builder: (context) => widget));
  }

  replace(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
        MaterialWithModalsPageRoute(builder: (context) => widget));
  }

  pop(BuildContext context) {
    Navigator.pop(context);
  }
}
