import 'dart:convert';

import 'package:mining_solutions/screens/driver/services/driver_storage_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mining_solutions/providers/user_info_provider.dart';

Future<bool> loadOnlineStatusAPI(context) async {
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  final idUser = await ServiceStorage.getIdUser();
  bool _result = false;
  var _url = Uri.parse(
      "http://23.100.25.47:8010/api/hubbers/is_online/" + idUser.toString());
  print(_url);
  var _res = await http.get(_url);
  print(_res.body);
  if (_res.statusCode == 200) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    userInfo.isOnline = _jsonResponse['is_connect'];
    DriverServiceStorage.saveOnlineStatus(_jsonResponse['is_connect']);

    _result = true;
  } else if (_res.statusCode == 401) {
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
  }
  return _result;
}

Future<bool> updateOnlineStatus(context, bool status) async {
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  final idUser = await ServiceStorage.getIdUser();
  bool _result = false;
  var _url = Uri.parse("http://23.100.25.47:8010/api/hubbers/is_online/" +
      idUser.toString() +
      "/");
  print(_url);
  final _body = {"is_connect": status.toString()};
  var _res = await http.post(_url, body: _body);

  if (_res.statusCode == 200) {
    var _jsonResponse = json.decode(_res.body);

    userInfo.isOnline = _jsonResponse['is_connect'];
    DriverServiceStorage.saveOnlineStatus(_jsonResponse['is_connect']);

    _result = true;
  } else if (_res.statusCode == 401) {
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
  }
  return _result;
}
