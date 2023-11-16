import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/controller/sms_controller.dart';
import 'package:router_manager/controller/ussd_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/core/custom_navigator.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';
import 'package:router_manager/screen/auth/login.dart';
import 'package:router_manager/screen/devices/devices.dart';
import 'package:router_manager/screen/home/home_screen.dart';
import 'package:router_manager/screen/home/stream/home_stream.dart';

final MifiCtrProvider = ChangeNotifierProvider<MIFICONTROLLER>((ref) {
  return MIFICONTROLLER(ref);
});

class MIFICONTROLLER extends ChangeNotifier {
  final Ref ref;
  int get token => getRandomInt(120) + 50;
  String get_endpoint = 'http://192.168.0.1/goform/goform_get_cmd_process';
  String set_endpoint = 'http://192.168.0.1/goform/goform_set_cmd_process';
  var headers = {
    "Referer": "http://192.168.0.1/index.html",
    "Host": "192.168.0.1",
    "Accept": "application/json, text/javascript, */*; q=0.01"
  };

  MIFICONTROLLER(this.ref);

  // ======================= AUTH ================================

  getStatus() {
    ApiClient(get_endpoint)
        .getData(
            '?multi_data=1&isTest=false&cmd=modem_main_state,battery_value,psw_fail_num_str,pin_status,login_lock_time&_=${token}',
            headers: headers,
            printLogs: false)
        .then((value) {
      var data;
      try {
        data = jsonDecode(value.data);
      } catch (e) {}

      if (data is Map) {
      } else {
        Logger().log('Invalid API response');
        return false;
      }

      if (data['psw_fail_num_str'] == "0") {
        if (data['login_lock_time'] == "0" || data['login_lock_time'] == "-1") {
          ref.read(authProvider).disableAuth = false;
          ref.read(authProvider).lockdown_msg = null;
        } else {
          Duration duration =
              Duration(seconds: int.tryParse(data['login_lock_time']) ?? 0);

          String twoDigits(int n) => n.toString().padLeft(2, '0');

          String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
          String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

          ref.read(authProvider).disableAuth = true;

          ref.read(authProvider).lockdown_msg =
              "Your account is locked.\n Remaining time: $twoDigitMinutes:$twoDigitSeconds";
        }
      }
    });
  }

// You've input 5 times incorrectly. Retry in 5 minutes.
  login({required String password}) {
    final bytes = utf8.encode(password);
    final base64Password = base64.encode(bytes);

    ApiClient(set_endpoint)
        .postData(
      "isTest=false&goformId=LOGIN&password=$base64Password&_=${token}",
      printLogs: true,
      headers: headers,
    )
        .then((value) {
      var data = jsonDecode(value.data);
      if (data['result'] == "0") {
        ref.read(authProvider).errorMsg = null;
        ref.read(authProvider).notifyListeners();

        ref.read(authProvider).setAuthStatus(true);
        Logger().log('Login Successful');
      } else if (data['result'] == "3" || data['result'] == "1") {
        ApiClient(get_endpoint)
            .getData(
                '?multi_data=1&isTest=false&cmd=psw_fail_num_str,login_lock_time',
                headers: headers,
                printLogs: true)
            .then((value2) {
          var data2 = jsonDecode(value2.data);

          if (data['result'] == "1") {
            ref.read(authProvider).disableAuth = false;
          } else {
            ref.read(authProvider).errorMsg =
                'Incorrect password, ${data2['psw_fail_num_str']} attempt(s) left.';
          }
        });
      }
    });
  }

  // ======================= END ================================

  // ======================= OTHER ================================

  String convertBytesToReadableSpeed(int bps) {
    const int kilobit = 1000;
    const int megabit = 1000000;

    if (bps < kilobit) {
      return '$bps,B/s';
    } else if (bps < megabit) {
      return '${(bps / kilobit).toStringAsFixed(2)},KB/s';
    } else {
      return '${(bps / megabit).toStringAsFixed(2)},MB/s';
    }
  }

  int getRandomInt(int e) {
    // Get the current timestamp in milliseconds
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    // // Generate a random timestamp within a specific range (e.g., last 30 days)
    // int thirtyDaysInMillis = 30 * 24 * 60 * 60 * 1000;
    // Random random = Random();
    // int randomTimestamp = currentTimestamp - random.nextInt(thirtyDaysInMillis);

    // // Convert the random timestamp to a DateTime object for better readability
    // DateTime randomDateTime =
    //     DateTime.fromMillisecondsSinceEpoch(randomTimestamp);

    // print('Random Timestamp: $randomTimestamp');
    return currentTimestamp;
  }

