import 'package:flutter/material.dart';
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

class EditLocationPage extends StatefulWidget {
  final LocationData data;
  const EditLocationPage({Key? key, required this.data}) : super(key: key);

  @override
  State<EditLocationPage> createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  TextEditingController _nameLocationController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _edoController = TextEditingController();
  TextEditingController _addressLineOneController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  bool _isSelectedType = false;
  List dataTags = [
    {'icon': 'assets/house.svg', 'tag': 'Casa'},
    {'icon': 'assets/buliding.svg', 'tag': 'Obra'},
    {'icon': 'assets/plant.svg', 'tag': 'Planta'},
    {'icon': 'assets/corporate.svg', 'tag': 'Corporativo'},
  ];
  int selectedIndex = -1;
  _insertData() async {
    _nameLocationController = TextEditingController(text: widget.data.name);
    _cityController = TextEditingController(text: widget.data.city);
    _edoController = TextEditingController(text: widget.data.state);
    _detailsController = TextEditingController(text: widget.data.details);
    _addressLineOneController =
        TextEditingController(text: widget.data.directionInOneLine);
    selectedIndex = widget.data.tagId;
    setState(() {});
  }

  @override
  void initState() {
    _insertData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
          'Editar la ubicación',
          style: subHeading1,
        ),
      ),
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
                    "Editar dirección",
                    style: subHeading2White,
                  ),
                  width: double.infinity,
                  height: size.height * 0.06,
                  action: () async {
                    if (await ServiceDirections.updateDirection(
                      LocationData(
                        id: widget.data.id,
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
                        tagId: selectedIndex,
                        lat: widget.data.lat,
                        log: widget.data.log,
                        haveDetails: _detailsController.text.isEmpty,
                      ),
                    )) {
                      print("Se disparó el primer if");
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomePage()),
                          (Route<dynamic> route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                        label: "Nombre de la ubicación",
                        isRequired: true,
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
                              label: "Código Postal",
                              isRequired: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "El código postal es requerido";
                                }
                                return null;
                              }),
                        )
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
                          itemBuilder: (BuildContext context, int position) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _isSelectedType = true;
                                  selectedIndex = position;
                                });
                              },
                              child: Card(
                                shape: (selectedIndex == position)
                                    ? RoundedRectangleBorder(
                                        side:
                                            const BorderSide(color: primaryClr),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
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
    );
  }
}
