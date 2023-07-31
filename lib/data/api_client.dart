import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as Http;
import 'package:router_manager/core/app_export.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:get/get_connect/http/src/request/request.dart';

class ApiClient extends GetxService {
  static final String noInternetMessage = 'NoInternetConnection';
  final int timeoutInSeconds = 60;
  Map<String, String>? _mainHeaders;
  final appBaseUrl = '';
  String? token = "";
  final String? customToken;

  ApiClient({this.customToken});

  updateHeader() async {
    _mainHeaders = {
      "Authorization": "Bearer ${token}",
    };
  }

  Future<Response> getData(String uri,
      {Map<String, String>? headers,
      bool? includeToken,
      bool? printLogs = false,
      String? baseUri}) async {
    try {
      if (includeToken == true) {
        await updateHeader();
      } else {
        _mainHeaders = headers;
      }
      if (Foundation.kDebugMode && printLogs!) {
        Logger().log('====> API Call: $uri\nHeader: $_mainHeaders',
            name: "API HEADER:");
      }

      Http.Response _response = await Http.get(
        Uri.parse(baseUri ?? appBaseUrl + uri),
        headers: _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri, printLogs: printLogs);
    } catch (e) {
      Logger().log(e.toString(), name: "API_CLIENT_ERROR", isError: true);
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers,
      bool? includeToken,
      bool? printLogs = false,
      String? baseUri}) async {
    try {
      if (includeToken == true) {
        await updateHeader();
      } else {
        _mainHeaders = headers;
      }
      if (Foundation.kDebugMode) {
        // Logger().log('====> API Call: $uri \nHeader: $_mainHeaders',
        //     name: "API HEADER:");
        if (printLogs!) Logger().log('====> API Body: $body', name: "API DATA");
      }

      Http.Response _response = await Http.post(
        Uri.parse(baseUri ?? appBaseUrl + uri),
        body: body,
        headers: _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri, printLogs: printLogs);
    } catch (e) {
      await Logger().log(e.toString(), name: "API_CLIENT_ERROR", isError: true);
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(Http.Response response, String uri,
      {bool? printLogs = false}) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (
        /*_response.statusCode != 200 &&*/
        _response.body != null && _response.body is! String) {
      _response = Response(
        statusCode: _response.statusCode,
        body: _response.body,
        statusText: _response.statusText,
      );
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(
        statusCode: 0,
        statusText: noInternetMessage,
        body: response.body,
      );
    }
    if (Foundation.kDebugMode) {
      Logger().log('[${_response.statusCode}, ${_response.statusText}], ${uri}',
          name: "API Response");
      if (printLogs!)
        Logger().log('====> API Body: ${response.body}', name: "API RES");
    }
    return _response;
  }
}

class MultipartBody {
  String key;
  File? file;
  Uint8List? bytes;
  MultipartBody(this.key, this.file, {this.bytes});
}
