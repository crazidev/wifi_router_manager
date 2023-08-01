import 'dart:async';
import 'package:get/get.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/response/connected_devices_model.dart';
import 'package:router_manager/data/model/response/sms_model.dart';
import 'package:router_manager/data/model/response/network_details_model.dart';

// ignore_for_file: non_constant_identifier_names

class HomeController extends GetxController {
  @override
  Future<void> onReady() async {
    prefs = await SharedPreferences.getInstance();
    super.onReady();
  }

  late SharedPreferences prefs;
  get sessionID => prefs.getString(AppConstant.sessionID);
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  SmsModel? smsList;
  NetworkDModel? networkD;
  ConnectedDModel? connectedDevices;
  var sms_unread = "0".obs;
  var sms_count = 0;
  var signal_lvl = '0'.obs;
  var fist_time = true;
  var data_switch = ''.obs;

  fetch() async {
    Logger().log("Fetch function");
    fetchSMS();
    fetchNetworkDetails();
    fetchDataSwitch();
    getConnetedDevices();

    // if (fist_time) fist_time = false;
    refreshController.refreshCompleted();
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
      sms_count = smsList!.sms_list.length;
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
      // if (data_switch.value != value.data['data_switch']) {
      data_switch.value = value.data['dialMode'] ?? '';
      update();
      Logger().log('Updating Data Switch');
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
    }, printLogs: true).then((value) {
      connectedDevices = ConnectedDModel.fromMap(value.data);
      Logger().log('Fetching connected devices');
    });
  }

  var navIndex = 0.obs;
}
