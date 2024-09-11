import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ServiceLocation {
  static getCurrentLocation(BuildContext context) async {
    final _statusLocation = await Permission.location.request();
    location.Location _locationService = location.Location();
    switch (_statusLocation) {
      case PermissionStatus.granted:
        await _locationService.requestService();
        Position _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> _placemark = await GeocodingPlatform.instance
            .placemarkFromCoordinates(
                _position.latitude.toDouble(), _position.longitude.toDouble());
        Provider.of<LocationProvider>(context, listen: false).setStreetName(
          _placemark[0].street.toString(),
        );
        Provider.of<LocationProvider>(context, listen: false).setCityName(
          _placemark[0].locality.toString(),
        );
        Provider.of<LocationProvider>(context, listen: false).setStateName(
          _placemark[0].administrativeArea.toString(),
        );

        Provider.of<LocationProvider>(context, listen: false)
            .setCurrentLatitude(
          _position.latitude.toDouble(),
        );

        Provider.of<LocationProvider>(context, listen: false)
            .setCurrentLongitude(
          _position.longitude.toDouble(),
        );
        break;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        openAppSettings();
        // You can request multiple permissions at once.
        break;
    }
  }

  static requestPermissions(BuildContext context) async {
    final _statusLocation = await Permission.location.request();
    location.Location _locationService = location.Location();
    switch (_statusLocation) {
      case PermissionStatus.granted:
        await _locationService.requestService();
        break;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        openAppSettings();
        // You can request multiple permissions at once.
        break;
    }
  }
}

Future fetchLocationDetails(String iDLocationSelected) async {
  var _url = Uri.parse(
      "http://23.100.25.47:8010/api/locations/detail/$iDLocationSelected");
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
