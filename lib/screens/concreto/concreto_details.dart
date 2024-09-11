import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/concreto_provider.dart';
import 'package:mining_solutions/screens/driver/register/widgets/custom_bottom_sheet.dart';
import 'package:mining_solutions/utils/fetch_json.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/cart_topbar.dart';
import 'package:mining_solutions/widgets/input_model.dart';
import 'package:mining_solutions/widgets/stepper_button.dart';
import 'package:skeletons/skeletons.dart';

import 'data/tiempo_entre_camiones.dart';

import 'package:provider/provider.dart';

Map transformJson(dynamic json) {
  json["id"] = json["id"].toString();
  json["title"] = json["con_type"] ?? "Desconocido";
  json["description"] = json["description"] ??
      "Sed dictum fermentum leo, ut vehicula neque iaculis sed.";
  json["price"] = json["price"] ?? 0;
  json["resistence"] = json["tech_feat"]["resistence"] ?? "";
  json["slump"] = json["tech_feat"]["slump"] ?? "";
  return json;
}

//[
//{
//  id: 1,
//  con_type: Resistencia F’C 150 Rev10,
//  description: ,
//  price: 1505.0,
//  tech_feat: {resistence: 150 kg/m^2, slump: 10},
//  title: Resistencia F’C 150 Rev10,
//  resistence: 150 kg/m^2,
//  slump: 10
// }
// ]

class ConcretoDetails extends StatefulWidget {
  final idConcrete;
  const ConcretoDetails({Key? key, required this.idConcrete}) : super(key: key);

  @override
  State<ConcretoDetails> createState() => _ConcretoDetailsState();
}

class _ConcretoDetailsState extends State<ConcretoDetails> {
  final TextEditingController _controllerTotal =
      TextEditingController(text: "1");
  final TextEditingController _controllerCantidad =
      TextEditingController(text: "1");

  int trucks = 1;
  String timeBetweenTrucks = "Todos los camiones a la vez";

  loadFutureDetails() async {
    String apiUrl =
        "http://23.100.25.47:8010/api/concrete/details?concrete-type-id=${widget.idConcrete}";
    Future fetchDetails =
        fetchJson(apiUrl, transformingFunctions: [transformJson]);

    return fetchDetails;
  }

  @override
  void initState() {
    super.initState();
    loadFutureDetails();
  }

  calculateTrucks() {
    var divisionEntera =
        int.parse(_controllerTotal.text) ~/ int.parse(_controllerCantidad.text);
    var incognita =
        int.parse(_controllerTotal.text) % int.parse(_controllerCantidad.text);
    if (incognita >= 1) {
      divisionEntera = divisionEntera + 1;
    }
    return divisionEntera;
  }

