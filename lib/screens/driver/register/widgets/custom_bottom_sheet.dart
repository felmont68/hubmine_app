import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/concreto_provider.dart';
import 'package:mining_solutions/screens/concreto/select_date_shipping_concrete.dart';
import 'package:mining_solutions/utils/fetch_json.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:skeletons/skeletons.dart';

import 'package:provider/provider.dart';

class CustomBottomSheet extends StatefulWidget {
  final ValueSetter<String> onTap;
  final options;
  final String title;
  const CustomBottomSheet(
      {Key? key, required this.onTap, this.options, required this.title})
      : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: ListView(
        children: <Widget>[
          // Decoración al principio del bottom sheet
          Center(
            child: Wrap(children: [
              SizedBox(
                  width: 20,
                  height: 6,
                  child: Container(
                    // color: HMColor.primary,
                    decoration: BoxDecoration(
                        color: primaryClr,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 10.0),
            child: Text(widget.title, style: heading),
          ),
          Column(
            children: renderOptions(),
          )
        ],
      ),
    );
  }

  List<Widget> renderOptions() {
    return widget.options
        .map<Widget>((option) => Column(
              children: [
                ListTile(
                  title: Text(option, style: subHeading1),
                  onTap: () {
                    widget.onTap(option);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(color: gray20),
                )
              ],
            ))
        .toList();
  }
}

Widget renderOption(String text) {
  return Text(text);
}

Map transformJson(dynamic json) {
  json["id"] = json["id"].toString();
  json["title"] = json["addon"] ?? "Desconocido";
  json["description"] = json["description"] ??
      "Sed dictum fermentum leo, ut vehicula neque iaculis sed.";
  json["price"] = json["price"] ?? 0;
  return json;
}

class BottomSheetAditivos extends StatefulWidget {
  final ValueSetter<String> onTap;
  final options;
  final String title;
  const BottomSheetAditivos(
      {Key? key, required this.onTap, this.options, required this.title})
      : super(key: key);

  @override
  State<BottomSheetAditivos> createState() => _BottomSheetAditivosState();
}

class _BottomSheetAditivosState extends State<BottomSheetAditivos> {
  List addonsToInclude = [];
  @override
  Widget build(BuildContext context) {
    final concretoProvider = Provider.of<ConcretoInfo>(context, listen: false);
    const String title = "¿Deseas incluir añadidos?";
    const String finalUrl = "http://23.100.25.47:8010/api/concrete/addons/";
    Future fetchAddons =
        fetchJson(finalUrl, transformingFunctions: [transformJson]);
    return Container(
      height: MediaQuery.of(context).size.height / 1.3,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: ListView(
        children: <Widget>[
          // Decoración al principio del bottom sheet
          Center(
            child: Wrap(children: [
              SizedBox(
                  width: 20,
                  height: 6,
                  child: Container(
                    // color: HMColor.primary,
                    decoration: BoxDecoration(
                        color: primaryClr,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Text(widget.title, style: heading),
          ),
          SizedBox(
            height: 420,
            child: FutureBuilder(
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SkeletonListView();
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 20, bottom: 36),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              Map item = snapshot.data[index];

                              return GestureDetector(
                                onTap: () {
                                  // TODO: Seleccionar o deseleccionar aditivos
                                  print(item);
                                  if (addonsToInclude.contains(item['id'])) {
                                    setState(() {
                                      addonsToInclude.remove(item['id']);
                                    });
                                  } else {
                                    setState(() {
                                      addonsToInclude.add(item['id']);
                                    });
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            addonsToInclude.contains(item['id'])
                                                ? primaryClr
                                                : gray20,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item["title"],
                                              style: cardTitle,
                                            ),
                                            SizedBox(width: 8),
                                            addonsToInclude.contains(item['id'])
                                                ? Icon(
                                                    Icons.check_circle_outline,
                                                    color: primaryClr)
                                                : Container(),
                                          ],
                                        ),
                                        Text(
                                            "\$ ${item["price"].toString()} / m³",
                                            style: bodyLink),
                                      ],
                                    )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                future: fetchAddons),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                addonsToInclude.isNotEmpty
                    ? Button(
                        action: () {
                          concretoProvider.addons = addonsToInclude;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SelectDateShippingConcretePage(),
                            ),
                          );
                        },
                        text: Text("Agregar", style: subHeading2White),
                        height: 56,
                        color: primaryClr,
                      )
                    : ButtonDisabled(
                        text: Text("Agregar", style: subHeading2White),
                        height: 56,
                        color: primaryClr,
                      ),
                SizedBox(
                  height: 16,
                ),
                ButtonSide(
                    action: () {
                      concretoProvider.addons = addonsToInclude;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SelectDateShippingConcretePage(),
                        ),
                      );
                    },
                    text: Text("No incluir aditivos",
                        style: subHeading2PrimaryClr),
                    height: 56),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetConcreto extends StatefulWidget {
  final ValueSetter<String> onTap;
  final options;
  final String title;
  const BottomSheetConcreto(
      {Key? key, required this.onTap, this.options, required this.title})
      : super(key: key);

  @override
  State<BottomSheetConcreto> createState() => _BottomSheetConcretoState();
}

class _BottomSheetConcretoState extends State<BottomSheetConcreto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.9,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: ListView(
        children: <Widget>[
          // Decoración al principio del bottom sheet
          Center(
            child: Wrap(children: [
              SizedBox(
                  width: 20,
                  height: 6,
                  child: Container(
                    // color: HMColor.primary,
                    decoration: BoxDecoration(
                        color: primaryClr,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 10.0),
            child: Text(widget.title, style: heading),
          ),
          Column(
            children: renderOptions(),
          )
        ],
      ),
    );
  }

  List<Widget> renderOptions() {
    return widget.options
        .map<Widget>((option) => Column(
              children: [
                ListTile(
                  title: Text(option['nombre'], style: subHeading1),
                  subtitle: Text(option['descripcion'], style: body),
                  onTap: () {
                    widget.onTap(option['nombre']);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(color: gray20),
                )
              ],
            ))
        .toList();
  }
}

class BottomSheetCountry extends StatefulWidget {
  final onTap;
  final options;
  final String title;
  const BottomSheetCountry(
      {Key? key, required this.onTap, this.options, required this.title})
      : super(key: key);

  @override
  State<BottomSheetCountry> createState() => _BottomSheetCountryState();
}

class _BottomSheetCountryState extends State<BottomSheetCountry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.9,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: ListView(
        children: <Widget>[
          // Decoración al principio del bottom sheet
          Center(
            child: Wrap(children: [
              SizedBox(
                  width: 20,
                  height: 6,
                  child: Container(
                    // color: HMColor.primary,
                    decoration: BoxDecoration(
                        color: primaryClr,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 10.0),
            child: Text(widget.title, style: heading),
          ),
          Column(
            children: renderOptions(),
          )
        ],
      ),
    );
  }

  List<Widget> renderOptions() {
    return widget.options
        .map<Widget>((option) => Column(
              children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Image.asset(option['flag'], width: 32, height: 32),
                  ),
                  title: Text(
                    option['nombre'],
                    style: subHeading1,
                    textAlign: TextAlign.left,
                  ),
                  onTap: () {
                    widget.onTap(
                        option['nombre'], option['flag'], option['code']);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(color: gray20),
                )
              ],
            ))
        .toList();
  }
}

class BottomSheetEsquemasRenta extends StatefulWidget {
  final onTap;
  final options;
  final String title;
  const BottomSheetEsquemasRenta(
      {Key? key, required this.onTap, this.options, required this.title})
      : super(key: key);

  @override
  State<BottomSheetEsquemasRenta> createState() =>
      _BottomSheetEsquemasRentaState();
}

class _BottomSheetEsquemasRentaState extends State<BottomSheetEsquemasRenta> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: ListView(
        children: <Widget>[
          // Decoración al principio del bottom sheet
          Center(
            child: Wrap(children: [
              SizedBox(
                  width: 20,
                  height: 6,
                  child: Container(
                    // color: HMColor.primary,
                    decoration: BoxDecoration(
                        color: primaryClr,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 10.0),
            child: Text(widget.title, style: heading),
          ),
          Column(
            children: renderOptions(),
          )
        ],
      ),
    );
  }

  List<Widget> renderOptions() {
    return widget.options
        .map<Widget>((option) => Column(
              children: [
                ListTile(
                  title:
                      Text("Renta por ${option['unity']}", style: subHeading1),
                  onTap: () {
                    widget.onTap(option);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(color: gray20),
                )
              ],
            ))
        .toList();
  }
}
