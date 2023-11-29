// ignore_for_file: prefer_typing_uninitialized_variables, empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:router_manager/controller/devices_controller.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/controller/sms_controller.dart';
import 'package:router_manager/controller/ussd_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/core/custom_navigator.dart';
import 'package:router_manager/dashhboard_navigator.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/data/model/response/sms_model.dart';
import 'package:router_manager/screen/auth/controller/auth_controller.dart';
import 'package:router_manager/screen/auth/login.dart';
import 'package:router_manager/screen/devices/devices.dart';
import 'package:router_manager/screen/home/home_screen.dart';
import 'package:router_manager/screen/home/stream/home_stream.dart';
import 'package:router_manager/screen/sms/sms_conversation.dart';

final MifiCtrProvider = ChangeNotifierProvider<MIFICONTROLLER>((ref) {
  return MIFICONTROLLER(ref);
});

class MIFICONTROLLER extends ChangeNotifier {
  final Ref ref;
  int get token => getRandomInt(120) + 50;
  MIFICONTROLLER(this.ref);

  String get_endpoint = 'http://192.168.0.1/goform/goform_get_cmd_process';
  String set_endpoint = 'http://192.168.0.1/goform/goform_set_cmd_process';
  var headers = {
    "Referer": "http://192.168.0.1/index.html",
    "Host": "192.168.0.1",
    "Accept": "application/json, text/javascript, */*; q=0.01"
  };

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

  String formatToUnicode(String rawString) {
    Iterable<int> codePoints = rawString.runes;
    String unicodeString = codePoints.map((int codePoint) {
      return '${codePoint.toRadixString(16).toUpperCase().padLeft(4, '0')}';
    }).join('');
    return unicodeString;
  }

  String convertDateTimeToCustomFormat(DateTime dateTime) {
    Duration timeZoneOffset = dateTime.timeZoneOffset;
    String offsetSign = timeZoneOffset.isNegative ? '-' : '+';
    String offsetHours = timeZoneOffset.inHours.abs().toString().padLeft(2, '');
    String offsetMinutes =
        (timeZoneOffset.inMinutes % 60).abs().toString().padLeft(2, '0');

    // Format: yy;MM;dd;HH;mm;ss;+HH;mm
    return "${dateTime.year % 100};${dateTime.month.toString().padLeft(2, '0')};"
        "${dateTime.day.toString().padLeft(2, '0')};${dateTime.hour.toString().padLeft(2, '0')};"
        "${dateTime.minute.toString().padLeft(2, '0')};${dateTime.second.toString().padLeft(2, '0')};"
        "$offsetSign$offsetHours";
  }

  // ======================= OTHERS END ================================

  // ======================= SMS ================================

  Map<String, List<SMSModel>> groupSMSByNumber(List<SMSModel> smsList) {
    Map<String, List<SMSModel>> groupedSMS = {};

    for (SMSModel sms in smsList) {
      if (!groupedSMS.containsKey(sms.number)) {
        groupedSMS[sms.number] = [];
      }
      groupedSMS[sms.number]?.add(sms);
    }

    return groupedSMS;
  }

  // Function to find the newest SMS in a list
  SMSModel findNewestSMS(List<SMSModel> messages) {
    messages.sort((a, b) => b.date.compareTo(a.date));
    return messages.first;
  }

  fetchSMS() {
    ApiClient(get_endpoint)
        .getData(
      '?isTest=false&cmd=sms_data_total&page=0&data_per_page=500&mem_store=1&tags=10&order_by=order+by+id+desc&_=${token}',
      printLogs: false,
      headers: headers,
    )
        .then((value) {
      var data = jsonDecode(value.data);
      if (data['messages'] != "") {
        var messages = (data['messages'] as List);

        ref.read(smsProvider).sms_list = messages.map((e) {
          var date = e['date'].toString().split(',');

          /// Tag = 0: read
          /// Tag = 2: sent sms
          /// Tag = 1: unread

          return SMSModel(
              id: int.parse(e['id']),
              content: decodeString(e['content']),
              number: decodeString(e['number']),
              isSent: e['tag'] == "2" || e['tag'] == "3" ? true : false,
              sentFailed: e['tag'] == "3" ? true : false,
              unread: e['tag'] == "1" ? true : false,
              date:
                  "20${date[0]}-${date[1]}-${date[2]} ${date[3]}:${date[4]}:${date[5]}");
        }).toList();

        var groupedSMS = groupSMSByNumber(ref.read(smsProvider).sms_list!);

        // Group SMS by number
        ref.read(smsProvider).sms_grouped_list = List.from(groupedSMS.entries
            .map((e) => SMSGroupedModel(
                number: e.key,
                smsList: e.value,
                newestSMS: findNewestSMS(e.value))));
      }

      if (ref.read(pageIndexProvider) == 2) {
        ref.read(smsProvider).refreshController.refreshCompleted();
      }
      ref.read(smsConversationProvider).notifyListeners();
      ref.read(smsProvider).notifyListeners();
    });
  }

  Future<bool> deleteSMS(List<SMSModel> sms_list) async {
    var ids = sms_list.map((e) => e.id).join(';');
    await ApiClient(set_endpoint)
        .postData(
      "isTest=false&goformId=DELETE_SMS&msg_id=$ids&notCallback=true&_=${token}",
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

  sendSMS(SendSMSModel data) {
    var messageDecode = formatToUnicode(data.message);
    var number = data.number;
    String formattedDateTime = convertDateTimeToCustomFormat(DateTime.now());

    ApiClient(set_endpoint)
        .postData(
      "isTest=false&goformId=SEND_SMS&notCallback=true&Number=$number&sms_time=$formattedDateTime&MessageBody=$messageDecode&ID=-1&encode_type=GSM7_default",
      printLogs: true,
      headers: headers,
    )
        .then((value) {
      var data = jsonDecode(value.data);
      if (data['result'] == "success") {
        Timer timer = Timer.periodic(Duration(seconds: 1), (timer) async {
          await ApiClient(get_endpoint)
              .getData(
            '?cmd=sms_cmd_status_info&sms_cmd=4&isTest=false&_=${token}',
            printLogs: true,
            headers: headers,
          )
              .then((value) {
            var data = jsonDecode(value.data);
            if (data['sms_cmd_status_result'] == "1") {
              // TODO: Still waiting for status
            }

            if (data['sms_cmd_status_result'] == "3") {
              timer.cancel();
              if (ref.read(pageIndexProvider) == 2) {
                ref.read(smsProvider).refreshController.requestRefresh();
              }
            }
            if (data['sms_cmd_status_result'] == "2") {
              timer.cancel();
            }
          });
        });
        return true;
      }
    });
  }

  updateReadStatus(List<SMSModel> sms_list) {
//     fetch("http://192.168.0.1/goform/goform_set_cmd_process", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": "isTest=false&goformId=SET_MSG_READ&msg_id=1710%3B&tag=0",
//   "method": "POST",
//   "mode": "cors",
//   "credentials": "omit"
// });
    Logger().log('Updating read status');
    var ids = sms_list.map((e) => e.id).join(';');
    ApiClient(set_endpoint)
        .postData(
      "isTest=false&goformId=SET_MSG_READ&msg_id=${ids}&tag=0",
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
        ref.read(deviceProvider).connected =
            (data['station_list'] as List).length;

        ref.read(deviceProvider).devices = (data['station_list'] as List)
            .map((e) => NetworkDevice(
                mac_addr: e['mac_addr'],
                ip_addr: e['ip_addr'],
                hostname: e['hostname']))
            .toList();
      }
    });

    ApiClient(get_endpoint)
        .getData('?isTest=false&cmd=sms_capacity_info',
            headers: headers, printLogs: false)
        .then((value) {
      try {
        var data = jsonDecode(value.data);
        ref.read(smsProvider).sms_total_count =
            int.tryParse(data["sms_nvused_total"]) ?? 0;
      } catch (e) {}
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

      ref.read(deviceProvider).max = int.tryParse(data["MAX_Access_num"]) ?? 0;

      ref.read(smsProvider).sms_unread =
          int.tryParse(data["sms_unread_num"]) ?? 0;

      ref.read(homeProvider).network_provider = data["network_provider"];

      ref.read(homeProvider).networkBar = NNetworkBar(
          bar_length: int.tryParse(data["signalbar"]) ?? 0,
          name: data["network_type"]);

      ref.read(homeProvider).notifyListeners();
      ref.read(smsProvider).notifyListeners();
    });
  }
  // ======================= HOME END ================================

  // ======================= DEVICES END ================================
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

  blockDevices(List value) {
    var devices = ref.read(fetchBlockDevicesProvider).value ?? [];

    for (var i = 0; i < value.length; i++) {
      var newDevice = ref
          .read(deviceProvider)
          .devices!
          .where((e) => e.mac_addr == value[i])
          .first;
      ref
          .read(deviceProvider)
          .devices!
          .removeWhere((e) => e.mac_addr == value[i]);
      devices.add(newDevice);
    }

    var macAddreses = devices.map((e) => e.mac_addr).toList().join(";");
    var names = devices.map((e) => e.hostname).toList().join(";");

    ApiClient(set_endpoint)
        .postData(
      "goformId=WIFI_MAC_FILTER&isTest=false&ACL_mode=2&macFilteringMode=2&wifi_hostname_black_list=${names}&wifi_mac_black_list=${macAddreses}",
      printLogs: true,
      headers: headers,
    )
        .then((value) {
      ref.invalidate(fetchBlockDevicesProvider);
    });
  }

