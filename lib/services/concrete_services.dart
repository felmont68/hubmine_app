import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mining_solutions/providers/concreto_provider.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:mining_solutions/services/storage_services.dart';

import 'package:provider/provider.dart';

Future<bool> createConcreteOrder(context) async {
  var userId = await ServiceStorage.getIdUser();
  final concretoProvider = Provider.of<ConcretoInfo>(context, listen: false);
  final locationProvider =
      Provider.of<LocationProvider>(context, listen: false);
  bool _result = false;
  var _url = Uri.parse("http://23.100.25.47:8010/api/concrete/order/$userId/");
  Map _body = {
    "concrete_id": concretoProvider.concreteID,
    "contact_name": concretoProvider.contactName,
    "contact_phone": concretoProvider.contactPhone,
    "contact_email": concretoProvider.contactEmail,
    "location_id": locationProvider.iDLocationSelected.toString(),
    "date_delivery": concretoProvider.dateDelivery.toString(),
    "hour_delivery_id": concretoProvider.hourDeliveryID.toString(),
    "cuantity": concretoProvider.cuantity,
    "cuantity_by_truck": concretoProvider.cuantityByTruck,
    "n_truck": concretoProvider.numberOfTrucks,
    "time_between_truck": concretoProvider.timeBTID,
    "list_addons": concretoProvider.addons.toString()
  };
  EasyLoading.show(status: "Creando orden...");
  var _res = await http.post(_url, body: _body);
  String source = const Utf8Decoder().convert(_res.bodyBytes);
  var _jsonResponse = json.decode(source);
  print(_jsonResponse);
  if (_res.statusCode == 201) {
    EasyLoading.showSuccess("Orden creada exitosamente");
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
