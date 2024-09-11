import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';

import 'package:mining_solutions/services/orders_services.dart';

import 'package:timelines/timelines.dart';

import 'package:intl/date_symbol_data_local.dart';

class DetailsOrder extends StatefulWidget {
  Map order;
  final Map purchaseOrder;
  DetailsOrder(this.order, this.purchaseOrder, {Key? key}) : super(key: key);
  @override
  State<DetailsOrder> createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder> {
  Map order = {};

  List steps = [
    "Tu pedido se está procesando",
    "El conductor va rumbo a la planta",
    "El pedido está siendo cargado",
    "El conductor va en camino",
    "Tu pedido está llegando",
    "Pedido entregado"
  ];

  bool _isCollapsed = false;
  // Mapbox Maps SDK related
  final List<CameraPosition> _kTripEndPoints = [];
  late MapboxMapController controller;
  late CameraPosition _initialCameraPosition;

  // Directions API response related
  late String distance;
  late String dropOffTime;
  late String duration;
  late Map geometry;

  bool hasDriver = false;

  int currentSteep = 1;

  Timer? timer;

  loadOrderDetails() async {
    var data = await fetchDetailOrder(widget.order['pk'].toString());
    if (data.length > 0) {
      setState(() {
        order = data;
        widget.order = data;
        currentSteep = widget.order['status']['order_status_id'];
      });
    } else {}
  }

  loadData() {
    loadOrderDetails();
  }

  disable() {
    print("Desabilitar");
    timer?.cancel();
  }

  loadFuture() async {
    var future = fetchPO(widget.order['pk'].toString());
    setState(() {});
    return future;
  }

  onCollapseToggle() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  void initState() {
    initializeDateFormatting('es_MX', null);
    loadData();
    timer =
        Timer.periodic(const Duration(seconds: 4), (Timer t) => loadFuture());
    // initialise distance, dropOffTime, geometry

    _initialCameraPosition = CameraPosition(
        target: LatLng(
            widget.purchaseOrder['order_details']['location']
                ['location_latitude'],
            widget.purchaseOrder['order_details']['location']
                ['location_longitude']),
        zoom: 13);

    // initialise initialCameraPosition, address and trip end points
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    controller.addSymbol(SymbolOptions(
      iconSize: 0.22,
      geometry: LatLng(
          widget.purchaseOrder['order_details']['location']
              ['location_latitude'],
          widget.purchaseOrder['order_details']['location']
              ['location_longitude']),
      iconImage: "assets/building.png",
    ));
    controller.addSymbol(SymbolOptions(
      iconSize: 0.22,
      geometry: LatLng(widget.purchaseOrder['supplier_plant']['plant_latitude'],
          widget.purchaseOrder['supplier_plant']['plant_longitude']),
      iconImage: "assets/proveedor.png",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Detalles del pedido #${widget.order['pk']}",
              style: subHeading1),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed("home"),
            icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: MapboxMap(
                styleString:
                    "mapbox://styles/heverrubio/cl3i00jas00br14quxej35p1a",
                compassEnabled: false,
                accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN']!,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height /
                        (_isCollapsed ? 2 : 4)),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tu pedido será entregado el',
                                  style: subHeading2Gray),
                              Text(
                                  dateFormatterHelper(
                                      widget.purchaseOrder['date_delivery'],
                                      widget.purchaseOrder['order_details']
                                          ['order']['hour_delivery']),
                                  style: subHeading1),
                            ],
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                )),
                                onPressed: () {},
                                child: const Icon(Icons.phone,
                                    color: Colors.black, size: 24)),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Timeline.tileBuilder(
                            builder: TimelineTileBuilder(
                                itemCount: 1,
                                indicatorBuilder: (_, index) => Indicator.dot(
                                      color: primaryClr,
                                    ),
                                contentsBuilder: (context, index) {
                                  return TimelineTile(
                                    node: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(steps[currentSteep - 1] ?? 0,
                                          style: subHeading1),
                                    ),
                                  );
                                }),
                            theme: TimelineTheme.of(context).copyWith(
                              nodePosition: 0,
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: loadFuture(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Row(children: [
                                  const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://hubmine.s3.amazonaws.com/default-profile.png"),
                                    child: CircularProgressIndicator(),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Buscando un socio conductor para tu pedido",
                                                  style: bodyLink),
                                              Text(
                                                  "Esto tomará solo un momento...",
                                                  style: bodyLight),
                                            ],
                                          ),
                                        ],
                                      )),
                                ]),
                              );
                            } else if (snapshot.data!.isNotEmpty &&
                                snapshot.data!['hubber_asigned'] != null) {
                              var data = snapshot.data;
                              disable();

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          "https://hubmine.s3.amazonaws.com/default-profile.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        flex: 6,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${data['hubber_asigned']["hubber_name"]} ${data['hubber_asigned']["hubber_last_name"]}",
                                                    style: bodyLink),
                                                Text(
                                                    "${data['hubber_asigned']["truck_name"]}",
                                                    style: bodyLight),
                                                Text(
                                                  "${data['hubber_asigned']["truck_plate"]}",
                                                  style: bodyTextBoldStyle,
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("5.0",
                                                    style: bodyTextBoldStyle),
                                                // Text(
                                                //     (order["driver_rating"]
                                                //             as double)
                                                //         .toStringAsFixed(1),
                                                //     style: bodyTextBoldStyle),
                                                const Icon(Iconsax.star1,
                                                    color: Colors.yellow,
                                                    size: 24)
                                              ],
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Row(children: [
                                  const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://hubmine.s3.amazonaws.com/default-profile.png"),
                                    child: CircularProgressIndicator(),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Buscando un socio conductor para tu pedido",
                                                  style: bodyLink),
                                              Text(
                                                  "Esto tomará solo un momento...",
                                                  style: bodyLight),
                                            ],
                                          ),
                                        ],
                                      )),
                                ]),
                              );
                            }
                          })
                    ]),
              ),
            ),
          ],
        ));
  }
}

String dateFormatterHelper(dateTime, time) {
  // return "${date.day}/${date.month}/${date.year}";
  DateTime date = DateFormat("yyyy-MM-dd").parse(dateTime);
  DateTime timeFormat = DateFormat('HH:mm').parse(time);
  String formatTime = DateFormat('HH:mm').format(timeFormat);

  int comparison = date.compareTo(DateTime.now());
  int dia = date.day;
  String mes = DateFormat("MMMM", 'es_MX').format(date).toString();

  if (comparison == 0) {
    return "$dia de $mes a las $formatTime hrs";
  } else {
    return "$dia de $mes a las $formatTime hrs";
  }
}

// class CustomStepper extends StatelessWidget {
//   const CustomStepper({
//     Key? key,
//     required this.steps,
//     required this.currentSteep,
//     required this.order,
//     required this.isCollapsed,
//     required this.onCollapseToggle,
//   }) : super(key: key);

//   final List steps;
//   final Map order;
//   final int currentSteep;
//   final bool isCollapsed;
//   final VoidCallback onCollapseToggle;

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }