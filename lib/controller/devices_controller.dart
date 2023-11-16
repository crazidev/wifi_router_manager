import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/devices/mtn_mifi.dart';
import 'package:router_manager/main.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';

final fetchBlockDevicesProvider =
    FutureProvider.autoDispose<List<NetworkDevice>>((ref) async {
  var device = ref.read(authProvider).device;
  if (device == Device.MTN_MIFI_4G) {
    return await ref.read(MifiCtrProvider).fetchBlockedDevices();
  } else {}

  return [];
});
