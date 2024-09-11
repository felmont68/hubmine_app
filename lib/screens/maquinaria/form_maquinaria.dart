import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/location_data.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:mining_solutions/screens/buy/data/payments.dart';
import 'package:mining_solutions/screens/driver/register/widgets/custom_bottom_sheet.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/locations/current_location_page.dart';
import 'package:mining_solutions/screens/locations/edit_location_page.dart';
import 'package:mining_solutions/screens/maquinaria/data/timetobuy.dart';
import 'package:mining_solutions/screens/maquinaria/machinary_quotation_requested.dart';
import 'package:mining_solutions/services/directions_services.dart';
import 'package:mining_solutions/services/location_services.dart';
import 'package:mining_solutions/services/machinary_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/widgets/input_model.dart';

import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:mining_solutions/screens/locations/widgets/pin.dart';

class FormMachinaryPage extends StatefulWidget {
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String urlImage;
  final String productID;
  final String brand;
  final String titleProduct;
  const FormMachinaryPage(
      {Key? key,
      required this.name,
      required this.lastName,
      required this.phone,
      required this.urlImage,
      required this.productID,
      required this.brand,
      required this.email,
      required this.titleProduct})
      : super(key: key);

  @override
  State<FormMachinaryPage> createState() => _FormMachinaryPageState();
}

