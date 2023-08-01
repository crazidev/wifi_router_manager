import 'dart:async';
import 'package:get/get.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:router_manager/data/model/response/sms_model.dart';
import 'package:router_manager/data/model/response/network_details_model.dart';
// ignore_for_file: non_constant_identifier_names

class HomeController extends GetxController {
  @override
  Future<void> onReady() async {
    prefs = await SharedPreferences.getInstance();
    fetch();
    fist_time = true;
    super.onReady();
  }

  late SharedPreferences prefs;
  get sessionID => prefs.getString(AppConstant.sessionID);
  SmsModel? smsList;
  NetworkDModel? networkD;
  var sms_unread = "0".obs;
  var sms_count = 0;
  var signal_lvl = '0'.obs;
  var fist_time = true;

  fetch() async {
    Logger().log("Fetch function");
    fetchSMS();
    fetchNetworkDetails();

    Timer(Duration(milliseconds: 4000), () {
      if (fist_time) fist_time = false;

      fetch();
    });
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
      print(smsList!.sms_unread);
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

  var navIndex = 0.obs;
}
