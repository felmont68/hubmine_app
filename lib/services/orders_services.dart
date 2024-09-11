import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/services/storage_services.dart';

import 'package:provider/provider.dart';

Future createOrder(
    String iDLocationSelected,
    String unityType,
    String materialID,
    String quantity,
    String price,
    String priceShipping,
    String subtotal,
    String iva,
    String total,
    context) async {
  // Function to call WebService to add product to cart
  var userId = await ServiceStorage.getIdUser();
  Map _result = {};
  final userInfo = Provider.of<UserInfo>(context, listen: false);
  var idTimeShipping = userInfo.hourDeliveryID;
  var dateShipping = userInfo.dateShipping;
  String dateTimeFormat = DateFormat("yyyy-MM-dd").format(dateShipping);

  var _url = Uri.parse("http://23.100.25.47:8010/api/cart/new-order/$userId/");

  Map _body = {
    "location_id": iDLocationSelected,
    "unity_type": unityType,
    "quantity": quantity,
    "material_id": materialID,
    "price": price,
    "price_shipping": priceShipping,
    "subtotal": subtotal,
    "iva": iva,
    "total": total,
    "observations": "",
    "date_delivery": dateTimeFormat,
    "hour_delivery_id": idTimeShipping
  };
  var _res = await http.post(_url, body: _body);
  if (_res.statusCode == 200 || _res.statusCode == 201) {
    var _jsonResponse = json.decode(_res.body);
    _result = _jsonResponse;
  } else if (_res.statusCode == 401 || _res.statusCode == 404) {
    print("Error 401");
    _result = {};
  } else if (_res.statusCode == 500) {
    _result = {};
    print("Error 500");
  }

  return _result;
}

Future<List> fetchOrders() async {
  var userId = await ServiceStorage.getIdUser();
  var _url = Uri.parse("http://23.100.25.47:8010/api/cart/orders?user=$userId");
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    String source = const Utf8Decoder().convert(response.bodyBytes);
    var convertDataToJson = json.decode(source);
    print(convertDataToJson);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}

Future fetchDetailOrder(String idOrder) async {
  var _url =
      Uri.parse("http://23.100.25.47:8010/api/cart/orders/details/$idOrder/");
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    String source = const Utf8Decoder().convert(response.bodyBytes);
    var convertDataToJson = json.decode(source);
    print(convertDataToJson);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}

Future<Map> fetchPO(String idOrder) async {
  var _url = Uri.parse(
      "http://23.100.25.47:8010/api/cart/purchase-order/details/$idOrder/");
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    String source = const Utf8Decoder().convert(response.bodyBytes);
    var convertDataToJson = json.decode(source);

    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return {};
  }
}