  unblockDevices(List value) {
    var devices = ref.read(fetchBlockDevicesProvider).value ?? [];

    for (var i = 0; i < value.length; i++) {
      ref
          .read(deviceProvider)
          .devices!
          .add(devices.where((e) => e.mac_addr == value[i]).first);
      devices.removeWhere((e) => e.mac_addr == value[i]);
    }

    var macAddreses = devices.map((e) => e.mac_addr).toList().join(";");
    var names = devices.map((e) => e.hostname).toList().join(";");

    ApiClient(set_endpoint)
        .postData(
      "goformId=WIFI_MAC_FILTER&isTest=false&ACL_mode=2&macFilteringMode=2&wifi_hostname_black_list=${names}&wifi_mac_black_list=${macAddreses}",
      printLogs: true,
      headers: headers,
    )
        .then((value) {
      ref.invalidate(fetchBlockDevicesProvider);
    });
  }

  renameDevice() {
//   fetch("http://192.168.0.1/goform/goform_set_cmd_process", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": "isTest=false&goformId=EDIT_HOSTNAME&mac=d6%3A07%3A5c%3A11%3A76%3A13&hostname=Unknown",
//   "method": "POST",
//   "mode": "cors",
//   "credentials": "omit"
// });
  }

  rebootDevice() {
    ApiClient(set_endpoint).postData(
      "isTest=false&goformId=REBOOT_DEVICE",
      printLogs: true,
      headers: headers,
    );
  }

  shutdownDevice() {
    ApiClient(set_endpoint).postData(
      "isTest=false&goformId=SHUTDOWN_DEVICE",
      printLogs: true,
      headers: headers,
    );
  }

  fetchNetworkSetting() {
    ApiClient(get_endpoint).getData(
        '?isTest=false&cmd=upgrade_result&_=1700082271079',
        headers: headers,
        printLogs: false);
  }

// Fetch network settings
//   fetch("http://192.168.0.1/goform/goform_get_cmd_process?isTest=false&cmd=m_ssid_enable%2CRadioOff%2CNoForwarding%2Cm_NoForwarding%2CWPAPSK1_encode%2Cm_WPAPSK1_encode%2Cwifi_attr_max_station_number%2CSSID1%2CAuthMode%2CHideSSID%2CMAX_Access_num%2CEncrypType%2Cm_SSID%2Cm_AuthMode%2Cm_HideSSID%2Cm_MAX_Access_num%2Cm_EncrypType%2Cqrcode_display_switch%2Cm_qrcode_display_switch&multi_data=1&_=1701010022213", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": null,
//   "method": "GET",
//   "mode": "cors",
//   "credentials": "include"
// });

// Set netwwork settings
//   fetch("http://192.168.0.1/goform/goform_set_cmd_process", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": "goformId=SET_WIFI_SSID1_SETTINGS&isTest=false&ssid=MTN_5G_7A64B4&broadcastSsidEnabled=0&MAX_Access_num=31&security_mode=WPA2PSK&cipher=1&NoForwarding=0&security_shared_mode=1&passphrase=MTIzNDU2Nzg5MA%3D%3D",
//   "method": "POST",
//   "mode": "cors",
//   "credentials": "include"
// });

// fetch("http://192.168.0.1/goform/goform_set_cmd_process", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": "isTest=false&goformId=SET_aBEARER_PREFERENCE&BearerPreference=Only_LTE",
//   "method": "POST",
//   "mode": "cors",
//   "credentials": "include"
// });

// fetch("http://192.168.0.1/goform/goform_set_cmd_process", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": "isTest=false&goformId=SET_BEARER_PREFERENCE&BearerPreference=Only_WCDMA",
//   "method": "POST",
//   "mode": "cors",
//   "credentials": "include"
// });

// fetch("http://192.168.0.1/goform/goform_get_cmd_process?isTest=false&multi_data=1&cmd=wifi_sta_connection%2Cap_station_mode&_=1701010714520", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": null,
//   "method": "GET",
//   "mode": "cors",
//   "credentials": "include"
// });

// fetch("http://192.168.0.1/goform/goform_set_cmd_process", {
//   "headers": {
//     "accept": "application/json, text/javascript, */*; q=0.01",
//     "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "x-requested-with": "XMLHttpRequest"
//   },
//   "referrer": "http://192.168.0.1/index.html",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": "isTest=false&goformId=SET_BEARER_PREFERENCE&BearerPreference=NETWORK_auto",
//   "method": "POST",
//   "mode": "cors",
//   "credentials": "include"
// });
}
