// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/data/model/response/blacklist_devices.dart';
import 'package:router_manager/data/model/response/network_details_model.dart';
import 'package:router_manager/data/model/response/sms_model.dart';
import 'package:router_manager/data/model/response/ussd_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/connected_devices_model.dart';

// ignore_for_file: non_constant_identifier_names
/* cSpell:disable */

class HomeController extends GetxController {
  @override
  Future<void> onReady() async {
    // initialize the shared preference first
    prefs = await SharedPreferences.getInstance();

    fetch();
    getConnetedDevices();

    timer = Timer.periodic(
        const Duration(milliseconds: kDebugMode ? 7000 : 5000), (timer) {
      getConnetedDevices();
      fetch();
    });
    super.onReady();
  }

  @override
  void onClose() {
    refreshController.dispose();
    Logger().log('Controller closed');
    timer.cancel();
    super.onClose();
  }

  late SharedPreferences prefs;
  get sessionID => prefs.getString(AppConstant.sessionID);
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  SmsModel? smsList;

  NetworkDModel? networkD;
  ConnectedDModel? connectedDevices;
  BlacklistDModel? blacklistDModel;
  late BuildContext context;
  var sms_unread = "0".obs;
  var sms_count = 0;
  var signal_lvl = '0'.obs;
  var fist_time = true;
  var data_switch = ''.obs;
  late Timer timer;
  late Timer timer2;
  var ussdRes = '';
  var ussd_reply = false;

  fetch() {
    fetchSMS();
    fetchNetworkDetails();
    fetchDataSwitch();
    fetchBlacklist();
    getConnetedDevices();

    if (refreshController.isRefresh) refreshController.refreshCompleted();
  }

  fetchSMS() async {
    ApiClient().postData({
      "page_num": 1,
      "subcmd": 0,
      "cmd": 12,
      "method": "GET",
      "sessionId": sessionID
    }, printLogs: false).then((value) {
      if (smsList.toString() != SmsModel.fromMap(value.data).toString()) {
        print('Updating sms list');

        List diff = [];
        if (smsList != null) {
          diff = SmsModel.fromMap(value.data)
              .sms_list
              .where((element) => !smsList!.sms_list.contains(element))
              .toList();
        }

        for (var e in diff) {
          var data = utf8.decode(base64Decode(e));
          var others =
              "${data.split(' ').elementAt(0)} ${data.split(' ').elementAt(1)} ${data.split(' ').elementAt(2)} ${data.split(' ').elementAt(3)} ${data.split(' ').elementAt(4)} ";

          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: int.parse(data.split(' ').elementAt(0)),
                  channelKey: 'MyWifi_Router',
                  category: NotificationCategory.Message,
                  notificationLayout: NotificationLayout.Messaging,
                  title: data.split(' ').elementAt(2),
                  body: data.substring(others.length),
                  actionType: ActionType.Default));
        }

        smsList = SmsModel.fromMap(value.data);
        sms_unread.value = smsList!.sms_unread;
        update(['sms']);
      }
    });
  }

  fetchNetworkDetails() async {
    ApiClient().postData({"cmd": 113, "method": "GET", "sessionId": sessionID},
        printLogs: false).then((value) {
      if (networkD.toString() != NetworkDModel.fromMap(value.data).toString()) {
        networkD = NetworkDModel.fromMap(value.data);
        update(['network_details']);
        Logger().log('Refreshing network details');
      }
    });
  }

  fetchDataSwitch() async {
    ApiClient().postData({"cmd": 222, "method": "GET", "sessionId": sessionID},
        printLogs: false).then((value) {
      if (data_switch.value != value.data['data_switch']) {
        data_switch.value = value.data['dialMode'] ?? '';
        Logger().log('Updating Data Switch');
      }
    });
  }

  toggleDataMode() {
    ApiClient().postData({
      "dialMode": data_switch.value == "0" ? "1" : "0",
      "cmd": 222,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      Timer(Duration(seconds: 1), () {
        fetchDataSwitch();
      });
      Logger().log('Data mode is: ${data_switch.value == "0" ? "on" : "off"}');
    });
  }

  getConnetedDevices() {
    ApiClient().postData({
      "cmd": 402,
      "method": "GET",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      connectedDevices = ConnectedDModel.fromMap(value.data);
      update(['stats', 'devices']);
    });
  }

  deleteSMS(id, {bool all = false}) {
    ApiClient().postData({
      "cmd": 14,
      "index": all ? "DELETE ALL" : id,
      "subcmd": 0,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      fetchSMS();
      Logger().log('Deletiing sms');
    });
  }

  fetchBlacklist() {
    ApiClient().postData({
      "cmd": 405,
      "method": "GET",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      // if (value.data == null) return;
      if (value.data['datas'] == null) return;

      blacklistDModel = BlacklistDModel.fromMap(value.data);
      // Logger().log('Fetching blacklist devices');
    });
  }

  blockDevices(List devices) {
    BlacklistDModel? blacklist_devices = blacklistDModel;
    if (blacklist_devices != null) {
      blacklist_devices.datas.maclist
          .addAll(devices.map((e) => Maclist(mac: e)));
    } else {}

    List getMaclist() {
      if (blacklist_devices == null) {
        return devices.map((e) => {"mac": e}).toList();
      } else {
        return blacklist_devices.datas.maclist
            .map((e) => {"mac": e.mac})
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

    ApiClient().postData(jsonEncode(data), printLogs: true).then((value) {
      // blacklistDModel = BlacklistDModel.fromMap(value.data);
      // Logger().log('Fetching blacklist devices');
    });
  }

  unblockDevices(List devices, {bool reset = false}) {
    BlacklistDModel? blacklist_devices = blacklistDModel;

    if (blacklist_devices == null) return;

    devices.forEach((e) {
      blacklist_devices.datas.maclist.removeWhere((element) {
        return element.mac == e;
      });
    });

    Map<String, dynamic> data = {
      "datas": {
        "maclist": reset
            ? List.empty()
            : blacklist_devices.datas.maclist
                .map((e) => {"mac": e.mac})
                .toList(),
        "macfilter": "deny"
      },
      "success": true,
      "cmd": 405,
      "method": "POST",
      "sessionId": sessionID
    };
//
    // print(data);
    ApiClient().postData(jsonEncode(data), printLogs: true).then((value) {
      // blacklistDModel = BlacklistDModel.fromMap(value.data);
      // Logger().log('Fetching blacklist devices');
    });
  }

  sendUSSD(value) async {
    return await ApiClient().postData({
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
    return await ApiClient().postData({
      "cmd": 12,
      "index": value,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: false).then((value) {
      Logger().log('SMS read updated');
    });
  }

  fetchUSSD() async {
    return await ApiClient().postData({
      "cmd": 350,
      "method": "GET",
      "sessionId": sessionID,
    }, printLogs: false).then((value) async {
      if (value.data == "") return;
      UssdModel res = UssdModel.fromMap(value.data);
      ussdRes = decodeString(res.message);
      if (res.need_reply == "1") {
        ussd_reply = true;
      } else {
        ussd_reply = false;
      }

      Logger().log('USSD request fetched');
    }).onError((error, stackTrace) {
      cancelUSSD();
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
    return await ApiClient().postData({
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

    ApiClient().postData({
      "cmd": 6,
      "rebootType": 1,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: false);
  }

  resetDevice() async {
    Logger().log('Restarting device');

    ApiClient().postData({
      "cmd": 6,
      "rebootType": 4,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: false);
  }

  var navIndex = 0.obs;
}
