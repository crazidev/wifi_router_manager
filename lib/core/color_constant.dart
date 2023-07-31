import 'package:flutter/material.dart';

class AppColor {
  static Color bg = fromHex('#010233');
  static Color container = fromHex('#131746');
  static Color bottomNavBG = fromHex('#000129');
  static Color primary = fromHex('#FF4747');
  static Color dim = fromHex('#4A5380');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
