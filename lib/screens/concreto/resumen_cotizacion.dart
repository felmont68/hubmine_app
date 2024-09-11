import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/location_data.dart';
import 'package:mining_solutions/providers/concreto_provider.dart';
import 'package:mining_solutions/providers/location_provider.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/concreto/concreto_order_ready.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/locations/current_location_page.dart';
import 'package:mining_solutions/screens/locations/edit_location_page.dart';
import 'package:mining_solutions/services/concrete_services.dart';
import 'package:mining_solutions/services/directions_services.dart';
import 'package:mining_solutions/services/location_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/widgets/input_model.dart';
import 'package:skeletons/skeletons.dart';
import '../../hubkens/colors.dart';
import 'package:intl/intl.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

class ResumenCotizacionPage extends StatefulWidget {
  const ResumenCotizacionPage({Key? key}) : super(key: key);

  @override
  State<ResumenCotizacionPage> createState() => _ResumenCotizacionPageState();
}

class _ResumenCotizacionPageState extends State<ResumenCotizacionPage> {
  final TextEditingController _addressController = TextEditingController();
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

  loadFuture() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    var future =
        fetchLocationDetails(locationProvider.iDLocationSelected.toString());
    setState(() {});
    return future;
  }

  TextEditingController _dateController = TextEditingController();
  List<LocationData> _dataLocations = [];
  formatDateTime(dateTime, time) {
    // DateTime dateFormat = DateFormat("dd-MM-yyyy").parse(dateTime);
    String dateTimeFormat = DateFormat("dd/MM/yyyy").format(dateTime);
    print(dateTimeFormat);
    DateTime timeFormat = DateFormat('HH:mm').parse(time);
    String formatTime = DateFormat('HH:mm').format(timeFormat);
    return "$dateTimeFormat a las $formatTime hrs";
  }

  loadDate() {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    _dateController = TextEditingController(text: "Hola");
    var stringTime =
        formatDateTime(userInfo.dateShipping, userInfo.timeShipping);
    _dateController.text = "$stringTime";
  }

  _fetchDataDirections() async {
    _dataLocations = await ServiceDirections.fetchDirectionsAll();
    //setState(() {});
  }

  final TextEditingController _whoReceivesController = TextEditingController();
  final TextEditingController _whoReceivesPhoneController =
      TextEditingController();
  final TextEditingController _whoReceivesEmailController =
      TextEditingController();

  @override
  void initState() {
    initializeDateFormatting('es_MX', null);
    loadDate();
    _fetchDataDirections();
    super.initState();
  }

  bool dateSelected = false;

  loadState() {
    setState(() {
      dateSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final concretoProvider = Provider.of<ConcretoInfo>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Detalles para la entrega", style: subHeading1),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 100,
        // margin: const EdgeInsets.only(bottom: 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  // TODO: Lógica de pago
                  onPressed: () async {
                    concretoProvider.contactName = _whoReceivesController.text;
                    concretoProvider.contactPhone =
                        _whoReceivesPhoneController.text;
                    concretoProvider.contactEmail =
                        _whoReceivesEmailController.text;
                    if (await createConcreteOrder(context)) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const ConcretoOrderReady()),
                          (Route<dynamic> route) => false);
                    }
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //       builder: (BuildContext context) =>
                    //           const ConcretoOrderReady()),
                    // );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("Comprar ahora", style: subHeading2White),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 2,
            //         child: ClipRRect(
            //             borderRadius: BorderRadius.circular(20),
            //             child: Image.network(
            //                 "${widget.order['product']['product_url_image']}"))),
            //     Expanded(
            //         flex: 6,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text('${widget.order["product"]['product_name']}',
            //                   style: heading2Black),
            //               Text('${widget.order["quantity"]} toneladas',
            //                   style: subHeading2),
            //               Text(
            //                   '\$${(widget.order["total"] as double).toStringAsFixed(2)} MXN',
            //                   style: subHeading2),
            //             ],
            //           ),
            //         )),
            //   ],
            // ),

            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //       color: white, borderRadius: BorderRadius.circular(20)),
            //   child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(Iconsax.document5, color: primaryClr),
            //             SizedBox(width: 4),
            //             Text("Ficha técnica", style: subHeading1),
            //           ],
            //         ),
            //         Divider(),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 SizedBox(height: 12),
            //                 Text('Tipo de concreto', style: subHeading2Gray),
            //                 Text("${concretoProvider.tipoConcreto}",
            //                     style: subHeading1),
            //                 Text("${concretoProvider.tipoColado}", style: body),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ]),
            // ),

            Card(
                elevation: 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset("assets/truck.svg",
                                  color: primaryClr),
                              const SizedBox(width: 4),
                              Text("Recepción del pedido", style: subHeading1),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 16,
                      ),
                      Input(
                        prefixIcon: const Icon(Iconsax.profile_circle5),
                        controller: _whoReceivesController,
                        keyboardType: TextInputType.text,
                        autofillHint: const [AutofillHints.name],
                        label: "Nombre de quien recibe en obra",
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "El nombre de quien recibe es requerido";
                        //   }
                        // }
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Input(
                        prefixIcon: const Icon(Iconsax.call5),
                        controller: _whoReceivesPhoneController,
                        keyboardType: TextInputType.phone,
                        autofillHint: const [AutofillHints.telephoneNumber],
                        label: "Número de teléfono de receptor",
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "El nombre de quien recibe es requerido";
                        //   }
                        // }
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(
                        height: 16,
                      ),
                      Input(
                        prefixIcon: const Icon(Iconsax.sms5),
                        controller: _whoReceivesEmailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHint: const [AutofillHints.email],
                        label: "Correo electrónico de contacto",
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "El nombre de quien recibe es requerido";
                        //   }
                        // }
                      ),
                    ],
                  ),
                )),
            FutureBuilder(
                future: loadFuture(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SkeletonItem(
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else if (snapshot.data!.isNotEmpty) {
                    Map location = snapshot.data;

                    return Card(
                        elevation: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Iconsax.location5,
                                          color: primaryClr),
                                      const SizedBox(width: 4),
                                      Text("Dirección de entrega",
                                          style: subHeading1),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 30,
                                        cornerSmoothing: 1,
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter myState) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              250,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20,
                                                left: 10.0,
                                                right: 10.0),
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
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4))),
                                                        )),
                                                  ]),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 10),
                                                  child:
                                                      const SearchAddressInput(
                                                    hintText:
                                                        "Ingresa una dirección",
                                                    suffixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5.0,
                                                                right: 20),
                                                        child: Icon(
                                                            Iconsax.location5,
                                                            color: gray20)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0,
                                                          right: 10.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                          // TODO: Establecer rutas
                                                          return const CurrentLocationPage(
                                                            navigationOptions: {
                                                              "nextRoute":
                                                                  "home",
                                                              "removeUntil":
                                                                  true
                                                            },
                                                          );
                                                        }),
                                                      );
                                                    },
                                                    child: ListTile(
                                                      leading: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0),
                                                        child:
                                                            Icon(Iconsax.gps5),
                                                      ),
                                                      title: Text(
                                                        'Ubicación Actual',
                                                        style: subHeading1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
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
                                                          print(locationProvider
                                                              .iDLocationSelected);

                                                          loadFuture();

                                                          myState(() {});
                                                        },
                                                        child: ListTile(
                                                          leading: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4),
                                                              child: locationProvider.iDLocationSelected ==
                                                                      _dataLocations[
                                                                              index]
                                                                          .id
                                                                  ? const Icon(
                                                                      Icons
                                                                          .check,
                                                                      color:
                                                                          primaryClr)
                                                                  : _setIcon(
                                                                      _dataLocations[
                                                                              index]
                                                                          .tagId,
                                                                      locationProvider
                                                                          .iDLocationSelected)),
                                                          trailing:
                                                              DropdownButton(
                                                            icon: const Icon(
                                                                Iconsax.more),
                                                            elevation: 16,
                                                            style: subHeading1,
                                                            onChanged: (int?
                                                                newValue) async {
                                                              if (newValue ==
                                                                  0) {
                                                                if (await ServiceDirections
                                                                    .deleteDirection(
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
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) =>
                                                                                const HomePage()),
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false);
                                                                  }
                                                                }
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          EditLocationPage(
                                                                            data:
                                                                                LocationData(
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
                                                          title: Text(
                                                            _dataLocations[
                                                                    index]
                                                                .directionInOneLine,
                                                            style: subHeading1,
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
                                    isRequired: true,
                                    controller: _addressController,
                                    label: "Ubicación de entrega",
                                    hintText:
                                        "${location['location_name']}, ${location['direction_line_1']}, ${location['city']} ${location['state']}, MX"),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ));
                    //  AddressShipingWidget(
                    //     name: location['location_name'],
                    //     direction: location['direction_line_1'],
                    //     city: location['city'],
                    //     state: location['state']);
                  } else {
                    return Card(
                        elevation: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Iconsax.location5,
                                          color: primaryClr),
                                      const SizedBox(width: 4),
                                      Text("Dirección de entrega",
                                          style: subHeading1),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 30,
                                        cornerSmoothing: 1,
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter myState) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              250,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20,
                                                left: 10.0,
                                                right: 10.0),
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
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4))),
                                                        )),
                                                  ]),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 10),
                                                  child:
                                                      const SearchAddressInput(
                                                    hintText:
                                                        "Ingresa una dirección",
                                                    suffixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5.0,
                                                                right: 20),
                                                        child: Icon(
                                                            Iconsax.location5,
                                                            color: gray20)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0,
                                                          right: 10.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                          // TODO: Revisar rutas
                                                          return const CurrentLocationPage(
                                                            navigationOptions: {
                                                              "nextRoute":
                                                                  "home",
                                                              "removeUntil":
                                                                  true
                                                            },
                                                          );
                                                        }),
                                                      );
                                                    },
                                                    child: ListTile(
                                                      leading: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0),
                                                        child:
                                                            Icon(Iconsax.gps5),
                                                      ),
                                                      title: Text(
                                                        'Ubicación Actual',
                                                        style: subHeading1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
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
                                                          print(locationProvider
                                                              .iDLocationSelected);

                                                          loadFuture();

                                                          myState(() {});
                                                        },
                                                        child: ListTile(
                                                          leading: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4),
                                                              child: locationProvider.iDLocationSelected ==
                                                                      _dataLocations[
                                                                              index]
                                                                          .id
                                                                  ? const Icon(
                                                                      Icons
                                                                          .check,
                                                                      color:
                                                                          primaryClr)
                                                                  : _setIcon(
                                                                      _dataLocations[
                                                                              index]
                                                                          .tagId,
                                                                      locationProvider
                                                                          .iDLocationSelected)),
                                                          trailing:
                                                              DropdownButton(
                                                            icon: const Icon(
                                                                Iconsax.more),
                                                            elevation: 16,
                                                            style: subHeading1,
                                                            onChanged: (int?
                                                                newValue) async {
                                                              if (newValue ==
                                                                  0) {
                                                                if (await ServiceDirections
                                                                    .deleteDirection(
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
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) =>
                                                                                const HomePage()),
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false);
                                                                  }
                                                                }
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          EditLocationPage(
                                                                            data:
                                                                                LocationData(
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
                                                          title: Text(
                                                            _dataLocations[
                                                                    index]
                                                                .directionInOneLine,
                                                            style: subHeading1,
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
                                  isRequired: true,
                                  controller: _addressController,
                                  label: "Ubicación de entrega",
                                  hintText: "Selecciona una ubicación",
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ));
                  }
                }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
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
