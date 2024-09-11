import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:mining_solutions/screens/locations/confirm_location_page.dart';
import 'package:mining_solutions/screens/locations/widgets/pin.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io' show Platform;

class CurrentLocationPage extends StatefulWidget {
  final Map navigationOptions;

  const CurrentLocationPage({required this.navigationOptions, Key? key})
      : super(key: key);

  @override
  State<CurrentLocationPage> createState() => _CurrentLocationPageState();
}

class _CurrentLocationPageState extends State<CurrentLocationPage> {
  late String _streetName, _city, _edo, _col, _cp, _state, _long, _lat;
  List<Marker> _markers = [];
  late BitmapDescriptor icon;
  late GoogleMapController _controller;
  late LatLng _currentPosition;
  final TextEditingController _textController = TextEditingController();

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
    _markers = [];

    List<Placemark> _placemark =
        await GeocodingPlatform.instance.placemarkFromCoordinates(
      lat.toDouble(),
      long.toDouble(),
    );
    _streetName = _placemark[0].street.toString();
    _city = _placemark[0].locality.toString();
    _col = _placemark[0].subLocality.toString();
    _cp = _placemark[0].postalCode.toString();
    _state = _placemark[0].administrativeArea.toString();
    _long = long.toString();
    _lat = lat.toString();

    // developer.log(' ---- > CALLE: ' + _placemark[0].street.toString());
    // developer.log(' ---- > COLONIA: ' + _placemark[0].subLocality.toString());
    // developer.log(' ---- > CP: ' + _placemark[0].postalCode.toString());
    // developer.log(' ---- > CIUDAD: ' + _placemark[0].locality.toString());
    // developer
    //     .log(' ---- > ESTADO: ' + _placemark[0].administrativeArea.toString());
    // developer.log(' ---- > PAIS: ' + _placemark[0].isoCountryCode.toString());

    setState(() {});
  }

  _handleTap(LatLng tappedPoint) async {
    List<Placemark> _placemark = await GeocodingPlatform.instance
        .placemarkFromCoordinates(
            tappedPoint.latitude.toDouble(), tappedPoint.longitude.toDouble());

    _streetName = _placemark[0].street.toString();
    _city = _placemark[0].locality.toString();
    _col = _placemark[0].subLocality.toString();
    _cp = _placemark[0].postalCode.toString();
    _state = _placemark[0].administrativeArea.toString();
    _long = tappedPoint.longitude.toString();
    _lat = tappedPoint.latitude.toString();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(tappedPoint.latitude.toDouble(),
                tappedPoint.longitude.toDouble()),
            zoom: 17),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _streetName =
        Provider.of<LocationProvider>(context, listen: false).nameStreet;
    _city = Provider.of<LocationProvider>(context, listen: false).city;
    _edo = Provider.of<LocationProvider>(context, listen: false).edo;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _checkProviders(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 18.0),
              child: Container(
                color: Colors.white.withOpacity(0.49),
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Iconsax.close_circle5,
              color: textBlack,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Verifica la ubicación',
            style: subHeading1,
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  onTap: _handleTap,
                  markers: Set.from(_markers),
                  onMapCreated: _onMapCreated,
                  onCameraMove: (position) {
                    if (mounted) {
                      setState(() {
                        _currentPosition = position.target;
                      });
                    }
                  },
                  onCameraIdle: () async {
                    if (mounted) {
                      List<Placemark> _placemark = await GeocodingPlatform
                          .instance
                          .placemarkFromCoordinates(
                              _currentPosition.latitude.toDouble(),
                              _currentPosition.longitude.toDouble());

                      _streetName = _placemark[0].street.toString();
                      _city = _placemark[0].locality.toString();
                      _col = _placemark[0].subLocality.toString();
                      _cp = _placemark[0].postalCode.toString();
                      _state = _placemark[0].administrativeArea.toString();
                      _long = _currentPosition.longitude.toString();
                      _lat = _currentPosition.latitude.toString();
                      _controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(
                                  _currentPosition.latitude.toDouble(),
                                  _currentPosition.longitude.toDouble()),
                              zoom: 17),
                        ),
                      );
                      setState(() {
                        _textController.text = '$_streetName ';
                      });
                    }
                  },
                ),
                Align(
                    alignment: Alignment.center,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Pin(
                          color: primaryClr,
                          size: 70,
                          onPressed: () {},
                          child: SvgPicture.asset("assets/map_location.svg")),
                    ))
              ],
            )),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.white],
                      stops: [0.5, 0.8],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Confirma tu ubicación de entrega', style: heading3),
                      Text('Ajusta el marcador en la dirección correcta.',
                          style: subHeading2Gray),
                      const SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                const BorderSide(color: gray20, width: 1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          prefixIcon:
                              const Icon(Iconsax.location5, color: primaryClr),
                        ),
                        controller: _textController,
                        readOnly: true,
                        enabled: false,
                      ),
                      const SizedBox(height: 15),
                      Button(
                        color: primaryClr,
                        text: Text(
                          "Confirmar dirección",
                          style: subHeading2White,
                        ),
                        width: double.infinity,
                        height: size.height * 0.06,
                        action: () {
                          debugPrint("CURRENT LOCATION PAGE");
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ConfirmLocationPage(
                                          city: _city,
                                          colName: _col,
                                          edo: _edo,
                                          latitud: _lat,
                                          longitud: _long,
                                          postalCode: _cp,
                                          streetName: _streetName,
                                          navigationOptions: {
                                    ...widget.navigationOptions,
                                    "previousContext": context
                                  }),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(2.5, 2.0);
                                var end = Offset.zero;
                                var curve = Curves.bounceIn;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
