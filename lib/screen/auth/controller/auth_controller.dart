import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:flutter_curl/flutter_curl.dart';

class AuthController extends GetxController {
  String token = '';
  String sessionID = '';
  TextEditingController password = TextEditingController();

  Client client = Client(verbose: true, interceptors: []);

  fetchToken() {}

  login() async {
    await client.init();
    final response = await client.send(
      Request(url: 'http://192.168.0.1/cgi-bin/http.cgi', method: 'POST'),
    );
    print(response);
  }
}
