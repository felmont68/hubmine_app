import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> fetchWpPosts() async {
  var _url = Uri.parse("https://hubmine.app/wp-json/wp/v2/posts");
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    var convertDataToJson = json.decode(response.body);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}

Future fetchWPPostImage(href) async {
  var _url = Uri.parse(href);
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    var convertDataToJson = json.decode(response.body);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}

Future fetchCategory(postid) async {
  var _url =
      Uri.parse("https://hubmine.app/wp-json/wp/v2/categories?post=" + postid);
  final response = await http.get(_url);

  if (response.statusCode == 200) {
    var convertDataToJson = json.decode(response.body);
    return convertDataToJson;
  } else {
    print("Ocurrió un error");
    return [];
  }
}
