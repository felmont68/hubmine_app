import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mining_solutions/demo/helpers/mapbox_handler.dart';
import 'package:mining_solutions/demo/helpers/shared_prefs.dart';
import 'package:mining_solutions/demo/screens/details_ride.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/driver/home/driver_home_page.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/widgets/animate_swipe_to_confirm.dart';
import 'package:mining_solutions/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeDriver extends StatefulWidget {
  const HomeDriver({Key? key}) : super(key: key);

  @override
  State<HomeDriver> createState() => _HomeState();
}

class _HomeState extends State<HomeDriver> {
  late LatLng currentLocation;
  late String currentAddress;
  late MapboxMapController controller;
  late CameraPosition _initialCameraPosition;
  Map? _theModifiedResponse;
  bool newTripAvalible = false;
  String text = "";
  bool isOnline = false;
  bool hasAgreeTrip = false;

  late Timer _timer;
  Timer? timer;
  int _countdownTime = 0;
  Map detailsTrip = {};

  loadTripAvalible() async {
    var _url = Uri.parse(
        "http://23.100.25.47:8010/api/hubbers/last-p-o-without-hubber/");
    final response = await http.get(_url);

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      var convertDataToJson = json.decode(source);
      setState(() {
        detailsTrip = convertDataToJson;
      });
      if (hasAgreeTrip) {
      } else {
        loadTrip();
      }

      return convertDataToJson;
    } else {
      Get.snackbar(
        "No hay viajes disponibles",
        "Seguiremos buscando un viaje para ti...",
        backgroundColor: primaryClr,
        colorText: Colors.white,
      );
      return [];
    }
  }

  void loadTrip() async {
    // TODO: Poner el origen
    LatLng sourceLatLng = LatLng(
        detailsTrip['supplier_plant']['plant_latitude'],
        detailsTrip['supplier_plant']['plant_longitude']);
    // TODO: Poner el destino
    LatLng destinationLatLng = LatLng(
        detailsTrip['order_details']['location']['location_latitude'],
        detailsTrip['order_details']['location']['location_longitude']);
    var data = await (getParsedReverseGeocoding(destinationLatLng));
    sharedPreferences.setString('destination', json.encode(data));
    Map modifiedResponse =
        await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
    setState(() {
      newTripAvalible = true;
      _theModifiedResponse = modifiedResponse;
    });
    if (_countdownTime == 0) {
      setState(() {
        _countdownTime = 20;
      });
      // Iniciar cuenta regresiva
      startCountdownTimer();
    }
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _findMe() {
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentLocation, zoom: 15),
    ));
  }

  // loadDetailsTrip() async {
  //   LatLng sourceLatLng = LatLng(25.6813023, -100.3928073);
  //   LatLng destinationLatLng = LatLng(25.6759823, -100.3741592);
  //   Map modifiedResponse =
  //       await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
  // }

  setStateAfterMount() {
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 600), () async {
        setState(() {
          // Your state change code goes here
        });
      });
    }
  }

  agreeTrip() async {
    int _id = await ServiceStorage.getIdUser();
    var _url = Uri.parse(
        "http://23.100.25.47:8010/api/hubbers/assign-po-to-hubber/15/");
    var _body = {"pur_or_id": detailsTrip['pk'].toString()};
    final response = await http.put(_url, body: _body);

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      var convertDataToJson = json.decode(source);
      print(convertDataToJson);
      setState(() {
        hasAgreeTrip = true;
        _timer.cancel();
        timer?.cancel();
      });
      return true;
    } else {
      print("Ocurrió un error");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadInfoUserProfile(context);
    timer = Timer.periodic(
        const Duration(seconds: 20), (Timer t) => loadTripAvalible());

    currentLocation = getCurrentLatLngFromSharedPrefs();
    _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 15);
    currentAddress = getCurrentAddressFromSharedPrefs();
    _theModifiedResponse = {};
    setStateAfterMount();
  }

  @override
  void dispose() {
    _timer.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    return Scaffold(
        appBar: newTripAvalible
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(0.92),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      backgroundImage: userInfo.profilePhotoPath == "" ||
                              userInfo.profilePhotoPath == null
                          ? const NetworkImage(
                              "https://syncronik.s3.us-east-2.amazonaws.com/Hubmine/user-by-default.png")
                          : NetworkImage(
                              'http://23.100.25.47:8010/media/' +
                                  userInfo.profilePhotoPath,
                            ),
                    ),
                    SizedBox(
                      width: 176,
                      child: AnimatedSwipeToConfirm(
                        onConfirm: () {
                          setState(() {
                            text = "Estás en linea";
                            isOnline = true;
                            loadTrip();
                          });
                        },
                        onCancel: () {
                          setState(() {
                            text = "Estás offline";
                            isOnline = false;
                            newTripAvalible = false;
                          });
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Saldo", style: subtitleLoginTextStyle),
                        Text(r"$0.00", style: subtitleProducts),
                      ],
                    )
                  ],
                ),
              ),
        extendBody: true,
        body: Stack(
          children: [
            Visibility(
              visible: !newTripAvalible,
              child: MapboxMap(
                styleString:
                    "mapbox://styles/heverrubio/cl3i00jas00br14quxej35p1a",
                onMapCreated: _onMapCreated,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                accessToken: "sk.eyJ1IjoiaGV2ZXJydWJpbyIsImEiOiJjbDNkYmx6b3UwNnF2M2ptd29naGNrYWwzIn0.97r4PzYMlW9KT5StDfh2SA",
                initialCameraPosition: _initialCameraPosition,
                myLocationEnabled: true,
              ),
            ),
            Visibility(
              visible: newTripAvalible & !hasAgreeTrip,
              child: DetailsRide(
                  agreeTrip: agreeTrip,
                  hasAgreeTrip: hasAgreeTrip,
                  orderDetails: detailsTrip,
                  modifiedResponse: _theModifiedResponse!,
                  time: _countdownTime.toString()),
            ),
            Visibility(
              visible: !newTripAvalible,
              child: Positioned(
                  bottom: 140,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      _findMe();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.location_searching_rounded,
                            size: 24, color: gray80),
                      ),
                    ),
                  )),
            ),
            Visibility(
              visible: !newTripAvalible,
              child: DraggableScrollableSheet(
                maxChildSize: 0.22,
                initialChildSize: 0.16,
                minChildSize: 0.16,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: const CustomScrollViewContent(),
                  );
                },
              ),
            ),
          ],
        ));
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_countdownTime < 1) {
                  _timer.cancel();
                  newTripAvalible = false;
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            });
  }
}
