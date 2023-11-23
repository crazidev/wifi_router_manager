// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final bool unread;

  final bool? sentFailed;
  final bool? isSent;
  SMSModel({
    required this.content,
    required this.number,
    required this.date,
    required this.id,
    this.unread = false,
    this.sentFailed = false,
    this.isSent = false,
  });
}

enum SMSDeleteType { all, single, group }

class SendSMSModel {
  final String message;
  final String number;
  SendSMSModel({
    required this.message,
    required this.number,
  });
}

class SMSGroupedModel {
  final String number;
  final SMSModel newestSMS;
  final List<SMSModel> smsList;
  SMSGroupedModel({
    required this.number,
    required this.newestSMS,
    required this.smsList,
  });
}

class SMSNotifier extends ChangeNotifier {
  final Ref ref;

  SMSNotifier(this.ref);
  get device => ref.read(authProvider).device;

  int sms_unread = 0;
  int sms_total_count = 0;
  var new_sms_controller = TextEditingController();
  List<SMSModel>? sms_list;
  List<SMSGroupedModel>? sms_grouped_list;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  fetchSMS() {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).fetchSMS();
    } else {}
  }

  deleteSMS(List<SMSModel> sms_list) {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).deleteSMS(sms_list);
    } else {}
  }

  updateReadStatus(List<SMSModel> sms_list) {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).updateReadStatus(sms_list);
    } else {}
  }

  sendSMS(SendSMSModel data) {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).sendSMS(data);
    } else {}
  }
}
