import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List?> fetchJson(String url,
    {List<Map Function(dynamic)>? transformingFunctions}) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Decodificando la respuesta en JSON a UTF-8 para caracteres especiales
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      // Aplicando cada función de transformación, de haber
      return data.map((item) {
        transformingFunctions?.forEach((function) {
          function(item);
        });
        return item;
      }).toList();
    }
    return null;
  } catch (e) {
    print("Error fetching JSON: $e");
  }

  return null;
}
