import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:router_manager/data/model/response/blacklist_devices.dart';
import 'package:router_manager/data/model/response/ussd_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/response/connected_devices_model.dart';
import 'package:router_manager/data/model/response/sms_model.dart';
import 'package:router_manager/data/model/response/network_details_model.dart';

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
  var sms_unread = "0".obs;
  var sms_count = 0;
  var signal_lvl = '0'.obs;
  var fist_time = true;
  var data_switch = ''.obs;
  late Timer timer;
  late Timer timer2;

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
      "subcmd": "",
      "method": "POST",
      "sessionId": sessionID,
    }, printLogs: true).then((value) {
      Logger().log('USSD request sent');
    });
  }

  fetchUSSD() async {
    return await ApiClient().postData({
      "cmd": 350,
      "method": "GET",
      "sessionId": sessionID,
    }, printLogs: true).then((value) {
      UssdModel res = UssdModel.fromMap(value.data);

      Logger().log('USSD request fetched');
    });
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
