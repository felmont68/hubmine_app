import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/utils/fetch_json.dart';
import 'package:mining_solutions/widgets/cart_topbar.dart';
import 'package:mining_solutions/widgets/next_button.dart';
import 'package:skeletons/skeletons.dart';

Map transformJson(dynamic json) {
  json["id"] = json["id"].toString();
  json["title"] = json["addon"] ?? "Desconocido";
  json["description"] = json["description"] ??
      "Sed dictum fermentum leo, ut vehicula neque iaculis sed.";
  json["price"] = json["price"] ?? 0;
  return json;
}

class ConcretoStepFour extends StatefulWidget {
  const ConcretoStepFour({Key? key}) : super(key: key);

  @override
  State<ConcretoStepFour> createState() => _ConcretoStepFourState();
}

class _ConcretoStepFourState extends State<ConcretoStepFour> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String title = "¿Deseas incluir añadidos?";
    const String finalUrl = "http://23.100.25.47:8010/api/concrete/addons/";

    Future fetchAddons =
        fetchJson(finalUrl, transformingFunctions: [transformJson]);

    return Scaffold(
      appBar: const CartTopbar(title: title),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SkeletonListView();
            }

            //[[
            // {
            //     "id": 1,
            //     "addon": "Hidratium",
            //     "price": 84.0
            // },
            // ]

            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 36),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Map item = snapshot.data[index];
                        print(item);
                        return GestureDetector(
                          onTap: () {
                            // TODO: Seleccionar o deseleccionar aditivos
                          },
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: gray20),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"],
                                    style: cardTitle,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(item["price"].toString(),
                                        style: body),
                                  ),
                                  Text("Falta definir precio en modelo",
                                      style: bodyLink),
                                ],
                              )),
                        );
                      },
                    ),
                  ),
                  const NextButton(nextRoute: "home")
                ],
              ),
            );
          },
          future: fetchAddons),
    );
  }
}
