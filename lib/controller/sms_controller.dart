import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/main.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';

import '../devices/mtn_mifi.dart';

final smsProvider = ChangeNotifierProvider.autoDispose<SMSNotifier>((ref) {
  return SMSNotifier(ref);
});

class SMSModel {
  final String content;
  final String number;
  final String date;
  final int id;
  final String? groupTag;
  SMSModel({
    required this.id,
    required this.content,
    required this.number,
    required this.date,
    this.groupTag,
  });
}

class SMSNotifier extends ChangeNotifier {
  final Ref ref;
  SMSNotifier(this.ref);

  int sms_unread = 0;

  List<SMSModel>? sms_list;

  fetchSMS() {
    var device = ref.read(authProvider).device;
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).fetchSMS();
    } else {}
  }

  deleteSMS({required int id, bool? all = false}) {
    var device = ref.read(authProvider).device;
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).deleteSMS(id, all: all);
    } else {}
  }
}
