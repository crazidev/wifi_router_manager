import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:router_manager/controller/home_controller.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final String noInternetMessage = 'NoInternetConnection';
  final int timeoutInSeconds = 60;
  final appBaseUrl = AppConstant.baseUrl;
  String? token = "";
  final dio = Dio();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<Response> getData({
    String? uri,
    Map<String, String>? headers,
    bool? includeToken,
    bool? printLogs = false,
  }) async {
    try {
      dio.httpClientAdapter = NativeAdapter();
      Response res = await dio
          .get(appBaseUrl)
          .timeout(Duration(seconds: timeoutInSeconds));
      if (printLogs!) Logger().log(res.data);
      if (res.data['success'] == false && res.data['message'] == "NO_AUTH") {
        await logout();
      }
      return res;
    } catch (e) {
      Logger().log(e.toString(), name: "API_CLIENT_ERROR", isError: true);
      return Response(
          statusCode: 1,
          statusMessage: noInternetMessage,
          requestOptions: RequestOptions());
    }
  }

  Future<Response> postData(
    dynamic body, {
    String? uri,
    Map<String, String>? headers,
    bool? includeToken,
    bool? printLogs = false,
  }) async {
    try {
      dio.httpClientAdapter = NativeAdapter();
      Response res = await dio
          .post(appBaseUrl, data: body)
          .timeout(Duration(seconds: timeoutInSeconds));
      if (printLogs!) Logger().log(jsonEncode(res.data));
      if (res.data['success'] == false && res.data['message'] == "NO_AUTH") {
        await logout();
      }
      return res;
    } catch (e) {
      Logger().log(e.toString(), name: "API_CLIENT_ERROR", isError: true);
      return Response(
          statusCode: 1,
          statusMessage: noInternetMessage,
          requestOptions: RequestOptions());
    }
  }

  logout() {
    var context = Get.find<HomeController>().context;
    Get.deleteAll();
    Navigator.of(context).pop();
  }
}
