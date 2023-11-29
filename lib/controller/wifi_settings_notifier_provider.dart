// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:router_manager/devices/mtn_mifi.dart';
import 'package:router_manager/main.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';
import 'package:router_manager/screen/settings/wifi_settings_screen.dart';

enum SecurityMode { open, wpa2, wpa_psk_wpa2 }

class WifiSettingsModel {
  final String? SSID;
  final SecurityMode securityMode;
  final String? password;
  final int? maxConnection;

  WifiSettingsModel({
    this.SSID,
    required this.securityMode,
    this.password,
    this.maxConnection,
  });
}

final WifiSettingsNotifierProvider =
    ChangeNotifierProvider<WifiSettingsNotifier>((ref) {
  return WifiSettingsNotifier(ref);
});

class WifiSettingsNotifier extends ChangeNotifier {
  final Ref ref;
  WifiSettingsNotifier(this.ref);

  TextEditingController networkName = TextEditingController();
  TextEditingController mode = TextEditingController();
  TextEditingController maxConnection = TextEditingController();
  TextEditingController password = TextEditingController();
  WifiSettingsModel? data;

  fetch() {
    var device = ref.read(authProvider).device;
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).fetchUSSDData();
    } else {}
  }

  @override
  void dispose() {
    // Dispose of TextEditingController instances when the notifier is disposed.
    networkName.dispose();
    mode.dispose();
    maxConnection.dispose();
    password.dispose();
    super.dispose();
  }
}
