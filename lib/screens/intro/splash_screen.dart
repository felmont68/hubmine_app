import 'dart:convert';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mining_solutions/demo/helpers/mapbox_handler.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/intro/intro_screen.dart';
import 'package:mining_solutions/screens/vAlpha/services/check_user_type_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? token;
  bool hasToken = false;
  Widget? page;

  loadTokenAndType() async {
    token = await ServiceStorage.getToken();
    var hasLoggedIn = await ServiceStorage.getHasLoggedIn();
    if (hasLoggedIn != null) {
    } else {
      ServiceStorage.saveHasLoggedIn(false);
    }
    var _page = await CheckUserTypeServices.loadHomePage();

    if (token != null) {
      setState(() {
        hasToken = true;
        page = _page;
      });
    } else {}
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // Get the current user location
    LocationData _locationData = await _location.getLocation();
    LatLng currentLocation =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    var data = await (getParsedReverseGeocoding(currentLocation));
    sharedPreferences.setString('source', json.encode(data));

    // Get the current user addres
    String currentAddress = "";

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
    sharedPreferences.setString('current-address', currentAddress);
  }

  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
    loadTokenAndType();
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/LogoSplash.png'),
      logoSize: 80,
      backgroundColor: primaryClr,
      showLoader: true,
      loaderColor: Colors.white,
      loadingText: Text("Versión 2.0.6", style: loadingStyle),
      navigator: hasToken ? page : const IntroScreen(),
      durationInSeconds: 1,
    );
  }
}
