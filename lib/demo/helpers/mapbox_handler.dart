import 'package:mapbox_gl/mapbox_gl.dart';

import '../requests/mapbox_directions.dart';
import '../requests/mapbox_rev_geocoding.dart';
import '../requests/mapbox_search.dart';

// ----------------------------- Mapbox Search Query -----------------------------
String getValidatedQueryFromQuery(String query) {
  // Remove whitespaces
  String validatedQuery = query.trim();
  return validatedQuery;
}

Future<List> getParsedResponseForQuery(String value, context) async {
  List parsedResponses = [];

  // Si la consulta es vacía, devolver respuesta vacía
  String query = getValidatedQueryFromQuery(value);
  if (query == '') return parsedResponses;

  // Buscar y enviar respuesta
  var response = await getSearchResultsFromQueryUsingMapbox(query);

  // Validar que la respuesta y 'features' no sean null
  if (response != null && response.containsKey('features')) {
    List features = response['features'];
    for (var feature in features) {
      Map response = {
        'name': feature['text'],
        'address': feature['place_name'].split('${feature['text']}, ')[0],
        'place': feature['place_name'],
        'location': LatLng(feature['center'][1], feature['center'][0]),
        'lat': feature['center'][1],
        'long': feature['center'][0]
      };
      parsedResponses.add(response);
    }
  }

  return parsedResponses;
}

// ----------------------------- Mapbox Reverse Geocoding -----------------------------

Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
  Map revGeocode = {};

  var response = await getReverseGeocodingGivenLatLngUsingMapbox(latLng);

  // Validar que la respuesta y 'features' no sean null y que 'features' no esté vacío
  if (response != null && response.containsKey('features') && response['features'].isNotEmpty) {
    Map feature = response['features'][0];
    print(feature);
    revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[0],
      'place': feature['place_name'],
      'location': latLng
    };
  } else {
    print("No se encontraron resultados para la geocodificación inversa.");
  }

  return revGeocode;
}
// ----------------------------- Mapbox Directions API -----------------------------

Future<Map> getDirectionsAPIResponse(
    LatLng sourceLatLng, LatLng destinationLatLng) async {
  Map modifiedResponse = {};

  final response =
      await getCyclingRouteUsingMapbox(sourceLatLng, destinationLatLng);

  // Validar que la respuesta no sea null, que contenga 'routes' y que 'routes' no esté vacío
  if (response != null && response.containsKey('routes') && response['routes'].isNotEmpty) {
    Map geometry = response['routes'][0]['geometry'];
    num duration = response['routes'][0]['duration'];
    num distance = response['routes'][0]['distance'];

    modifiedResponse = {
      "geometry": geometry,
      "duration": duration,
      "distance": distance,
    };
  } else {
    print("No se encontraron rutas para los puntos proporcionados.");
  }

  return modifiedResponse;
}

LatLng getCenterCoordinatesForPolyline(Map geometry) {
  if (geometry == null || !geometry.containsKey('coordinates') || geometry['coordinates'].isEmpty) {
    // Retorna una coordenada predeterminada o lanza una excepción si se prefiere
    return const LatLng(0, 0); // Puedes cambiar esto por un valor predeterminado adecuado
  }

  List coordinates = geometry['coordinates'];
  int pos = (coordinates.length / 2).round();

  // Asegúrate de que la posición calculada esté dentro de los límites de la lista
  if (pos >= coordinates.length) {
    pos = coordinates.length - 1; // Ajuste para evitar un índice fuera de rango
  }

  return LatLng(coordinates[pos][1], coordinates[pos][0]);
}