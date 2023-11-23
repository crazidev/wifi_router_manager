// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:router_manager/devices/mtn_mifi.dart';
import 'package:router_manager/main.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';

// ignore_for_file: non_constant_identifier_names
/* cSpell:disable */

final homeProvider = ChangeNotifierProvider.autoDispose<HomeNotifier>((ref) {
  return HomeNotifier(ref);
});

class NNetworkBar {
  final int? bar_length;
  final String? name;

  NNetworkBar({this.bar_length, this.name});
}

class HomeNotifier extends ChangeNotifier {
  final Ref ref;
  HomeNotifier(this.ref);
  get device => ref.read(authProvider).device;

  String? network_provider;
  String? router;
  String? imei;
  NNetworkBar networkBar = NNetworkBar(bar_length: 0, name: '2G');
  String? ipAddress = "";
  String? imel;
  int battery_level = 0;
  bool isCharging = false;
  bool circularDataActive = true;

  (String, String) downloadSpeed = ("0", "kb/s");
  (String, String) uploadSpeed = ("0", "kb/s");

  startStream() async {
    // if (device == Device.MTN_MIFI_4G) {
    ref.read(MifiCtrProvider).fetchData();
    // } else {}
  }

  statusStream() async {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).getStatus();
    } else {}
  }

  toggleCircularNetwork() {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).toggleData();
    } else {}
  }

  reboot() {}
  logout() {}
}
