import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> fetchCategories() async {
  var _url = Uri.parse("http://23.100.25.47:8010/api/products/categories/all/");
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    var convertDataToJson = json.decode(response.body);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}

Future<List> fetchStarredProducts() async {
  var _url = Uri.parse("http://23.100.25.47:8010/api/products/favorites/all/");
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

Future<List> fetchProductsByCategory(String category) async {
  print("filter_category=> ${category}");
  var _url = Uri.parse(
      //"http://23.100.25.47:8010/api/products/category?name=" + category);
      'http://23.100.25.47:8010/api/products/category?id=2');
  final response = await http.get(_url);
  //return [];
  if (response.statusCode == 200) {
    String source = const Utf8Decoder().convert(response.bodyBytes);
    var convertDataToJson = json.decode(source);
    return convertDataToJson;
    //return [];
  } else {
    print("Ocurrió un error");
    return [];
  }
}

/*Future<List> fetchProductsById() async {
  var _url = Uri.parse(
      'http://23.100.25.47:8010/api/products/category?id=2');
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    String source = const Utf8Decoder().convert(response.bodyBytes);
    var convertDataToJson = json.decode(source);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}*/


