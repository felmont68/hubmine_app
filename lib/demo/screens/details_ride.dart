import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mining_solutions/demo/helpers/commons.dart';
import 'package:mining_solutions/demo/helpers/mapbox_handler.dart';
import 'package:mining_solutions/demo/helpers/shared_prefs.dart';
import 'package:mining_solutions/demo/widgets/review_ride_bottom_sheet.dart';
import 'package:mining_solutions/hubkens/colors.dart';

class DetailsRide extends StatefulWidget {
  final VoidCallback agreeTrip;
  final bool hasAgreeTrip;
  final Map modifiedResponse;
  final Map orderDetails;
  final String time;
  const DetailsRide(
      {Key? key,
      required this.agreeTrip,
      required this.hasAgreeTrip,
      required this.modifiedResponse,
      required this.orderDetails,
      required this.time})
      : super(key: key);

  @override
  State<DetailsRide> createState() => _DetailsRideState();
}

class _DetailsRideState extends State<DetailsRide> {
  // Mapbox Maps SDK related
  final List<CameraPosition> _kTripEndPoints = [];
  late MapboxMapController controller;
  late CameraPosition _initialCameraPosition;

  // Directions API response related
  late String distance;
  late String dropOffTime;
  late String duration;
  late Map geometry;

  @override
  void initState() {
    // initialise distance, dropOffTime, geometry
    _initialiseDirectionsResponse();

    // initialise initialCameraPosition, address and trip end points
    _initialCameraPosition = CameraPosition(
        target: getCenterCoordinatesForPolyline(geometry), zoom: 10);

    for (String type in ['source', 'destination']) {
      _kTripEndPoints
          .add(CameraPosition(target: getTripLatLngFromSharedPrefs(type)));
    }
    super.initState();
  }

  _initialiseDirectionsResponse() {
    distance = (widget.modifiedResponse['distance'] / 1000).toStringAsFixed(1);
    dropOffTime = getDropOffTime(widget.modifiedResponse['duration']);
    geometry = widget.modifiedResponse['geometry'];
    duration = getDurationTrip(widget.modifiedResponse['duration']);
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    for (int i = 0; i < _kTripEndPoints.length; i++) {
      String iconImage = i == 0 ? 'circle' : 'square';
      await controller.addSymbol(
        SymbolOptions(
          geometry: _kTripEndPoints[i].target,
          iconSize: 10.0,
          iconImage: "assets/icon/$iconImage.png",
        ),
      );
      controller.addSymbol(SymbolOptions(
        iconSize: 0.22,
        geometry: LatLng(
            widget.orderDetails['supplier_plant']['plant_latitude'],
            widget.orderDetails['supplier_plant']['plant_longitude']),
        iconImage: "assets/proveedor.png",
      ));
      controller.addSymbol(SymbolOptions(
        iconSize: 0.22,
        geometry: LatLng(
            widget.orderDetails['order_details']['location']
                ['location_latitude'],
            widget.orderDetails['order_details']['location']
                ['location_longitude']),
        iconImage: "assets/building.png",
      ));
    }

    _addSourceAndLineLayer();
  }

  _addSourceAndLineLayer() async {
    // Create a polyLine between source and destination
    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: primaryClr.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: MapboxMap(
              styleString:
                  "mapbox://styles/heverrubio/cl3i00jas00br14quxej35p1a",
              compassEnabled: false,
              accessToken: "sk.eyJ1IjoiaGV2ZXJydWJpbyIsImEiOiJjbDNkYmx6b3UwNnF2M2ptd29naGNrYWwzIn0.97r4PzYMlW9KT5StDfh2SA",
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            ),
          ),
          reviewRideBottomSheet(
              widget.orderDetails,
              widget.agreeTrip,
              widget.hasAgreeTrip,
              context,
              distance,
              dropOffTime,
              duration,
              "${widget.orderDetails['order_details']['order']['order_material_name']}",
              "${widget.orderDetails['order_details']['order']['order_quantity']} Tons",
              widget.orderDetails['supplier_plant']['supplier_name'] +
                  ", " +
                  widget.orderDetails['supplier_plant']['plant_direction'] +
                  ", " +
                  widget.orderDetails['supplier_plant']['plant_exterior_num'] +
                  " " +
                  widget.orderDetails['supplier_plant']['plant_colony'] +
                  ", CP: " +
                  widget.orderDetails['supplier_plant']['plant_cp'] +
                  ", " +
                  widget.orderDetails['supplier_plant']['plant_city'] +
                  ", " +
                  widget.orderDetails['supplier_plant']['plant_state'] +
                  ", " +
                  widget.orderDetails['supplier_plant']['plant_country'],
              "${widget.orderDetails['order_details']['location']['location_name']}, ${widget.orderDetails['order_details']['location']['location_direction_line_1']} ${widget.orderDetails['order_details']['location']['location_city']}, ${widget.orderDetails['order_details']['location']['location_state']}",
              widget.time,
              "${widget.orderDetails['order_details']['order']['order_shipping']}"),
        ],
      ),
    );
  }
}
