import 'dart:async';

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

class HomeController extends GetxController {
  @override
  Future<void> onReady() async {
    prefs = await SharedPreferences.getInstance();
    timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      fetch();
    });
    timer2 = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      getConnetedDevices();
    });
    super.onReady();
  }

  @override
  void onClose() {
    refreshController.dispose();
    Logger().log('Controller closed');
    timer.cancel();
    timer2.cancel();
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

  fetch() async {
    Logger().log("Fetch function");
    await fetchSMS();
    await fetchNetworkDetails();
    await fetchDataSwitch();
    fetchBlacklist();
    // update();
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
      // if (fist_time) {
      smsList = SmsModel.fromMap(value.data);
      sms_unread.value = smsList!.sms_unread;
      update();
    });
  }

  fetchNetworkDetails() async {
    ApiClient().postData({"cmd": 113, "method": "GET", "sessionId": sessionID},
        printLogs: false).then((value) {
      if (networkD.toString() != NetworkDModel.fromMap(value.data).toString()) {
        networkD = NetworkDModel.fromMap(value.data);
        update(['network_details']);
        // Logger().log('Refreshing network details');
      }
    });
  }

  fetchDataSwitch() async {
    ApiClient().postData({"cmd": 222, "method": "GET", "sessionId": sessionID},
        printLogs: false).then((value) {
      // if (data_switch.value != value.data['data_switch']) {
      data_switch.value = value.data['dialMode'] ?? '';
      // Logger().log('Updating Data Switch');
      // }
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

      update(['stats']);
      // Logger().log('Fetching connected devices');
    });
  }

  deleteSMS(id, {bool all = false}) {
    ApiClient().postData({
      "cmd": 14,
      "index": all ? "DELETE ALL" : id,
      "subcmd": 0,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: true).then((value) {
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
      blacklistDModel = BlacklistDModel.fromMap(value.data);
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
    }, printLogs: true).then((value) {
      Logger().log('USSD request sent');
    });
  }

  setReadSMS(value) async {
    return await ApiClient().postData({
      "cmd": 12,
      "index": value,
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: true).then((value) {
      Logger().log('SMS read updated');
    });
  }

  fetchUSSD() async {
    return await ApiClient().postData({
      "cmd": 350,
      "method": "GET",
      "sessionId": sessionID,
    }, printLogs: true).then((value) async {
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

  // 00500075006c007300650020004d00610069006e0020004100630063006f0075006e0074003a0020002d004e0031003900360031002e00340032002e002000410069007200740069006d0065002000420075006e0064006c0065003a004e00360030002e00320032002e00200044006100740061002000420061006c0061006e00630065003a0020003700300033002e00310031004d0042002e0020004400690061006c0020002a003400300036002a0032002300200026002000670065007400200075007000200074006f0020003100680072002000660072006500650020006f006e002000540069006b0074006f006b0020002b00200031002e0035004700420040004e003500300030002000440065007400610069006c0073002000760069006100200053004d0053002e000a000a

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

  var navIndex = 0.obs;
}
