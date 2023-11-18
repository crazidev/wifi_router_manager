import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/app_export.dart';
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

final deviceProvider =
    StateNotifierProvider<DeviceNotifier, ConnectedDevices>((ref) {
  return DeviceNotifier(ref);
});

class NetworkDevice {
  final String mac_addr;
  final String ip_addr;
  String? hostname;
  NetworkDevice({
    required this.mac_addr,
    required this.ip_addr,
    this.hostname,
  });
}

class ConnectedDevices {
  int connected;
  int max;
  List<NetworkDevice>? devices;
  ConnectedDevices({
    this.connected = 0,
    required this.max,
    this.devices,
  });
}

class DeviceNotifier extends StateNotifier<ConnectedDevices> {
  DeviceNotifier(this.ref) : super(ConnectedDevices(max: 0, connected: 0));

  final Ref ref;

  List<NetworkDevice> blockedDevices = [];
  get device => ref.read(authProvider).device;

  set update(value) {
    state.devices = value;
  }

  blockDevices(List value) {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).blockDevices(value);
    } else {}
  }

  unblockDevices(List value) {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).unblockDevices(value);
    } else {}
  }
}
