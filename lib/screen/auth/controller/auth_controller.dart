import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:router_manager/core/app_constant.dart';
import 'package:router_manager/data/api_client.dart';
import 'package:dio/dio.dart';

class AuthController extends GetxController {
  String token = '';
  String sessionID = '';
  TextEditingController password = TextEditingController();

  fetchToken() {}

  login() async {
    final dio = Dio();
    final response = await dio.post('http://192.168.0.1/cgi-bin/http.cgi');
    print(response);
  }
}
