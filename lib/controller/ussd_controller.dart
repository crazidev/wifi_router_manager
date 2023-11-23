import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/main.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';

import '../core/logger.dart';
import '../devices/mtn_mifi.dart';

final ussdProvider = ChangeNotifierProvider.autoDispose<USSDNotifier>((ref) {
  return USSDNotifier(ref);
});

enum UssdState { empty, sending, fetching, completed }

class USSDNotifier extends ChangeNotifier {
  final Ref ref;
  USSDNotifier(this.ref);

  bool canReply = false;
  String ussdResponse = '';
  bool isLoading = false;

  Enum _state = UssdState.empty;
  Enum get state => _state;
  set state(Enum value) {
    _state = value;
    notifyListeners();
  }

  List _ussdCode = [];
  List get ussdCode => _ussdCode;
  set ussdCode(List value) {
    _ussdCode = value;
    notifyListeners();
  }

  TextEditingController ussd = TextEditingController(text: "*310#");
  TextEditingController ussdReply = TextEditingController();

  fetchUSSD() async {
    var device = ref.read(authProvider).device;
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).fetchUSSDData();
    } else {}
  }

  cancelUSSD() {
    var device = ref.read(authProvider).device;
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).cancleUSSD();
    } else {}
  }

  Future<bool> sendUSSD({bool reply = false}) async {
    var device = ref.read(authProvider).device;
    if (device == Device.MTN_MIFI_4G) {
      await ref
          .read(MifiCtrProvider)
          .sendUSSD(reply ? ussdReply.text : ussd.text, isReply: reply);
      ussdReply.clear();
    } else {}
    return false;
  }
}
