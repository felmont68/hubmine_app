import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/providers/directions_provider.dart';
import 'package:provider/provider.dart';

import "package:google_maps_webservice/directions.dart" as dir;

import 'package:permission_handler/permission_handler.dart';

class DemoMaps extends StatefulWidget {
  const DemoMaps({Key? key}) : super(key: key);

  @override
  _DemoMapsState createState() => _DemoMapsState();
}

class _DemoMapsState extends State<DemoMaps> {
  final LatLng fromPoint = const LatLng(25.696764, -100.380671);
  final LatLng toPoint = const LatLng(25.6939364, -100.3782016);

  requestPermissions() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      // We didn't ask for permission yet.

    }

    // You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.

    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
      //print(statuses[Permission.location]);
    }
  }

  GoogleMapController? _mapController;

  Set<Marker> _createMarkers() {
    var tmp = <Marker>{};
    tmp.add(Marker(
      markerId: const MarkerId("fromPoint"),
      position: fromPoint,
      infoWindow: const InfoWindow(title: "Tú estás aquí"),
    ));

    tmp.add(Marker(
        markerId: const MarkerId("toPoint"),
        position: toPoint,
        infoWindow: const InfoWindow(title: "Tu destino")));

    return tmp;
  }

  // TODO Extraer esta lógica
  Set<Polyline> _route = {};
  dir.GoogleMapsDirections directionsApi = dir.GoogleMapsDirections(
      apiKey: "AIzaSyBA6tLHw8UqDot-6cPCRtiICDHDQEdfZdw");
  findDirections(LatLng from, LatLng to) async {
    var origin = dir.Location(lat: from.latitude, lng: from.longitude);
    var destination = dir.Location(lat: to.latitude, lng: to.longitude);

    var result = await directionsApi.directionsWithLocation(
      origin,
      destination,
      travelMode: dir.TravelMode.walking,
    );

    Set<Polyline> newRoute = {};

    if (result.isOkay) {
      var route = result.routes[0];
      var leg = route.legs[0];

      List<LatLng> points = [];

      for (var step in leg.steps) {
        points.add(LatLng(step.startLocation.lat, step.startLocation.lng));
        points.add(LatLng(step.endLocation.lat, step.endLocation.lng));
      }

      var line = Polyline(
        jointType: JointType.bevel,
        points: points,
        geodesic: true,
        polylineId: const PolylineId("mejor ruta"),
        color: Colors.teal,
        width: 4,
      );
      newRoute.add(line);

      //print(newRoute);

      _route = newRoute;
    } else {
      //print("ERRROR !!! ${result.status}");
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    findDirections(fromPoint, toPoint);

    _centerView();
  }

  _centerView() async {
    await _mapController?.getVisibleRegion();
    findDirections(fromPoint, toPoint);
    //await api.findDirections(fromPoint, toPoint);

    var left = min(fromPoint.latitude, toPoint.latitude);
    var right = max(fromPoint.latitude, toPoint.latitude);
    var top = max(fromPoint.longitude, toPoint.longitude);
    var bottom = min(fromPoint.longitude, toPoint.longitude);

    var bounds = LatLngBounds(
        northeast: LatLng(right, top), southwest: LatLng(left, bottom));

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 90);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final apiMaps = Provider.of<DirectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryClr,
        title: const Text("Hubmine Demo Ruta"),
      ),
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: fromPoint, zoom: 14),
          markers: _createMarkers(),
          onMapCreated: _onMapCreated,
          polylines: _route,
          myLocationEnabled: true,
          myLocationButtonEnabled: true),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.zoom_out_map),
        onPressed: _centerView,
      ),
    );
  }
}
