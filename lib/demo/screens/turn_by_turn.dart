import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mining_solutions/demo/helpers/shared_prefs.dart';
import 'package:mining_solutions/demo/screens/home.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';

class TurnByTurn extends StatefulWidget {
  final Map orderDetails;
  const TurnByTurn({Key? key, required this.orderDetails}) : super(key: key);

  @override
  State<TurnByTurn> createState() => _TurnByTurnState();
}

class _TurnByTurnState extends State<TurnByTurn> {
  // Waypoints to mark trip start and end
  LatLng source = getTripLatLngFromSharedPrefs('source');
  LatLng destination = getTripLatLngFromSharedPrefs('destination');
  late WayPoint sourceWaypoint, plantWaypoint, destinationWaypoint;
  var wayPoints = <WayPoint>[];

  late MapBoxNavigation directionsToPlant;
  bool routeBuiltToPlant = false;
  bool isNavigatingToPlant = false;
  var wayPointsToPlant = <WayPoint>[];
  bool hasArrivedToPlant = false;

  late MapBoxNavigation directionsToWork;
  bool routeBuiltToWork = false;
  bool isNavigatingToWork = false;
  var wayPointsToWork = <WayPoint>[];
  bool hasArrivedToWork = false;

  // Config variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = false;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> goToPlant() async {
    if (!mounted) return;

    directionsToPlant = MapBoxNavigation(onRouteEvent: _onRouteEventToPlant);
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: true,
        units: VoiceUnits.imperial,
        alternatives: true,
        language: "es");

    // Configure waypoints
    var sourceWaypoint = WayPoint(
        name: "Origen", latitude: source.latitude, longitude: source.longitude);

    var plantWaypoint = WayPoint(
        name: "Planta de recolección",
        latitude: 25.8718121,
        longitude: -100.4297917);

    wayPointsToPlant.add(sourceWaypoint);
    wayPointsToPlant.add(plantWaypoint);

    // Start the trip
    await directionsToPlant.startNavigation(
        wayPoints: wayPointsToPlant, options: _options);
  }

  Future<void> _onRouteEventToPlant(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        print(progressEvent);
        hasArrivedToPlant = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuiltToPlant = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuiltToPlant = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigatingToPlant = true;
        break;
      case MapBoxEvent.on_arrival:
        print("Llegó a la planta alv");
        hasArrivedToPlant = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuiltToPlant = false;
        isNavigatingToPlant = false;
        wayPointsToPlant.clear();
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }

  Future<void> goToWork() async {
    if (!mounted) return;

    directionsToWork = MapBoxNavigation(onRouteEvent: _onRouteEventToWork);
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: true,
        units: VoiceUnits.imperial,
        alternatives: true,
        language: "es");

    destinationWaypoint = WayPoint(
        name: "Lugar de entrega",
        latitude: destination.latitude,
        longitude: destination.longitude);

    var plantWaypoint = WayPoint(
        name: "Planta de recolección",
        latitude: 25.8718121,
        longitude: -100.4297917);

    wayPointsToWork.add(plantWaypoint);
    wayPointsToWork.add(destinationWaypoint);

    // Start the trip
    await directionsToWork.startNavigation(
        wayPoints: wayPointsToWork, options: _options);
  }

  Future<void> _onRouteEventToWork(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        hasArrivedToWork = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuiltToWork = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuiltToWork = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigatingToWork = true;
        break;
      case MapBoxEvent.on_arrival:
        print("Llegó a la obra alv");
        arrived = true;
        hasArrivedToWork = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuiltToWork = false;
        isNavigatingToWork = false;
        wayPointsToPlant.clear();
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }

  Future<void> initialize() async {
    if (!mounted) return;

    // Setup directions and options
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: true,
        units: VoiceUnits.imperial,
        alternatives: true,
        language: "es");

    // Configure waypoints
    sourceWaypoint = WayPoint(
        name: "Origen", latitude: source.latitude, longitude: source.longitude);
    destinationWaypoint = WayPoint(
        name: "Lugar de entrega",
        latitude: destination.latitude,
        longitude: destination.longitude);

    plantWaypoint = WayPoint(
        name: "Planta de recolección",
        latitude: 25.8718121,
        longitude: -100.4297917);
    wayPoints.add(sourceWaypoint);
    wayPoints.add(plantWaypoint);
    wayPoints.add(destinationWaypoint);

    // Start the trip
    await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        // margin: const EdgeInsets.only(bottom: 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  // TODO: Lógica de pago
                  onPressed: () {
                    if (arrived) {
                      print("Marcando pedido como entregado");
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Text('Marcar pedido como entregado',
                            style: btnLight),
                      ),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: arrived ? primaryClr : gray60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 16,
                        cornerSmoothing: 1,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Entrega del pedido #${widget.orderDetails['pk']}",
            style: subHeading1),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomeDriver())),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Resumen del pedido',
                                    style: subHeading2Gray),
                              ],
                            ),
                            Text(
                                '${widget.orderDetails["order_details"]['order']['order_material_name']}',
                                style: heading2Black),
                            Text(
                                '${widget.orderDetails["order_details"]['order']['order_quantity']} toneladas',
                                style: subHeading1),
                            const SizedBox(height: 20),
                            Text(
                                // dateFormatterHelper(
                                //     widget.order["delivery_date"]),
                                "Fecha y hora de entrega por confirmar",
                                style: subHeading1),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/plant.svg",
                            width: 25, height: 25, color: primaryClr),
                        const SizedBox(
                          width: 4,
                        ),
                        Text('Dirección de recolección', style: subHeading1),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                        '${widget.orderDetails["supplier_plant"]['supplier_name']}, ${widget.orderDetails["supplier_plant"]['plant_direction']}, ${widget.orderDetails["supplier_plant"]['plant_exterior_num']}, ${widget.orderDetails["supplier_plant"]['plant_city']}, MX',
                        style: body),
                    TextButton(
                        onPressed: () {
                          goToPlant();
                          // TODO: Lógica a rastreo
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         DetailsOrder(widget.order, purchaseOrder),
                          //   ),
                          // );
                        },
                        child: Text('Iniciar viaje a planta', style: bodyLink))
                  ],
                )),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/buliding.svg",
                            width: 25, height: 25, color: primaryClr),
                        const SizedBox(
                          width: 4,
                        ),
                        Text('Dirección de entrega', style: subHeading1),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                        '${widget.orderDetails['order_details']["location"]['location_name']}, ${widget.orderDetails['order_details']["location"]['location_direction_line_1']}, ${widget.orderDetails['order_details']["location"]['location_city']}, ${widget.orderDetails['order_details']["location"]['location_state']}, MX',
                        style: body),
                    TextButton(
                        onPressed: () {
                          goToWork();
                          // TODO: Lógica a rastreo
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         DetailsOrder(widget.order, purchaseOrder),
                          //   ),
                          // );
                        },
                        child: Text('Iniciar viaje a obra', style: bodyLink))
                  ],
                )),
            const SizedBox(height: 10),
            Text('Pedido número ${widget.orderDetails["pk"]}',
                style: subHeading2Gray),
          ],
        ),
      ),
    );
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }
}
