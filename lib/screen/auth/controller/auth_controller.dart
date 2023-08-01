import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:router_manager/data/model/response/fetch_token_model.dart';
import 'package:crypto/crypto.dart';

class AuthController extends GetxController {
  late FetchTokenModal data;
  String sessionID = '';
  TextEditingController password = TextEditingController();

  /// fetch token
  Future<Response> fetchToken() async {
    return ApiClient().postData({
      "cmd": 232,
      "method": "GET",
      'sessionId': '',
    }, printLogs: true);
  }

  String encryptPassword(value) {
    return sha256.convert(utf8.encode('Admin')).toString();
  }

  login() async {
    print(encryptPassword('admin'));
    //   await fetchToken().then((value) {
    //     if (value.statusCode == 200) {}
    //     data = FetchTokenModal.fromMap(value.data);

    //     /// try logging in
    //     ApiClient().postData({
    //       "cmd": 100,
    //       "username": "admin",
    //       'isAutoUpgrade': '1',
    //       'method': 'POST',
    //       'sessionId': '',
    //       'password': '',
    //     }, printLogs: true);
    //   });
  }
}