  String decodeString(String hexString) {
    List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 4) {
      String hexPair = hexString.substring(i, i + 4);
      int charCode = int.parse(hexPair, radix: 16);
      bytes.add(charCode);
    }
    return String.fromCharCodes(bytes);
  }

  // ======================= OTHERS END ================================

  // ======================= SMS ================================

  fetchSMS() {
    ApiClient(get_endpoint)
        .getData(
      '?isTest=false&cmd=sms_data_total&page=0&data_per_page=5&mem_store=1&tags=10&order_by=order+by+id+desc&_=${token}',
      printLogs: false,
      headers: headers,
    )
        .then((value) {
      var data = jsonDecode(value.data);
      if (data['messages'] != "") {
        var messages = (data['messages'] as List);
        ref.read(smsProvider).sms_list = messages.map((e) {
          var date = e['date'].toString().split(',');

          return SMSModel(
              id: int.parse(e['id']),
              content: decodeString(e['content']),
              number: decodeString(e['number']),
              groupTag: e['tag'],
              date:
                  "20${date[0]}-${date[1]}-${date[2]} ${date[3]}:${date[4]}:${date[5]}");
        }).toList();
        ref.read(smsProvider).notifyListeners();
      }
    });
  }

  Future<bool> deleteSMS(id, {bool? all = false}) async {
    await ApiClient(set_endpoint)
        .postData(
      "isTest=false&goformId=DELETE_SMS&msg_id=$id&notCallback=true&_=${token}",
      printLogs: true,
      headers: headers,
    )
        .then((value) {
      var data = jsonDecode(value.data);
      if (data['result'] == "success") {
        fetchSMS();
        return true;
      }
    });

    return false;
  }

  // ======================= SMS END ================================
  // ======================= USSD ================================
  Future<bool> sendUSSD(ussd, {bool isReply = false}) async {
    await ApiClient(set_endpoint)
        .postData(
      isReply
          ? 'isTest=false&goformId=USSD_PROCESS&USSD_operator=ussd_reply&USSD_reply_number=$ussd&notCallback=true'
          : "isTest=false&goformId=USSD_PROCESS&USSD_operator=ussd_send&USSD_send_number=${ussd}&notCallback=true",
      printLogs: true,
      headers: headers,
    )
        .then((value) {
      var data = jsonDecode(value.data);
      if (data['result'] == "success") {
        return true;
      }
    });

    return false;
  }

  fetchUSSDData() async {
    ref.read(ussdProvider).state = UssdState.fetching;
    Timer timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await ApiClient(get_endpoint)
          .getData(
        '?cmd=ussd_write_flag&_=${token}',
        printLogs: true,
        headers: headers,
      )
          .then((value) async {
        var data = jsonDecode(value.data);
        if (data['ussd_write_flag'] == "16") {
          timer.cancel();

          await ApiClient(get_endpoint)
              .getData(
            '?cmd=ussd_data_info&_=${token}',
            printLogs: true,
            headers: headers,
          )
              .then((value) {
            var data = jsonDecode(value.data);
            var content = decodeString(data['ussd_data']);
            var canReply = data['ussd_action'] == "1" ? true : false;

            ref.read(ussdProvider).state = UssdState.completed;
            ref.read(ussdProvider).ussdResponse = content;
            ref.read(ussdProvider).canReply = canReply;
          });
        }
      });
    });

    return ('', false);
  }

  cancleUSSD() {
    ApiClient(set_endpoint).postData(
      "goformId=USSD_PROCESS&USSD_operator=ussd_cancel&_=${token}",
      printLogs: true,
      headers: headers,
    );
  }

  // ======================= USSD END ================================

  // ======================= HOME ================================

  toggleData() {
    var isConnected = ref.read(homeProvider).circularDataActive;
    ApiClient(set_endpoint).postData(
      "isTest=false&notCallback=true&goformId=${isConnected ? "DISCONNECT_NETWORK" : "CONNECT_NETWORK"}&_=${token}",
      printLogs: true,
      headers: headers,
    );
  }

  fetchData() async {
    ref.read(ussdProvider).state = UssdState.sending;
    ApiClient(get_endpoint)
        .getData('?isTest=false&cmd=station_list&_=${token}',
            headers: headers, printLogs: false)
        .then((value) {
      var data;
      try {
        data = jsonDecode(value.data);
      } catch (e) {}

      if (data is Map) {
      } else {
        Logger().log('Invalid API response');
        return false;
      }
      if (data['station_list'] != "") {
        ref.read(homeProvider).devices.connected =
            (data['station_list'] as List).length;
        ref.read(homeProvider).devices.devices = (data['station_list'] as List)
            .map((e) => NetworkDevice(
                mac_addr: e['mac_addr'],
                ip_addr: e['ip_addr'],
                hostname: e['hostname']))
            .toList();
      }
    });

    ApiClient(get_endpoint).getData(
        '?isTest=false&multi_data=1&cmd=wifi_sta_connection,Cap_station_mode&_=1700081935978',
        headers: headers,
        printLogs: false);

    ApiClient(get_endpoint).getData(
        '?isTest=false&cmd=upgrade_result&_=1700082271079',
        headers: headers,
        printLogs: false);

    ApiClient(get_endpoint).getData(
        '?isTest=false&cmd=privacy_read_flag%2Cloginfo&multi_data=1&_=1700082266206',
        headers: headers,
        printLogs: false);

    ApiClient(get_endpoint)
        .getData(
            '?multi_data=1&isTest=false&cmd=battery_charging,battery_value,ppp_status,signalbar,sms_unread_num,network_type,network_provider,lan_ipaddr,loginfo,SSID1,user_ip_addr,MAX_Access_num,imei,msisdn,realtime_rx_thrpt,realtime_tx_thrpt&_=${token}',
            headers: headers,
            printLogs: false)
        .then((value) {
      if (value.data == 'NoInternetConnection') {
        MyRouter().removeAll(homeScreenContext, LoginScreen());
      }

      var data;
      try {
        data = jsonDecode(value.data);
      } catch (e) {}

      if (data is Map) {
      } else {
        Logger().log('Invalid API response');
        return false;
      }

      if (data["loginfo"] != 'ok') {
        login(password: ref.read(authProvider).passwordCtr.text);
      }

      ref.read(homeProvider).isCharging =
          data["battery_charging"] == '1' ? true : false;

      ref.read(homeProvider).battery_level =
          int.tryParse(data["battery_value"]) ?? 0;

      ref.read(homeProvider).circularDataActive =
          data["ppp_status"] == "ppp_connected" ? true : false;

      ref.read(homeProvider).imei = data["imei"];

      ref.read(homeProvider).ipAddress = data["user_ip_addr"];

      if (data["realtime_rx_thrpt"] != '') {
        ref.read(homeProvider).downloadSpeed = (
          convertBytesToReadableSpeed(
            int.parse(data["realtime_rx_thrpt"]),
          ).toString().split(',').first,
          convertBytesToReadableSpeed(
            int.parse(data["realtime_rx_thrpt"]),
          ).toString().split(',').last
        );
      }

      if (data["realtime_tx_thrpt"] != '') {
        ref.read(homeProvider).uploadSpeed = (
          convertBytesToReadableSpeed(
            int.parse(data["realtime_tx_thrpt"]),
          ).toString().split(',').first,
          convertBytesToReadableSpeed(
            int.parse(data["realtime_tx_thrpt"]),
          ).toString().split(',').last
        );
      }

      ref.read(homeProvider).sms_unread =
          int.tryParse(data["sms_unread_num"]) ?? 0;

      ref.read(homeProvider).network_provider = data["network_provider"];

      ref.read(homeProvider).networkBar = NNetworkBar(
          bar_length: int.tryParse(data["signalbar"]) ?? 0,
          name: data["network_type"]);

      ref.read(homeProvider).notifyListeners();
    });
  }
  // ======================= HOME END ================================

  // ======================= DEVICES END ================================
  // http://192.168.0.1/goform/goform_get_cmd_process?isTest=false&multi_data=1&cmd=ACL_mode%2Cwifi_mac_black_list%2Cwifi_hostname_black_list%2CRadioOff%2Cuser_ip_addr&_=170010229
  Future<List<NetworkDevice>> fetchBlockedDevices() async {
    var res = await ApiClient(get_endpoint).getData(
      '?isTest=false&multi_data=1&cmd=ACL_mode,wifi_mac_black_list,wifi_hostname_black_list&_=${token}',
      printLogs: false,
      headers: headers,
    );

    var data = jsonDecode(res.data);

    var blackListMac = data['wifi_mac_black_list'].toString().split(';');
    var blackListHostname =
        data['wifi_hostname_black_list'].toString().split(';');

    List<NetworkDevice> list = List.generate(
        blackListMac.length,
        (index) => NetworkDevice(
            mac_addr: blackListMac[index],
            ip_addr: '',
            hostname: blackListHostname[index])).toList();
    return list;
  }
}
