import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/data/model/response/fetch_token_model.dart';
import 'package:crypto/crypto.dart';
import 'package:router_manager/data/model/response/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/logger.dart';

class AuthController extends GetxController {
  late FetchTokenModal data;
  String sessionID = '';
  RxString errorMsg = RxString('');
  var isLoading = false.obs;
  TextEditingController password = TextEditingController(text: 'Smart');
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final ValueChanged<String> stateChange;

  AuthController({required this.stateChange});

  /// fetch token
  Future<Response> fetchToken() async {
    return ApiClient().postData({
      "cmd": 232,
      "method": "GET",
      'sessionId': '',
    }, printLogs: false);
  }

  String encryptPassword(value) {
    Logger().log('Encrypting: $value');
    return sha256.convert(utf8.encode(value)).toString();
  }

  login() async {
    if (password.text == '') {
      errorMsg.value = 'Password Required';
      return;
    }

    await fetchToken().then((value) {
      if (value.statusCode != 200) {}

      errorMsg.value = '';
      data = FetchTokenModal.fromMap(value.data);

      /// try logging in
      ApiClient().postData({
        "cmd": 100,
        "username": "admin",
        'isAutoUpgrade': '1',
        'method': 'POST',
        'sessionId': '',
        'passwd': encryptPassword(data.token + password.text),
      }, printLogs: true).then((value) async {
        /// Check if login failed
        if (value.data['login_fail'] == null) {
          errorMsg.value = '';
          var data = LoginModel.fromMap(value.data);

          /// save session ID to local storage if login was successful
          if (await prefs.then((value) =>
              value.setString(AppConstant.sessionID, data.sessionId))) {
            Logger().log('SessionID successfully saved');
            stateChange('login_successful');
          }
        } else {
          errorMsg.value = 'Remaining times: ${value.data['login_times']}';
          Logger().log('Login Failed');
        }
      });
    }).onError((error, stackTrace) {
      errorMsg.value = 'Failed to fetch authentication token';
    });
  }
}
