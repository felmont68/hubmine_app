import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mining_solutions/demo/screens/home.dart';
import 'package:mining_solutions/models/user.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/vAlpha/home_page_alpha.dart';

import 'package:mining_solutions/services/storage_services.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> signInDummy() async {
  bool _result = false;
  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/login/");
  Map _body = {"email": 'omar.ramirez@hubmine.mx', "password": 'omar'};
  var _res = await http.post(_url, body: _body);
  if (_res.statusCode == 200) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    ServiceStorage.saveDataUser(User.fromMap(_jsonResponse));
    _result = true;
  } else if (_res.statusCode == 401) {
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
  }
  return _result;
}

Future<bool> signIn(String email, String password, context) async {
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  bool _result = false;
  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/login/");
  Map _body = {"email": email, "password": password};
  EasyLoading.show(status: "Cargando...");
  var _res = await http.post(_url, body: _body);
  if (_res.statusCode == 200) {
    String source = const Utf8Decoder().convert(_res.bodyBytes);
    var _jsonResponse = json.decode(source);
    print(_jsonResponse);
    userInfo.hasLoggedIn = true;
    ServiceStorage.saveHasLoggedIn(true);
    ServiceStorage.saveDataUser(User.fromMap(_jsonResponse));

    if (_jsonResponse['customer_type_id'] != 3) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()),
          (Route<dynamic> route) => false);
    } else {
      if (_jsonResponse['user_type_id'] == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeDriver()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePageAlpha()),
            (Route<dynamic> route) => false);
      }
    }

    EasyLoading.showSuccess("Bienvenido");

    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    print("Error 401");
    EasyLoading.showError("Ups! Ocurrió un error. Código inválido",
        duration: const Duration(milliseconds: 2000));
    EasyLoading.dismiss();
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<bool> logoutDumy() async {
  bool _result = false;
  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/logout/");
  Map _body = {"email": 'omar.ramirez@hubmine.mx'};
  var _res = await http.post(_url, body: _body);
  if (_res.statusCode == 200) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    ServiceStorage.clearSharedPreferences();
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
  }
  return _result;
}

Future<bool> logout(context) async {
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  bool _result = false;
  String email = await ServiceStorage.getEmail();
  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/logout/");
  Map _body = {"email": email};
  EasyLoading.show(status: "Cerrando sesión...");
  var _res = await http.post(_url, body: _body);
  print(_res);
  if (_res.statusCode == 200) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    userInfo.hasLoggedIn = false;

    ServiceStorage.clearSharedPreferences();
    ServiceStorage.saveHasLoggedIn(false);
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    print("Error 401");
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
  } else if (_res.statusCode == 500) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
    print("Error 500");
  }
  return _result;
}

Future<bool> sendOtp(
  String phone,
) async {
  // Function to call WebService to send OTP Code
  bool _result = false;

  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/send/");
  Map _body = {"number": phone};
  print(_body);
  EasyLoading.show(status: "Enviando código...");
  var _res = await http.post(_url, body: _body);
  print(_res.statusCode);
  if (_res.statusCode == 200) {
    print("Hola! Enviado el código");
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401 || _res.statusCode == 404) {
    EasyLoading.showError(
        "No existe una cuenta asociada a ese número. Verifique su información.",
        duration: const Duration(milliseconds: 3000));
    print("Error 401");
    _result = false;
  } else if (_res.statusCode == 500) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<bool> sendOtpRegister(
  String phone,
) async {
  // Function to call WebService to send OTP Code
  bool _result = false;

  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/send_register/");
  Map _body = {"number": phone};
  print(_body);
  EasyLoading.show(status: "Enviando código...");
  var _res = await http.post(_url, body: _body);
  print(_res.statusCode);
  if (_res.statusCode == 200 || _res.statusCode == 201) {
    print("Hola! Enviado el código");
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    EasyLoading.showError("Ups! Algo salió mal",
        duration: const Duration(milliseconds: 3000));
    print("Error 401");
    _result = false;
  } else if (_res.statusCode == 500) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<bool> verificateOTPToCreateAccount(
    String code, String number, context) async {
  // Function to call WebService to send OTP Code
  bool _result = false;

  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/validate/");

  Map _body = {"code": code, "number": number};
  EasyLoading.dismiss();
  EasyLoading.show(status: "Verificando código...");
  var _res = await http.post(_url, body: _body);
  if (_res.statusCode == 200 || _res.statusCode == 202) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);

    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401 || _res.statusCode == 404) {
    EasyLoading.showError("Ups! Ocurrió un error. Código inválido",
        duration: const Duration(milliseconds: 2000));
    EasyLoading.dismiss();
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
  }

  return _result;
}

