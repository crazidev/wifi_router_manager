import 'dart:io';

import 'package:flutter/foundation.dart';

class Logger {
  log(value, {String? name, bool? isError = false}) {
    if (kDebugMode) {
      if (Platform.isIOS) {
        print('[${name ?? ''}] $value');
      } else
        debugPrint(
            '\x1B[${isError! ? '31m' : '32m'}[${name ?? ''}] $value\x1B[0m');
    }
  }
}
