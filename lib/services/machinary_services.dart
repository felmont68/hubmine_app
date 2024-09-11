import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

Future<List> fetchMachinary() async {
  var _url = Uri.parse("http://23.100.25.47:8010/api/machinery/all");
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    String source = const Utf8Decoder().convert(response.bodyBytes);
    var convertDataToJson = json.decode(source);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}

Future<List> fetchMachinaryByBrand(String mark) async {
  var _url =
      Uri.parse("http://23.100.25.47:8010/api/machinery/list?mark=" + mark);
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    String source = const Utf8Decoder().convert(response.bodyBytes);
    var convertDataToJson = json.decode(source);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}

Future<bool> createRentQuotation(
    bool isRenting,
    String productID,
    String unityTimeID,
    String useTime,
    String locationSelectedID,
    String firstName,
    String lastName,
    String email,
    String phone,
    context) async {
  bool _result = false;
  var _url =
      Uri.parse("http://23.100.25.47:8010/api/machinery/create-quotation");
  Map _body = {};
  if (isRenting) {
    _body = {
      "machinery_id": productID,
      "service_type_id": "2",
      "unity_time_id": unityTimeID,
      "use_time": useTime,
      "name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phone,
      "location_id": locationSelectedID
    };
  } else {
    _body = {
      "machinery_id": productID,
      "service_type_id": "1",
      "name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phone,
      "location_id": locationSelectedID
    };
  }

  EasyLoading.show(status: "Enviando formulario...");
  var _res = await http.post(_url, body: _body);
  String source = const Utf8Decoder().convert(_res.bodyBytes);
  var _jsonResponse = json.decode(source);
  print(_jsonResponse);
  if (_res.statusCode == 201 || _res.statusCode == 200) {
    EasyLoading.showSuccess("Solicitud recibida");
    String source = const Utf8Decoder().convert(_res.bodyBytes);
    var _jsonResponse = json.decode(source);
    print(_jsonResponse);
    EasyLoading.dismiss();
    _result = true;
  } else {
    EasyLoading.showError("Ups! Ocurrió un error...",
        duration: const Duration(milliseconds: 3000));
    _result = false;
  }
  return _result;
}