  @override
  Widget build(BuildContext context) {
    final concretoProvider = Provider.of<ConcretoInfo>(context, listen: false);
    const String title = "Información del producto";

    const String nextRoute = "concreto-step-four";
    final size = MediaQuery.of(context).size;
    // getData();

    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
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
                      "Siguiente",
                      style: subHeading2White,
                    ),
                    width: double.infinity,
                    height: size.height * 0.06,
                    action: () {
                      concretoProvider.timeBTID = timeBetweenTrucks;
                      concretoProvider.cuantity = _controllerTotal.text;
                      concretoProvider.cuantityByTruck =
                          _controllerCantidad.text;
                      concretoProvider.numberOfTrucks = trucks.toString();
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 32,
                              cornerSmoothing: 1,
                            ),
                          ),
                          builder: (BuildContext context) {
                            return BottomSheetAditivos(
                                title: "¿Deseas incluir aditivos?",
                                options: tiempoEntreCamiones,
                                onTap: (value) {
                                  setState(() {});
                                  Navigator.pop(context);
                                });
                          });
                      //Navigator.of(context).pushNamed(nextRoute);
                    }),
              ],
            ),
          ),
        ),
      ),
      appBar: const CartTopbar(title: title),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SkeletonListView();
            }

            Map item = snapshot.data[0];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"],
                      style: cardTitle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 8),
                      child: Text("Tiro con bomba", style: body),
                    ),
                    Text("\$ ${item["price"].toString()} / m³",
                        style: bodyLink),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Concreto Tipo ${item['title']}, de la mejor calidad, premezclado, entregado hasta tu obra en el día y hora que tú lo requieras.",
                        style: body,
                      ),
                    ),
                    Text("Características técnicas", style: subtitle),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          ConcreteTechFeature(
                              title: item["resistence"],
                              subtitle: "Resistencia"),
                          ConcreteTechFeature(
                              title: item["slump"], subtitle: "Revenimiento"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text("Detalles para tu pedido", style: subtitle),
                    const SizedBox(height: 8),
                    ConcreteStepper(
                      title: "Cantidad total",
                      subtitle: "(m³)",
                      controller: _controllerTotal,
                      decrementFunction: () {
                        if (int.parse(_controllerTotal.text) > 1) {
                          setState(() {
                            _controllerTotal.text =
                                (int.parse(_controllerTotal.text) - 1)
                                    .toString();
                            trucks = calculateTrucks();
                          });
                        } else {}
                      },
                      incrementFunction: () {
                        setState(() {
                          _controllerTotal.text =
                              (int.parse(_controllerTotal.text) + 1).toString();
                          trucks = calculateTrucks();
                        });
                      },
                      onEditingCompleteFunction: () {
                        if (_controllerTotal.text.isEmpty) {
                          _controllerTotal.text = "1";
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ConcreteStepper(
                      title: "Cantidad por camión",
                      subtitle: "(m³)",
                      controller: _controllerCantidad,
                      decrementFunction: () {
                        if (int.parse(_controllerCantidad.text) > 1) {
                          setState(() {
                            _controllerCantidad.text =
                                (int.parse(_controllerCantidad.text) - 1)
                                    .toString();
                            trucks = calculateTrucks();
                          });
                        } else {}
                      },
                      incrementFunction: () {
                        if (int.parse(_controllerCantidad.text) <
                                int.parse(_controllerTotal.text) &&
                            int.parse(_controllerCantidad.text) < 7) {
                          setState(() {
                            _controllerCantidad.text =
                                (int.parse(_controllerCantidad.text) + 1)
                                    .toString();
                            trucks = calculateTrucks();
                          });
                        } else {}
                      },
                      onEditingCompleteFunction: () {
                        if (_controllerCantidad.text.isEmpty) {
                          _controllerCantidad.text = "1";
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ConcreteDropdown(
                          readOnly: true,
                          flex: 1,
                          title: "No. camiones",
                          value: trucks,
                          items: const [
                            DropdownMenuItem(child: Text("1"), value: 1),
                          ],
                          onChanged: (value) {
                            setState(() {
                              trucks = int.parse(value.toString());
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        ConcreteDropdown(
                          readOnly: false,
                          flex: 3,
                          title: "Tiempo entre camiones",
                          value: timeBetweenTrucks,
                          items: [
                            DropdownMenuItem(
                                child: Text("Todos los camiones",
                                    style: bodyBlack),
                                value: "Todos los camiones al mismo tiempo"),
                          ],
                          onChanged: (value) {
                            setState(() {
                              timeBetweenTrucks = value.toString();
                              concretoProvider.timeBTID = timeBetweenTrucks;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
          future: loadFutureDetails()),
    );
  }
}

class ConcreteTechFeature extends StatelessWidget {
  const ConcreteTechFeature(
      {required this.title, required this.subtitle, Key? key})
      : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              side: const BorderSide(width: 1.0, color: gray20),
              borderRadius: SmoothBorderRadius(
                cornerRadius: 12,
                cornerSmoothing: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Iconsax.document_text_15,
                    color: primaryClr, size: 28),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: cartItemHeading),
                    Text(subtitle, style: body),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConcreteStepper extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback decrementFunction;
  final VoidCallback incrementFunction;
  final VoidCallback onEditingCompleteFunction;
  final TextEditingController controller;

  const ConcreteStepper(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.decrementFunction,
      required this.incrementFunction,
      required this.controller,
      required this.onEditingCompleteFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$title ",
                style: cartItemHeading,
              ),
              TextSpan(
                text: subtitle,
                style: cartItemSubHeading,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: StepperButton("down", onTap: () {
                decrementFunction();
              }, height: 32, width: 32),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: gray05)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: body,
                    controller: controller,
                    maxLines: 1,
                    onEditingComplete: onEditingCompleteFunction),
              ),
            ),
            Expanded(
              child: StepperButton("up", onTap: () {
                incrementFunction();
              }),
            )
          ],
        )
      ],
    );
  }
}

class ConcreteDropdown extends StatefulWidget {
  final String title;
  final Object value;
  final List<DropdownMenuItem<Object>> items;
  final int flex;
  final bool readOnly;
  final void Function(Object?) onChanged;

  const ConcreteDropdown(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChanged,
      required this.readOnly,
      required this.items,
      required this.flex})
      : super(key: key);

  @override
  State<ConcreteDropdown> createState() => _ConcreteDropdownState();
}

class _ConcreteDropdownState extends State<ConcreteDropdown> {
  final TextEditingController _tiempoSelectedController =
      TextEditingController();
  String tiempoSelected = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          child: widget.readOnly
              ? InputDisabled(
                  label: widget.title, hintText: widget.value.toString())
              : InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 32,
                            cornerSmoothing: 1,
                          ),
                        ),
                        builder: (BuildContext context) {
                          return CustomBottomSheet(
                              title: widget.title,
                              options: tiempoEntreCamiones,
                              onTap: (value) {
                                _tiempoSelectedController.text = value;
                                setState(() {
                                  tiempoSelected = value;
                                });
                                Navigator.pop(context);
                              });
                        });
                  },
                  child: InputDropdown(
                      isRequired: true,
                      controller: _tiempoSelectedController,
                      label: widget.title,
                      hintText: widget.value.toString()),
                ),
        ),
      ]),
    );
  }
}
