import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/driver/services/driver_online_services.dart';
import 'package:mining_solutions/screens/driver/services/driver_storage_services.dart';
import 'package:mining_solutions/widgets/animate_swipe_to_confirm.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeContent extends StatefulWidget {
  const DriverHomeContent({Key? key}) : super(key: key);

  @override
  State<DriverHomeContent> createState() => _DriverHomeContentState();
}

class _DriverHomeContentState extends State<DriverHomeContent> {
  late Location location;
  String text = "";
  bool isOnline = false;
  int idDriver = 0;
  var lt, lg;
  late GoogleMapController _controller;

  enableWebSocket(int idDriver, var lt, var lg) async {
    try {
      WebSocketChannel webSocketLocation = WebSocketChannel.connect(Uri.parse(
          'ws://awsms.syncronik.com/ws/location/' + idDriver.toString() + '/'));
      webSocketLocation.sink.add(jsonEncode(
        {"latitude": lt, "longitude": lg},
      ));
      webSocketLocation.stream.listen(
        (data) {
          print('====== Data for ws ======>' + data);
        },
        onError: (error) => print(error),
      );
    } catch (e) {
      print(e);
    }
  }

  disabledWebSocket() async {}

  loadOnlineStatus() async {
    var isOnlineStatus = await DriverServiceStorage.getOnlineStatus();
    int idDriverStorage = await DriverServiceStorage.getIdUser();
    double lat = Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLatituded;
    double long = Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLongitude;
    setState(() {
      lt = lat;
      lg = long;
      isOnline = isOnlineStatus;
      idDriver = idDriverStorage;
    });
    if (isOnlineStatus) {
      enableWebSocket(idDriver, lt, lg);
    }
  }

  @override
  void initState() {
    super.initState();
    //loadOnlineStatus();
    setState(() {
      text = "Estás offline";
    });
    loadOnlineStatus();
    location = Location();
    location.isBackgroundModeEnabled();
    location.changeSettings(interval: 3000);
    location.onLocationChanged.listen((LocationData cLoc) async {
      enableWebSocket(idDriver, cLoc.latitude, cLoc.longitude);
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.7162707, -100.3240342),
    zoom: 13.0,
  );

  void _onMapCreated(GoogleMapController _cntlr) async {
    double lat = Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLatituded;
    double long = Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLongitude;
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                  enableWebSocket(idDriver, lt, lg);
                  updateOnlineStatus(context, true);
                  setState(() {
                    text = "Estás en linea";
                    isOnline = true;
                  });
                },
                onCancel: () {
                  disabledWebSocket();
                  updateOnlineStatus(context, false);
                  setState(() {
                    text = "Estás offline";
                    isOnline = false;
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
      body: isOnline
          ? Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                  ),
                ),
              ],
            )
          : Center(child: Text(isOnline.toString())),
    );
  }
}
