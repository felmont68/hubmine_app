import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mining_solutions/services/storage_services.dart';
import '../models/location_data.dart';

class ServiceDirections {
  static fetchDirectionsAll() async {
    List<LocationData> _result = [];
    int _id = await ServiceStorage.getIdUser();

    final _response = await http.get(Uri.parse(
        'http://23.100.25.47:8010/api/locations/details/' + _id.toString()));

    if (_response.statusCode == 200 || _response.statusCode == 404) {
      final _dataResult = json.decode(_response.body);
      if (_dataResult['locations'] != 'Locaciones no encontradas') {
        final data = _dataResult['locations']!.cast<Map<String, dynamic>>();
        return data
            .map<LocationData>((json) => LocationData.fromMap(json))
            .toList();
      } else {
        return _result;
      }
    } else {
      throw Exception('Failed to load data for directions');
    }
  }

  static saveDirection(LocationData data) async {
    bool _result = false;
    int _id = await ServiceStorage.getIdUser();
    var _url = Uri.parse("http://23.100.25.47:8010/api/locations/create/" +
        _id.toString() +
        "/");

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var _res = await http.post(
      _url,
      body: data.toJson(),
      headers: requestHeaders,
    );

    if (_res.statusCode == 201) {
      _result = true;
    } else if (_res.statusCode == 401) {
      _result = false;
    } else if (_res.statusCode == 500) {
      _result = false;
    }
    return _result;
  }

  static deleteDirection(int idDirection) async {
    bool _result = false;
    var _url = Uri.parse("http://23.100.25.47:8010/api/locations/delete/" +
        idDirection.toString() +
        "/");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var _res = await http.delete(
      _url,
      headers: requestHeaders,
    );
    if (_res.statusCode == 201 || _res.statusCode == 204) {
      _result = true;
    } else if (_res.statusCode == 401) {
      _result = false;
    } else if (_res.statusCode == 500) {
      _result = false;
    }
    return _result;
  }

  static updateDirection(
    LocationData data,
  ) async {
    bool _result = false;
    var _url = Uri.parse("http://23.100.25.47:8010/api/locations/update/" +
        data.id.toString() +
        "/");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var _res = await http.put(
      _url,
      body: data.toJson(),
      headers: requestHeaders,
    );
    if (_res.statusCode == 200) {
      _result = true;
    } else if (_res.statusCode == 401) {
      _result = false;
    } else if (_res.statusCode == 500) {
      _result = false;
    }
    return _result;
  }

  static editDirection(LocationData data) async {
    bool _result = false;
    var _url = Uri.parse("http://23.100.25.47:8010/api/locations/update/" +
        data.id.toString() +
        "/");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var _res = await http.post(
      _url,
      body: data.toJson(),
      headers: requestHeaders,
    );
    if (_res.statusCode == 201) {
      _result = true;
    } else if (_res.statusCode == 401) {
      _result = false;
    } else if (_res.statusCode == 500) {
      _result = false;
    }
    return _result;
  }
}