Future<bool> verificateOTP(String code, String phone, context) async {
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  // Function to call WebService to send OTP Code
  bool _result = false;
  print(code);

  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/login_phone/");

  Map _body = {"number": phone, "code": code};
  print(_body);
  EasyLoading.dismiss();
  EasyLoading.show(status: "Verificando código...");
  var _res = await http.post(_url, body: _body);
  print(_res.body);
  if (_res.statusCode == 200) {
    String source = const Utf8Decoder().convert(_res.bodyBytes);
    var _jsonResponse = json.decode(source);
    print(_jsonResponse);
    userInfo.hasLoggedIn = true;
    ServiceStorage.saveHasLoggedIn(true);
    ServiceStorage.saveDataUser(User.fromMap(_jsonResponse));

    if (_jsonResponse['customer_type_id'] != 3) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()),
          (Route<dynamic> route) => false);
    } else {
      if (_jsonResponse['user_type_id'] == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeDriver()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePageAlpha()),
            (Route<dynamic> route) => false);
      }
    }

    EasyLoading.showSuccess("Bienvenido");

    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    print("Error 401");
    EasyLoading.showError("Ups! Ocurrió un error. Código inválido",
        duration: const Duration(milliseconds: 2000));
    EasyLoading.dismiss();
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<bool> loadInfoUserProfile(context) async {
  var token = await ServiceStorage.getToken();
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  print("Llamando la info del perfil");
  bool _result = false;
  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/profile/");
  Map _body = {"token": token};
  var _res = await http.post(_url, body: _body);
  print(_res.body);
  if (_res.statusCode == 200) {
    String source = const Utf8Decoder().convert(_res.bodyBytes);
    var _jsonResponse = json.decode(source);
    ServiceStorage.saveDataUser(User.fromMap(_jsonResponse));
    userInfo.uid = _jsonResponse['id'];
    userInfo.firstName = _jsonResponse['first_name'];
    userInfo.lastName = _jsonResponse['last_name'];
    userInfo.email = _jsonResponse['email'];
    userInfo.phone = _jsonResponse['phone_number'];
    userInfo.businessName = _jsonResponse['business_name'];
    userInfo.bussinessType = _jsonResponse['business_type'];
    userInfo.profilePhotoPath = _jsonResponse['profile_photo'];
    userInfo.rfc = _jsonResponse['rfc'];
    userInfo.userTypeId = _jsonResponse['user_type_id'];
    userInfo.statusAccountId = _jsonResponse['status_account_id'];
    userInfo.hasLoggedIn = true;

    _result = true;
  } else if (_res.statusCode == 401) {
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
  }
  return _result;
}

Future<bool> updateProfile(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String businessName,
    String rfc,
    context) async {
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  bool _result = false;
  var token = await ServiceStorage.getToken();
  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/profile/update/");
  Map _body = {
    "token": token,
    "first_name": firstName,
    "last_name": lastName,
    "phone_number": phoneNumber,
    "email": email,
    "business_name": businessName,
    "rfc": rfc
  };
  EasyLoading.show(status: "Actualizando perfil...");
  var _res = await http.put(_url, body: _body);
  if (_res.statusCode == 200) {
    EasyLoading.showSuccess("Perfil actualizado.");
    String source = const Utf8Decoder().convert(_res.bodyBytes);
    var _jsonResponse = json.decode(source);
    print(_jsonResponse);
    userInfo.uid = _jsonResponse['id'];
    userInfo.firstName = _jsonResponse['first_name'];
    userInfo.lastName = _jsonResponse['last_name'];
    userInfo.email = _jsonResponse['email'];
    userInfo.phone = _jsonResponse['phone_number'];
    userInfo.businessName = _jsonResponse['business_name'];
    userInfo.bussinessType = _jsonResponse['business_type'];
    userInfo.userTypeId = _jsonResponse['user_type_id'];
    userInfo.statusAccountId = _jsonResponse['status_account_id'];
    userInfo.customerTypeID = _jsonResponse['customer_type_id'];

    userInfo.rfc = _jsonResponse['rfc'];
    ServiceStorage.saveDataUser(User.fromMap(_jsonResponse));
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
  } else if (_res.statusCode == 500) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
  }
  return _result;
}

