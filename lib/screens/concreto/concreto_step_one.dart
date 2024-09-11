import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/concreto_provider.dart';
import 'package:mining_solutions/screens/concreto/concreto_details.dart';
import 'package:mining_solutions/screens/concreto/concreto_step.dart';
import 'package:mining_solutions/utils/fetch_json.dart';
import 'package:mining_solutions/widgets/cart_topbar.dart';
import 'package:skeletons/skeletons.dart';

import 'package:provider/provider.dart';

Map addImage(dynamic map) {
  switch (map['use']) {
    case "Banquetas":
      map.addAll({"image": "assets/banquetas.png"});
      break;
    case "Castillos o columnas":
      map.addAll({"image": "assets/castillos_columnas.png"});
      break;
    case "Cimentación o zapata":
      map.addAll({"image": "assets/cimentacion.png"});
      break;

    case "Losa de entrepiso o techo":
      map.addAll({"image": "assets/losa_techo.png"});
      break;
    case "Pisos o firmes":
      map.addAll({"image": "assets/pisos.png"});
      break;
    default:
      break;
  }

  return map;
}

Map transformJson(dynamic json) {
  json["id"] = json["id"].toString();
  json["title"] = json["use"];
  json["img"] = json["img"];
  json["description"] = json["description"] ??
      "Sed dictum fermentum leo, ut vehicula neque iaculis sed.";
  return json;
}

// {
//     "id": 1,
//     "use": "Banquetas"
// },

// {
//     "pk": 7,
//     "use": "Pisos o firmes",
//     "poured_type": {
//         "id": 1,
//         "poured_type_code": "D",
//         "poured_type_description": "Tiro directo"
//     }
// },

Map transformJsonTipoColado(dynamic json) {
  json["id"] = json["poured_type"]["id"].toString();
  json["title"] = json["poured_type"]["poured_type_description"].toString();
  json["description"] = json["description"] ??
      "Sed dictum fermentum leo, ut vehicula neque iaculis sed.";
  return json;
}

class ConcretoStepOne extends StatefulWidget {
  const ConcretoStepOne({Key? key}) : super(key: key);

  @override
  State<ConcretoStepOne> createState() => _ConcretoStepOneState();
}

class _ConcretoStepOneState extends State<ConcretoStepOne> {
  int tiroSelected = 0;

  int useTaped = 0;
  String idUsoConcreto = "1";
  String tipoColado = "1";
  @override
  void initState() {
    super.initState();
  }

  Future fetchData = fetchJson("http://23.100.25.47:8010/api/concrete/uses",
      transformingFunctions: [
        transformJson,
        addImage,
      ]);

  loadFutureTipoColado() {
    var future = fetchJson(
        "http://23.100.25.47:8010/api/concrete/list-poured-type?use-id=$idUsoConcreto",
        transformingFunctions: [
          transformJsonTipoColado,
        ]);
    return future;
  }

  loadFutureTipoConcreto() {
    var future = fetchJson(
      "http://23.100.25.47:8010/api/concrete/list-concret-type?poured-id=$tipoColado",
    );
    return future;
  }

  @override
  Widget build(BuildContext context) {
    final concretoProvider = Provider.of<ConcretoInfo>(context, listen: false);
    return Scaffold(
        appBar: const CartTopbar(title: "Concreto para tu obra"),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("¿Qué vas a construir?", style: subHeading2),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 169,
                child: FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SkeletonListView();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Map item = snapshot.data[index];

                          return GestureDetector(
                            onTap: () {
                              print(item);
                              setState(() {
                                useTaped = index;
                                idUsoConcreto = item['id'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        colorFilter: useTaped == index
                                            ? ColorFilter.mode(
                                                Colors.black.withOpacity(0.5),
                                                BlendMode.darken)
                                            : null,
                                        image: NetworkImage(item['img']),
                                        fit: BoxFit.fill,
                                      ),
                                      color: useTaped == index
                                          ? primaryClr
                                          : Colors.white,
                                      shape: SmoothRectangleBorder(
                                        side: useTaped == index
                                            ? const BorderSide(
                                                width: 1.0, color: primaryClr)
                                            : const BorderSide(
                                                width: 1.0, color: gray20),
                                        borderRadius: SmoothBorderRadius(
                                          cornerRadius: 24,
                                          cornerSmoothing: 1,
                                        ),
                                      ),
                                    ),
                                    height: 84,
                                    width: 100,
                                    child: useTaped == index
                                        ? const Icon(Icons.check,
                                            color: primaryClr, size: 28)
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      item['title'],
                                      style: subHeading2,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    future: fetchData),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Método de colado", style: subHeading2),
              ),
              SizedBox(
                height: 64,
                child: FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SkeletonListView();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Map item = snapshot.data[index];

                          return InkWell(
                              onTap: () {
                                setState(() {
                                  tiroSelected = index;
                                  tipoColado =
                                      item['poured_type']['id'].toString();
                                  print(tipoColado);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, top: 12.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: tiroSelected == index
                                                    ? primaryClr
                                                    : gray05,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 8),
                                                    Text(
                                                        item['poured_type'][
                                                            'poured_type_description'],
                                                        style: categoriesLabel),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    },
                    future: loadFutureTipoColado()),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 24.0, left: 16.0, bottom: 16.0),
                child: Text("Tipos de concreto", style: subHeading2),
              ),
              SizedBox(
                height: 1200.0,
                child: FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SkeletonListView();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Map item = snapshot.data[index];

                          return GestureDetector(
                            onTap: () {
                              concretoProvider.tipoConcreto =
                                  item['concrete_type']['concrete_type'];
                              concretoProvider.tipoColado =
                                  item['use_type_poured'];
                              concretoProvider.concreteID =
                                  item['id'].toString();

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ConcretoDetails(
                                      idConcrete: item['id']);
                                }),
                              );

                              print(item);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: gray20),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["concrete_type"]['concrete_type'],
                                      style: cardTitle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Text(item["concrete_type"]['code'],
                                          style: body),
                                    ),
                                    Text("Ver precio", style: bodyLink),
                                  ],
                                )),
                          );
                        },
                      );
                    },
                    future: loadFutureTipoConcreto()),
              ),
            ],
          ),
        )
        //   ConcretoStep(
        // title: "Concreto para tu obra",
        // apiUrl: "http://dev.hubmine.mx/api/concrete/uses",
        // tileType: ConcreteTileType.tile,
        // nextRoute: "concreto-step-two",
        // addImage: addImage,
        // transformJson: transformJson,
        //)
        );
  }
}
