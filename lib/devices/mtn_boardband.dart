import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/controller/devices_controller.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';

final BoardBandCtrProvider =
    ChangeNotifierProvider<BOARDBAND_CONTROLLER>((ref) {
  return BOARDBAND_CONTROLLER(ref);
});

class BOARDBAND_CONTROLLER extends ChangeNotifier {
  final Ref ref;
  String endpoint = 'http://192.168.0.1/cgi-bin/http.cgi';
  BOARDBAND_CONTROLLER(this.ref);

  String get sessionID => ref.read(authProvider).authToken ?? '';

  fetchAll() {}

  fetchNetworkDetails() async {
    ApiClient(endpoint).postData(
        {"cmd": 113, "method": "GET", "sessionId": sessionID},
        printLogs: false).then((value) {
      // if (networkD.toString() != NetworkDModel.fromMap(value.data).toString()) {
      //   networkD = NetworkDModel.fromMap(value.data);

      // }
    });
  }

  fetchDataSwitch() async {
    ApiClient(endpoint).postData(
        {"cmd": 222, "method": "GET", "sessionId": sessionID},
        printLogs: false).then((value) {
      // if (data_switch.value != value.data['data_switch']) {
      //   data_switch.value = value.data['dialMode'] ?? '';
      //   Logger().log('Updating Data Switch');
      // }
    });
  }

  toggleDataMode() {
    ApiClient(endpoint).postData({
      "dialMode": ref.read(homeProvider).circularDataActive ? "0" : "1",
      "cmd": 222,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      // Timer(Duration(seconds: 1), () {
      //   fetchDataSwitch();
      // });
      // Logger().log('Data mode is: ${data_switch.value == "0" ? "on" : "off"}');
    });
  }

  getConnetedDevices() {
    ApiClient(endpoint).postData({
      "cmd": 402,
      "method": "GET",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      // connectedDevices = ConnectedDModel.fromMap(value.data);
      // update(['stats', 'devices']);
    });
  }

  deleteSMS(id, {bool all = false}) {
    ApiClient(endpoint).postData({
      "cmd": 14,
      "index": all ? "DELETE ALL" : id,
      "subcmd": 0,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      // fetchSMS();
      Logger().log('Deletiing sms');
    });
  }

  fetchBlacklist() {
    ApiClient(endpoint).postData({
      "cmd": 405,
      "method": "GET",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      // if (value.data == null) return;
      if (value.data['datas'] == null) return;

      // blacklistDModel = BlacklistDModel.fromMap(value.data);
      // Logger().log('Fetching blacklist devices');
    });

    blockDevices(List devices) {
      var blacklist_devices = ref.read(fetchBlockDevicesProvider);
      if (blacklist_devices != null) {
        // blacklist_devices.value!
        //     .addAll(devices.map((e) => Maclist(mac: e)));
      } else {}

      List getMaclist() {
        if (blacklist_devices == null) {
          return devices.map((e) => {"mac": e}).toList();
        } else {
          return blacklist_devices.value!
              .map((e) => {"mac": e..mac_addr})
              .toList();
        }
      }

      Map<String, dynamic> data = {
        "datas": {"maclist": getMaclist(), "macfilter": "deny"},
        "success": true,
        "cmd": 405,
        "method": "POST",
        "sessionId": sessionID
      };

      ApiClient(endpoint)
          .postData(jsonEncode(data), printLogs: true)
          .then((value) {
        // blacklistDModel = BlacklistDModel.fromMap(value.data);
        // Logger().log('Fetching blacklist devices');
      });
    }

    unblockDevices(List devices, {bool reset = false}) {
      var blacklistDevices = ref.read(fetchBlockDevicesProvider);

      devices.forEach((e) {
        blacklistDevices.value?.removeWhere((element) {
          return element.mac_addr == e;
        });
      });

      Map<String, dynamic> data = {
        "datas": {
          "maclist": reset
              ? List.empty()
              : blacklistDevices.value!
                  .map((e) => {"mac": e.mac_addr})
                  .toList(),
          "macfilter": "deny"
        },
        "success": true,
        "cmd": 405,
        "method": "POST",
        "sessionId": sessionID
      };

      ApiClient(endpoint)
          .postData(jsonEncode(data), printLogs: true)
          .then((value) {
        // blacklistDModel = BlacklistDModel.fromMap(value.data);
        // Logger().log('Fetching blacklist devices');
      });
    }

    sendUSSD(value) async {
      return await ApiClient(endpoint).postData({
        "cmd": 350,
        "ussd_code": value,
        "subcmd": "0",
        "method": "POST",
        "sessionId": sessionID,
      }, printLogs: false).then((value) {
        Logger().log('USSD request sent');
      });
    }

    setReadSMS(value) async {
      return await ApiClient(endpoint).postData({
        "cmd": 12,
        "index": value,
        "method": "POST",
        "sessionId": sessionID,
      }, printLogs: false).then((value) {
        Logger().log('SMS read updated');
      });
    }

    fetchUSSD() async {
      return await ApiClient(endpoint).postData({
        "cmd": 350,
        "method": "GET",
        "sessionId": sessionID,
      }, printLogs: false).then((value) async {
        if (value.data == "") return;
        // UssdModel res = UssdModel.fromMap(value.data);
        // ussdRes = decodeString(res.message);
        // if (res.need_reply == "1") {
        // ussd_reply = true;
        // } else {
        //   // ussd_reply = false;
        // }

        Logger().log('USSD request fetched');
      }).onError((error, stackTrace) {
        // cancelUSSD();
        Logger().log(stackTrace);
      });
    }

    String decodeString(String encodedString) {
      var decodedString = '';
      var hexValues = encodedString.split('00');

      for (var hexValue in hexValues) {
        if (hexValue.isNotEmpty) {
          if (hexValue == '5') {
            hexValue = "50";
          } else if (hexValue == '07') {
            hexValue = "70";
          }
          var intValue = int.parse(hexValue, radix: 16);
          decodedString += String.fromCharCode(intValue);
        }
      }

      return decodedString;
    }

    cancelUSSD() async {
      return await ApiClient(endpoint).postData({
        "cmd": 350,
        "subcmd": "1",
        "method": "POST",
        "sessionId": sessionID,
      }, printLogs: false).then((value) {
        Logger().log('USSD request canceled');
      });
    }

    restartDevice() async {
      Logger().log('Restarting device');

      ApiClient(endpoint).postData({
        "cmd": 6,
        "rebootType": 1,
        "method": "POST",
        "sessionId": sessionID,
      }, printLogs: false);
    }

    resetDevice() async {
      Logger().log('Restarting device');

      ApiClient(endpoint).postData({
        "cmd": 6,
        "rebootType": 4,
        "method": "POST",
        "sessionId": sessionID,
      }, printLogs: false);
    }
  }
}