Future<bool> deleteAccount() async {
  var token = await ServiceStorage.getToken();
  var userId = await ServiceStorage.getIdUser();
  bool _result = false;
  var _url =
      Uri.parse("http://23.100.25.47:8010/api/auth/profile/delete/$userId/");
  Map _body = {"token": token};
  EasyLoading.show(status: "Eliminando cuenta...");
  var _res = await http.delete(_url, body: _body);
  if (_res.statusCode == 200) {
    EasyLoading.showSuccess("Tu cuenta ha sido eliminada");
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    ServiceStorage.clearSharedPreferences();
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
  } else if (_res.statusCode == 500) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
  }
  return _result;
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<Map> uploadPhoto(file, userInfo) async {
  final SharedPreferences prefs = await _prefs;
  // var token = await ServiceStorage.getToken();
  var userId = await ServiceStorage.getIdUser();
  print(file);
  bool _result = false;
  var _url = Uri.parse(
      "http://23.100.25.47:8010/api/auth/profile/upload_photo/$userId/");
  // Map _body = {"token": token};
  final headers = {"Content-type": "multipart/form-data"};

  var request = http.MultipartRequest("POST", _url);
  if (file == null) {
    _result = false;
  } else {
    EasyLoading.show(status: "Actualizando foto de perfil");
    request.files.add(http.MultipartFile(
        'file', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();

    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    await prefs.setString("profilePhoto", resJson['profile_photo']);
    print(resJson);
    userInfo.profilePhotoPath = resJson['profile_photo'];
    EasyLoading.showSuccess("Tu foto de perfil ha sido actualizada");
    _result = true;
  }
  Map response = {"isOk": _result, "photo": userInfo.profilePhotoPath};
  return response;
}

Future<bool> sendCodeToRecoveryPassword(String email) async {
  bool _result = false;

  var _url = Uri.parse("http://23.100.25.47:8010/api/password_reset/");
  Map _body = {"email": email};
  print(_body);
  EasyLoading.show(status: "Enviando código...");
  var _res = await http.post(_url, body: _body);
  print(_res.statusCode);
  if (_res.statusCode == 200) {
    print("Hola! Enviado el código");
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401 || _res.statusCode == 400) {
    EasyLoading.showError(
        "No existe una cuenta asociada a ese email. Verifique su información.",
        duration: const Duration(milliseconds: 3000));
    print("Error 401");
    _result = false;
  } else if (_res.statusCode == 500) {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<bool> verificateCodeToRecoveryPassword(String code, context) async {
  // Function to call WebService to send OTP Code
  bool _result = false;
  print(code);

  var _url =
      Uri.parse("http://23.100.25.47:8010/api/password_reset/validate_token/");

  Map _body = {"token": code};
  print(_body);
  EasyLoading.dismiss();
  EasyLoading.show(status: "Verificando código...");
  var _res = await http.post(_url, body: _body);
  print(_res.body);
  print(_res.statusCode);
  if (_res.statusCode == 200) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);

    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401 || _res.statusCode == 404) {
    print("Error 401");
    EasyLoading.showError("Ups! Ocurrió un error. Código inválido",
        duration: const Duration(milliseconds: 2000));
    EasyLoading.dismiss();
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<bool> saveNewPassword(String password, String token, context) async {
  // Function to call WebService to send OTP Code
  bool _result = false;

  var _url = Uri.parse("http://23.100.25.47:8010/api/password_reset/confirm/");

  Map _body = {"token": token, "password": password};
  print(_body);
  EasyLoading.dismiss();
  EasyLoading.show(status: "Actualizando contraseña");
  var _res = await http.post(_url, body: _body);
  print(_res.body);
  if (_res.statusCode == 200) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    EasyLoading.showSuccess("Contraseña actualizada exitosamente");
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    print("Error 401");
    EasyLoading.showError("Ups! Ocurrió un error. Código inválido",
        duration: const Duration(milliseconds: 2000));
    EasyLoading.dismiss();
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<bool> loginWithToken(String token, BuildContext context) async {
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  bool _result = false;
  var _url = Uri.parse("http://23.100.25.47:8010/api/auth/login/");
  Map<String, String> _headers = {"Authorization": "Token ${token}"};
  EasyLoading.show(status: "Cargando...");
  var _res = await http.post(_url, body: {}, headers: _headers);
  if (_res.statusCode == 200) {
    String source = const Utf8Decoder().convert(_res.bodyBytes);
    var _jsonResponse = json.decode(source);
    print(_jsonResponse);
    userInfo.hasLoggedIn = true;
    ServiceStorage.saveHasLoggedIn(true);
    ServiceStorage.saveDataUser(User.fromMap(_jsonResponse));
    if (_jsonResponse['customer_type_id'] != 3) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()),
          (Route<dynamic> route) => false);
    } else {
      if (_jsonResponse['user_type_id'] == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeDriver()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePageAlpha()),
            (Route<dynamic> route) => false);
      }
    }

    EasyLoading.showSuccess("Bienvenido");
    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401) {
    print("Error 401");
    EasyLoading.showError("Ups! Ocurrió un error. Código inválido",
        duration: const Duration(milliseconds: 2000));
    EasyLoading.dismiss();
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<String?> getFirstName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('firstName');
}