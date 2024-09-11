import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/utils/fetch_json.dart';

Future<bool> addToCart(
    String productID, String subtotal, String price, context) async {
  // Function to call WebService to add product to cart
  var userId = await ServiceStorage.getIdUser();
  bool _result = false;

  var _url = Uri.parse("http://23.100.25.47:8010/api/cart/add/$userId/");

  Map _body = {"product_id": productID, "subtotal": subtotal, "price": price};
  var _res = await http.post(_url, body: _body);
  print("Added to cart: " + _res.body);
  print("Added to cart, status: " + _res.statusCode.toString());
  if (_res.statusCode == 200 || _res.statusCode == 201) {
    var _jsonResponse = json.decode(_res.body);
    print("Added to cart, response: " + _jsonResponse.toString());
    _result = true;
  } else if (_res.statusCode == 401 || _res.statusCode == 404) {
    print("Add to cart, Error 401");
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
    print("Add to cart, Error 500");
  }

  return _result;
}

Future<bool> deleteProductFromCart(String cartId, context) async {
  // Function to call WebService to add product to cart
  var userId = await ServiceStorage.getIdUser();
  bool _result = false;

  var _url = Uri.parse("http://23.100.25.47:8010/api/cart/delete/$userId/");

  Map _body = {"cart_id": cartId};
  print(_body);
  EasyLoading.dismiss();
  EasyLoading.show(status: "Eliminando producto del carrito...");
  var _res = await http.delete(_url, body: _body);
  print(_url);
  print(_res.body);
  print(_res.statusCode);
  if (_res.statusCode == 200 || _res.statusCode == 202) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);

    EasyLoading.dismiss();
    _result = true;
  } else if (_res.statusCode == 401 || _res.statusCode == 404) {
    print("Error 401");
    EasyLoading.showError("Ups! Ocurrió un error.",
        duration: const Duration(milliseconds: 2000));
    EasyLoading.dismiss();
    _result = false;
  } else if (_res.statusCode == 500) {
    _result = false;
    print("Error 500");
  }

  return _result;
}

Future<List> fetchMyCart() async {
  var userId = await ServiceStorage.getIdUser();
  String _url = "http://23.100.25.47:8010/api/cart/list?user-id=$userId";

  List<dynamic>? data = await fetchJson(_url);

  return data ?? [];
}

Future<void> clearMyCart() async {
  var userId = await ServiceStorage.getIdUser();
  var _url = Uri.parse("http://23.100.25.47:8010/api/cart/delete-all/$userId/");
  final response = await http.delete(_url);

  if (response.statusCode == 204) {
    debugPrint("Carrito vaciado");
  } else {
    debugPrint("Ocurrió un error al limpiar el carrito");
  }
}

Future calculateShipping(String iDLocationSelected) async {
  // Function to call WebService to calculate shipping
  Map _result = {};

  var _url = Uri.parse(
      "http://23.100.25.47:8010/api/cart/prices/$iDLocationSelected/");
  var _res = await http.get(_url);
  print(_res.body);
  print(_res.statusCode);
  if (_res.statusCode == 200 || _res.statusCode == 201) {
    var _jsonResponse = json.decode(_res.body);
    print(_jsonResponse);
    return _jsonResponse;
  } else if (_res.statusCode == 401 || _res.statusCode == 404) {
    print("Error 401");
    _result = {};
    return {};
  } else if (_res.statusCode == 500) {
    _result = {};
  }

  return _result;
}
