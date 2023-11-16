// ignore_for_file: unnecessary_brace_in_string_interps, prefer_const_declarations

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:router_manager/core/app_export.dart';

class ApiClient {
  static final String noInternetMessage = 'NoInternetConnection';
  final int timeoutInSeconds = 2;
  final String appBaseUrl;
  String? token = "";
  Map<String, String>? _mainHeaders;

  ApiClient(this.appBaseUrl);

  updateHeader() async {
    token = "";
    if (token == null) return;
    _mainHeaders = {
      "Authorization": "Bearer ${token}",
    };
  }

  Future<Response> getData(
    String uri, {
    Map<String, String>? headers,
    bool? includeToken,
    bool? printLogs = false,
  }) async {
    try {
      if (includeToken == true) {
        await updateHeader();
      } else {
        _mainHeaders = headers;
      }
      if (kDebugMode && printLogs!) {
        Logger().log('==> $uri', name: "API ENDPOINT");
      }

      Response res = await Dio().get(
        appBaseUrl + uri,
        options: Options(
          headers: _mainHeaders,
          receiveTimeout: Duration(seconds: 2),
          sendTimeout: Duration(seconds: timeoutInSeconds),
        ),
      );

      if (printLogs!) {
        Logger().log("==> ${res.data}", name: '${res.statusCode}:$uri');
      }
      return res;
    } on DioException catch (e) {
      Logger().log(e.response?.data ?? noInternetMessage,
          name: "API_CLIENT_ERROR:${appBaseUrl}${uri}", isError: true);
      if (e.response == null) {
        return Response(
            data: noInternetMessage, requestOptions: e.requestOptions);
      } else {
        return Response(
            data: e.response?.data,
            statusCode: e.response?.statusCode,
            requestOptions: e.requestOptions);
      }
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
      if (includeToken == true) {
        await updateHeader();
      } else {
        _mainHeaders = headers;
      }
      if (kDebugMode && printLogs!) {
        Logger().log('==> $uri', name: "API ENDPOINT");
      }

      Response res = await Dio()
          .post(
            "$appBaseUrl${uri ?? ''}",
            options: Options(
              headers: _mainHeaders,
              receiveTimeout: Duration(seconds: timeoutInSeconds),
              sendTimeout: Duration(seconds: timeoutInSeconds),
            ),
            data: body,
          )
          .timeout(Duration(seconds: timeoutInSeconds),
              onTimeout: () => Response(
                  requestOptions: RequestOptions(),
                  statusCode: 404,
                  data: {'message': 'Could not reach the server'}));

      if (printLogs!) {
        Logger().log("==> ${res.data}", name: '${res.statusCode}:$uri');
      }

      return res;
    } on DioException catch (e) {
      Logger().log(e.response?.data ?? noInternetMessage,
          name: "API_CLIENT_ERROR:${appBaseUrl}${uri}", isError: true);
      if (e.response == null) {
        return Response(
            data: noInternetMessage, requestOptions: e.requestOptions);
      } else {
        return Response(
            data: e.response?.data,
            statusCode: e.response?.statusCode,
            requestOptions: e.requestOptions);
      }
    }
  }
}

class MultipartBody {
  String key;
  File? file;
  Uint8List? bytes;
  MultipartBody(this.key, this.file, {this.bytes});
}
