import 'package:flutter/material.dart';

class VerificationCodeInfo with ChangeNotifier {
  String countryCode = "";
  String _phone = "";
  String _code = "";

  String get phone {
    return _phone;
  }

  set phone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  String get code {
    return _code;
  }

  set code(String code) {
    _code = code;
    notifyListeners();
  }
}
