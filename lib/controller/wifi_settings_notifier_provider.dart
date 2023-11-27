// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/devices/mtn_mifi.dart';
import 'package:router_manager/main.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';
import 'package:router_manager/screen/settings/wifi_settings_screen.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

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

  submit() {
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
