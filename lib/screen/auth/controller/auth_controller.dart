import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_manager/devices/mtn_mifi.dart';
import 'package:router_manager/main.dart';

final authProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController extends ChangeNotifier {
  bool isLoggedIn = false;
  bool isloading = false;
  TextEditingController passwordCtr = TextEditingController();

  String? _errorMsg;
  String? get errorMsg => _errorMsg;
  set errorMsg(String? value) {
    _errorMsg = value;
    notifyListeners();
  }

  String? authToken;
  String? lockdown_msg;

  bool _disableAuth = false;
  bool get disableAuth => _disableAuth;
  set disableAuth(bool value) {
    _disableAuth = value;
    notifyListeners();
  }

  final Ref ref;
  Device device = Device.MTN_MIFI_4G;

  AuthController(this.ref);

  setAuthStatus(bool value) {
    isLoggedIn = value;
    notifyListeners();
  }

  setDevice(Device value) {
    device = value;
    notifyListeners();
  }

  authenticate() {
    if (device == Device.MTN_MIFI_4G) {
      ref.read(MifiCtrProvider).login(password: passwordCtr.text);
    } else {}
  }
}
