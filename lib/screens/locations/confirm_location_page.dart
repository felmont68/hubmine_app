import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/location_data.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/services/directions_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/input_model.dart';

class ConfirmLocationPage extends StatefulWidget {
  final String streetName;
  final String colName;
  final String postalCode;
  final String city;
  final String edo;
  final String latitud;
  final String longitud;

  final Map? navigationOptions;

  /*
    nextRoute: string
    removeUntil: bool
  */

  const ConfirmLocationPage(
      {Key? key,
      required this.streetName,
      required this.colName,
      required this.postalCode,
      required this.city,
      required this.edo,
      required this.latitud,
      required this.longitud,
      required this.navigationOptions})
      : super(key: key);

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage> {
  String? text;
  final TextEditingController _nameLocationController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _edoController = TextEditingController();
  TextEditingController _addressLineOneController = TextEditingController();
  TextEditingController _cpController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSelectedType = false;

  final _formKey = GlobalKey<FormState>();

  List dataTags = [
    {'id': 1, 'icon': 'assets/house.svg', 'tag': 'Casa'},
    {'id': 2, 'icon': 'assets/buliding.svg', 'tag': 'Obra'},
    {'id': 3, 'icon': 'assets/plant.svg', 'tag': 'Planta'},
    {'id': 4, 'icon': 'assets/corporate.svg', 'tag': 'Corporativo'},
  ];
  int selectedIndex = -1;

  late int tagId;

  _insertData() async {
    _cityController = TextEditingController(text: widget.city);
    _edoController = TextEditingController(text: widget.edo);
    _cpController = TextEditingController(text: widget.postalCode);
    _addressLineOneController =
        TextEditingController(text: widget.streetName + ' ' + widget.colName);
    setState(() {});
  }

  @override
  void initState() {
    _insertData();
    super.initState();
  }

  @override
  void dispose() {
    _nameLocationController.dispose();
    _cityController.dispose();
    _edoController.dispose();
    _addressLineOneController.dispose();
    _cpController.dispose();
    _detailsController.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        bottomNavigationBar: Container(
          height: 110,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  stops: [0.5, 0.8],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Button(
                      color: primaryClr,
                      text: Text(
                        "Guardar dirección",
                        style: subHeading2White,
                      ),
                      width: double.infinity,
                      height: size.height * 0.06,
                      action: () async {
                        // Si no hay tag, scrollear hasta abajo
                        if (selectedIndex == -1) {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);

                          return;
                        }

                        if (_isSelectedType) {
                          if (_formKey.currentState!.validate()) {
                            if (await ServiceDirections.saveDirection(
                              LocationData(
                                id: 0,
                                city: _cityController.text.isEmpty
                                    ? ''
                                    : _cityController.text,
                                details: _detailsController.text.isEmpty
                                    ? ''
                                    : _detailsController.text,
                                directionInOneLine:
                                    _addressLineOneController.text.isEmpty
                                        ? ''
                                        : _addressLineOneController.text,
                                name: _nameLocationController.text.isEmpty
                                    ? ''
                                    : _nameLocationController.text,
                                state: _edoController.text.isEmpty
                                    ? ''
                                    : _edoController.text,
                                tagId: tagId,
                                log: double.parse(widget.longitud),
                                lat: double.parse(widget.latitud),
                                haveDetails: _detailsController.text.isEmpty,
                              ),
                            )) {
                              if (widget.navigationOptions?["removeUntil"] ??
                                  false) {
                                if (widget.navigationOptions?["nextRoute"] ==
                                    "home") {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  Navigator.of(
                                          widget.navigationOptions?[
                                                  "previousContext"] ??
                                              context,
                                          rootNavigator: true)
                                      .popUntil(ModalRoute.withName(widget
                                          .navigationOptions?["nextRoute"]));
                                }
                              } else {
                                // Regresando desde search a la ruta anterior
                                NavigatorState nav = Navigator.of(context);
                                nav.pop();
                                nav.pop();
                                nav.pop();
                                nav.pop();
                              }
                            } else {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                barrierDismissible: true,
                                confirmBtnText: 'Entendido',
                                confirmBtnTextStyle: const TextStyle(
                                    fontSize: 13, color: Colors.white),
                                backgroundColor: primaryClr,
                                confirmBtnColor: primaryClr,
                                widget: const Text(
                                  'Error al guardar una nueva ubicación',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              );
                            }
                          }
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.custom,
                            barrierDismissible: true,
                            confirmBtnText: 'Entendido',
                            confirmBtnTextStyle: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            backgroundColor: primaryClr,
                            confirmBtnColor: primaryClr,
                            widget: const Text(
                              'Selecciona un tag para la ubicación',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
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
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          ),
          title: Text(
            'Verifica la ubicación',
            style: subHeading1,
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20, child: Container(color: Colors.white)),
                Container(
                  height: size.height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Input(
                            controller: _nameLocationController,
                            keyboardType: TextInputType.text,
                            isRequired: true,
                            label: "Nombre de la ubicación",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "El nombre de la ubicación es requerida";
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        Input(
                            controller: _addressLineOneController,
                            keyboardType: TextInputType.streetAddress,
                            label: "Dirección Línea 1",
                            isRequired: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "La dirección es requerida";
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        Input(
                            controller: _cityController,
                            keyboardType: TextInputType.text,
                            label: "Ciudad",
                            isRequired: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "La ciudad es requerida";
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width / 2.5,
                              child: Input(
                                  controller: _edoController,
                                  keyboardType: TextInputType.text,
                                  label: "Estado",
                                  isRequired: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "El estado es requerido";
                                    }
                                    return null;
                                  }),
                            ),
                            Container(
                              width: size.width / 2.5,
                              child: Input(
                                  controller: _cpController,
                                  keyboardType: TextInputType.text,
                                  isRequired: true,
                                  label: "Código Postal",
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "El código postal es requerido";
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Input(
                          controller: _detailsController,
                          keyboardType: TextInputType.text,
                          label: "Detalles (Referencias a la dirección)",
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Column(
                            children: [
                              Text("Tag", style: subHeading1),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60.0,
                          child: ListView.builder(
                              itemCount: dataTags.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isSelectedType = true;
                                      selectedIndex = position;
                                      tagId = dataTags[position]['id'];
                                    });
                                  },
                                  child: Card(
                                    shape: (selectedIndex == position)
                                        ? RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: primaryClr),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )
                                        : RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                    elevation: 0.4,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                            "${dataTags[position]['icon']}",
                                            color: (selectedIndex == position)
                                                ? primaryClr
                                                : gray40,
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text("${dataTags[position]['tag']}",
                                              style: (selectedIndex == position)
                                                  ? subHeading2
                                                  : subHeading2Gray)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