class _FormMachinaryPageState extends State<FormMachinaryPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _unityTimeController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _whenBuyController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  String _whenBuySelected = "";

  int _currentStep = 0;

  String _unityTimeSelected = "";
  String _unityTimeSelectedID = "";

  late List<bool> isSelected;

  List esquemasDeRenta = [];

  getEsquemasDeRenta() async {
    var _url =
        Uri.parse("http://23.100.25.47:8010/api/machinery/list-unity-time");
    var _res = await http.get(_url);
    if (_res.statusCode == 200) {
      var _jsonResponse = json.decode(_res.body);
      setState(() {
        esquemasDeRenta = _jsonResponse;
      });
    } else if (_res.statusCode == 401) {
    } else if (_res.statusCode == 500) {}
  }

  _insertData() async {
    _firstNameController = TextEditingController(text: widget.name);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    setState(() {});
  }

  List<LocationData> _dataLocations = [];

  _fetchDataDirections() async {
    _dataLocations = await ServiceDirections.fetchDirectionsAll();
    //setState(() {});
  }

  loadFuture() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    var future =
        fetchLocationDetails(locationProvider.iDLocationSelected.toString());
    setState(() {});
    return future;
  }

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

  _updateMap(double newlat, double newlong) async {
    List<Placemark> _placemark = await GeocodingPlatform.instance
        .placemarkFromCoordinates(newlat.toDouble(), newlong.toDouble());

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(newlat.toDouble(), newlong.toDouble()), zoom: 17),
      ),
    );
    setState(() {});
  }

  getSellQuotation(String productID, String locationSelectedID,
      String firstName, String lastName, String email, String phone) async {
    print(productID +
        " " +
        locationSelectedID +
        " " +
        firstName +
        " " +
        lastName +
        " " +
        email +
        " " +
        phone);
  }

  @override
  void initState() {
    // this is for 3 buttons, add "false" same as the number of buttons here
    isSelected = [true, false];
    _insertData();
    getEsquemasDeRenta();
    _fetchDataDirections();
    loadFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setIcon(int typeLocation, int iDLocationSelected) {
      switch (typeLocation) {
        case 1:
          return SvgPicture.asset("assets/house.svg",
              width: 25, height: 25, color: gray80);

        case 2:
          return SvgPicture.asset("assets/buliding.svg",
              width: 25, height: 25, color: gray80);
        case 3:
          return SvgPicture.asset("assets/plant.svg",
              width: 25, height: 25, color: gray80);
        case 4:
          return SvgPicture.asset("assets/corporate.svg",
              width: 25, height: 25, color: gray80);
      }
    }

    final locationProvider = Provider.of<LocationProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 100,
          // margin: const EdgeInsets.only(bottom: 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: _currentStep == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          // TODO: Lógica de pago
                          onPressed: () {
                            continued();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text("Continuar", style: subHeading2White),
                                  SizedBox(width: 12),
                                  Icon(Iconsax.arrow_right_14,
                                      size: 18, color: Colors.white),
                                ],
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryClr,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 16,
                                cornerSmoothing: 1,
                              ),
                            ),
                          )),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          // TODO: Lógica de pago
                          onPressed: () {
                            cancel();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.arrow_left,
                                      size: 18, color: Colors.black),
                                  SizedBox(width: 12),
                                  Text("Atrás", style: subHeading2),
                                ],
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            shape: SmoothRectangleBorder(
                              side: BorderSide(color: primaryClr),
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 16,
                                cornerSmoothing: 1,
                              ),
                            ),
                          )),
                      _currentStep == 2
                          ? ElevatedButton(
                              // TODO: Lógica de Solicitar Cotización
                              onPressed: () async {
                                print("Hola");

                                if (await createRentQuotation(
                                    isSelected[0],
                                    widget.productID,
                                    _unityTimeSelectedID.toString() != ""
                                        ? _unityTimeSelectedID.toString()
                                        : "1",
                                    _quantityController.text,
                                    locationProvider.iDLocationSelected
                                        .toString(),
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _emailController.text,
                                    _phoneController.text,
                                    context)) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const MachinaryQuotationRequested()),
                                      (Route<dynamic> route) => false);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text("Solicitar cotización",
                                          style: subHeading2White),
                                    ],
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primaryClr,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 18),
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 16,
                                    cornerSmoothing: 1,
                                  ),
                                ),
                              ))
                          : ElevatedButton(
                              // TODO: Lógica de pago
                              onPressed: () {
                                continued();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text("Continuar",
                                          style: subHeading2White),
                                      SizedBox(width: 12),
                                      Icon(Iconsax.arrow_right_14,
                                          size: 18, color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primaryClr,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 18),
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
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(Iconsax.arrow_left, color: Colors.black)),
            ),
            backgroundColor: Colors.white,
            title: Text("Solicita una cotización", style: subHeading1)),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(
                    canvasColor: Colors.grey[10],
                    colorScheme: Theme.of(context).colorScheme.copyWith(),
                  ),
                  child: Stepper(
                    controlsBuilder: (context, _) {
                      return SizedBox();
                    },
                    elevation: 0,
                    type: StepperType.horizontal,
                    physics: ScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (step) => tapped(step),
                    onStepContinue: continued,
                    onStepCancel: cancel,
                    steps: <Step>[
                      Step(
                        title: Text('Equipo', style: subHeading1),
                        content: GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Producto a cotizar", style: subtitle),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.all(16),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                              imageUrl: widget.urlImage),
                                        ),
                                      )),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.titleProduct,
                                            style: subHeading1),

                                        // Text("Entrega ${widget.fechaEntrega}",
                                        //     //  ${DateFormat.MMMMd("es").format(DateTime.parse(orders[index]["delivery_date"])
                                        //     style: body),
                                        Text("Proveedor: ${widget.brand}",
                                            style: bodyGray60),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text("¿Qué deseas? *", style: subtitle),
                              const SizedBox(height: 8),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    ToggleButtons(
                                  selectedBorderColor: primaryClr,
                                  borderRadius: BorderRadius.circular(12),
                                  borderColor: gray20,
                                  constraints: BoxConstraints.expand(
                                      width: constraints.maxWidth / 2.03),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text("Rentar",
                                          style: isSelected[0]
                                              ? subHeading2PrimaryClr
                                              : bodyBlack),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text("Comprar",
                                          style: isSelected[1]
                                              ? subHeading2PrimaryClr
                                              : bodyBlack),
                                    )
                                  ],
                                  isSelected: isSelected,
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int i = 0;
                                          i < isSelected.length;
                                          i++) {
                                        isSelected[i] = i == index;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              isSelected[0]
                                  ? InkWell(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                            isScrollControlled: true,
                                            context: context,
                                            shape: const SmoothRectangleBorder(
                                              borderRadius:
                                                  SmoothBorderRadius.vertical(
                                                top: SmoothRadius(
                                                    cornerRadius: 20,
                                                    cornerSmoothing: 1),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return BottomSheetEsquemasRenta(
                                                  title:
                                                      "Selecciona un esquema de renta",
                                                  options: esquemasDeRenta,
                                                  onTap: (value) {
                                                    _unityTimeController.text =
                                                        "Renta por ${value["unity"]}";
                                                    setState(() {
                                                      _unityTimeSelected =
                                                          value["unity"];
                                                      _unityTimeSelectedID =
                                                          value["id"]
                                                              .toString();
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                            });
                                      },
                                      child: InputDropdown(
                                          isRequired: true,
                                          controller: _unityTimeController,
                                          label:
                                              "¿Bajo que esquema quieres rentar?",
                                          hintText:
                                              "Selecciona un esquema de renta"),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                            isScrollControlled: true,
                                            context: context,
                                            shape: const SmoothRectangleBorder(
                                              borderRadius:
                                                  SmoothBorderRadius.vertical(
                                                top: SmoothRadius(
                                                    cornerRadius: 20,
                                                    cornerSmoothing: 1),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return CustomBottomSheet(
                                                  title:
                                                      "Selecciona una fecha aproximada",
                                                  options: timeToBuy,
                                                  onTap: (value) {
                                                    _whenBuyController.text =
                                                        value;
                                                    setState(() {
                                                      _whenBuySelected = value;
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                            });
                                      },
                                      child: InputDropdown(
                                          isRequired: true,
                                          controller: _whenBuyController,
                                          label:
                                              "¿Para cuándo planeas hacer la compra?",
                                          hintText:
                                              "Selecciona una fecha aproximada"),
                                    ),
                              const SizedBox(height: 20),
                              isSelected[0] && _unityTimeSelected != ""
                                  ? Input(
                                      isRequired: true,
                                      controller: _quantityController,
                                      keyboardType: TextInputType.number,
                                      label:
                                          "Cantidad de ${_unityTimeSelected} que lo necesitas",
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return "El nombre de quien recibe es requerido";
                                      //   }
                                      // }
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Text('Dirección', style: subHeading1),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Container(
                                    child: GoogleMap(
                                      myLocationButtonEnabled: false,
                                      mapToolbarEnabled: false,
                                      compassEnabled: false,
                                      initialCameraPosition: _kGooglePlex,
                                      zoomControlsEnabled: false,
                                      zoomGesturesEnabled: false,
                                      myLocationEnabled: false,
                                      mapType: MapType.normal,
                                      minMaxZoomPreference:
                                          const MinMaxZoomPreference(0, 16),
                                      markers: Set.from(_markers),
                                      onMapCreated: _onMapCreated,
                                      onCameraIdle: () async {
                                        if (mounted) {
                                          List<Placemark> _placemark =
                                              await GeocodingPlatform.instance
                                                  .placemarkFromCoordinates(
                                                      _currentPosition.latitude
                                                          .toDouble(),
                                                      _currentPosition.longitude
                                                          .toDouble());

                                          _streetName =
                                              _placemark[0].street.toString();
                                          _city =
                                              _placemark[0].locality.toString();
                                          _col = _placemark[0]
                                              .subLocality
                                              .toString();
                                          _cp = _placemark[0]
                                              .postalCode
                                              .toString();
                                          _state = _placemark[0]
                                              .administrativeArea
                                              .toString();
                                          _long = _currentPosition.longitude
                                              .toString();
                                          _lat = _currentPosition.latitude
                                              .toString();
                                          _controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: LatLng(
                                                      _currentPosition.latitude
                                                          .toDouble(),
                                                      _currentPosition.longitude
                                                          .toDouble()),
                                                  zoom: 17),
                                            ),
                                          );
                                          setState(() {
                                            //_textController.text =
                                            //    '$_streetName ';
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: Pin(
                                            color: primaryClr,
                                            size: 70,
                                            onPressed: () {},
                                            child: SvgPicture.asset(
                                                "assets/map_location.svg")),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('Confirma la ubicación de tu obra',
                                style: heading3),
                            Text('Compartiremos esta ubicación al proveedor',
                                style: subHeading2Gray),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius.vertical(
                                      top: SmoothRadius(
                                          cornerRadius: 20, cornerSmoothing: 1),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter myState) {
                                      return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                250,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 10.0, right: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Wrap(children: [
                                                  SizedBox(
                                                      width: 20,
                                                      height: 6,
                                                      child: Container(
                                                        // color: HMColor.primary,
                                                        decoration: const BoxDecoration(
                                                            color: primaryClr,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                      )),
                                                ]),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    top: 20,
                                                    bottom: 10,
                                                    right: 10),
                                                child: Text(
                                                  'Agrega o escoge una dirección de entrega',
                                                  style: heading,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 10),
                                                child: const SearchAddressInput(
                                                  hintText:
                                                      "Ingresa una dirección",
                                                  suffixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5.0,
                                                          right: 20),
                                                      child: Icon(
                                                          Iconsax.location5,
                                                          color: gray20)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0.0, right: 10.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                        return const CurrentLocationPage(
                                                          navigationOptions: {
                                                            "nextRoute":
                                                                "checkout",
                                                            "removeUntil": true
                                                          },
                                                        );
                                                      }),
                                                    );
                                                  },
                                                  child: ListTile(
                                                    leading: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Icon(Iconsax.gps5),
                                                    ),
                                                    title: Text(
                                                      'Ubicación Actual',
                                                      style: subHeading1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.separated(
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                              int index) =>
                                                          const Divider(),
                                                  itemCount:
                                                      _dataLocations.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        locationProvider
                                                            .setiDLocationSelected(
                                                                _dataLocations[
                                                                        index]
                                                                    .id);
                                                        // TODO: Hacer el cambio de ubicación seleccionada
                                                        _updateMap(
                                                            _dataLocations[
                                                                    index]
                                                                .lat,
                                                            _dataLocations[
                                                                    index]
                                                                .log);

                                                        setState(() {
                                                          _textController.text =
                                                              _dataLocations[
                                                                      index]
                                                                  .directionInOneLine;
                                                        });

                                                        loadFuture();

                                                        myState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: ListTile(
                                                        leading: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4),
                                                            child: _setIcon(
                                                                _dataLocations[
                                                                        index]
                                                                    .tagId,
                                                                locationProvider
                                                                    .iDLocationSelected)),
                                                        trailing: locationProvider
                                                                    .iDLocationSelected ==
                                                                _dataLocations[
                                                                        index]
                                                                    .id
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_rounded,
                                                                color:
                                                                    primaryClr)
                                                            : DropdownButton(
                                                                underline:
                                                                    Container(),
                                                                icon: const Icon(
                                                                    Iconsax
                                                                        .more),
                                                                elevation: 4,
                                                                style:
                                                                    subHeading1,
                                                                onChanged: (int?
                                                                    newValue) async {
                                                                  if (newValue ==
                                                                      0) {
                                                                    if (await ServiceDirections.deleteDirection(
                                                                        _dataLocations[index]
                                                                            .id)) {
                                                                      var userType =
                                                                          await ServiceStorage
                                                                              .getUserTypeId();
                                                                      if (userType ==
                                                                          1) {
                                                                        print(
                                                                            "Se disparó el primer if");
                                                                        Navigator.of(context).pushAndRemoveUntil(
                                                                            MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
                                                                            (Route<dynamic> route) => false);
                                                                      }
                                                                    }
                                                                  } else {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                          builder: (BuildContext context) =>
                                                                              EditLocationPage(
                                                                                data: LocationData(
                                                                                  id: _dataLocations[index].id,
                                                                                  city: _dataLocations[index].city,
                                                                                  details: _dataLocations[index].details,
                                                                                  directionInOneLine: _dataLocations[index].directionInOneLine,
                                                                                  name: _dataLocations[index].name,
                                                                                  state: _dataLocations[index].state,
                                                                                  tagId: _dataLocations[index].tagId,
                                                                                  lat: _dataLocations[index].lat,
                                                                                  log: _dataLocations[index].log,
                                                                                  haveDetails: _dataLocations[index].haveDetails,
                                                                                ),
                                                                              )),
                                                                    );
                                                                  }
                                                                },
                                                                items: [
                                                                  DropdownMenuItem<
                                                                      int>(
                                                                    value: 0,
                                                                    child: Text(
                                                                        'Eliminar',
                                                                        style:
                                                                            body),
                                                                  ),
                                                                  DropdownMenuItem<
                                                                      int>(
                                                                    value: 1,
                                                                    child: Text(
                                                                        'Editar',
                                                                        style:
                                                                            body),
                                                                  ),
                                                                ],
                                                              ),
                                                        title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _dataLocations[
                                                                      index]
                                                                  .name,
                                                              style:
                                                                  subHeading2,
                                                            ),
                                                            Text(
                                                              _dataLocations[
                                                                      index]
                                                                  .city,
                                                              style: body,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );
                                // Navigator.of(context).pushNamed('demo_maps');
                                // print("Obteniendo ubicación");
                              },
                              child: InputDropdown(
                                prefixIcon: const Icon(Iconsax.location5,
                                    color: primaryClr),
                                isRequired: true,
                                controller: _textController,
                                label: "Ubicación de obra",
                                hintText: "Selecciona una ubicación",
                              ),
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 1
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: new Text('Contacto', style: subHeading1),
                        content: Column(
                          children: <Widget>[
                            Input(
                                isRequired: true,
                                prefixIcon: const Icon(Iconsax.profile_circle5),
                                controller: _firstNameController,
                                keyboardType: TextInputType.text,
                                label: "Nombre(s)",
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "El nombre de quien recibe es requerido";
                                  }
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            Input(
                              isRequired: true,
                              prefixIcon: const Icon(Iconsax.profile_circle5),
                              controller: _lastNameController,
                              keyboardType: TextInputType.text,
                              label: "Apellido(s)",
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "El nombre de quien recibe es requerido";
                              //   }
                              // }
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Input(
                              isRequired: true,
                              prefixIcon: const Icon(Iconsax.sms5),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHint: const [AutofillHints.email],
                              label: "Correo electrónico",
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "El nombre de quien recibe es requerido";
                              //   }
                              // }
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Input(
                                isRequired: true,
                                prefixIcon: const Icon(Iconsax.call5),
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                autofillHint: const [
                                  AutofillHints.telephoneNumberNational
                                ],
                                label: "Número de teléfono",
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "El número de teléfono es requerido";
                                  }
                                }),
                            const SizedBox(height: 16),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 2
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
