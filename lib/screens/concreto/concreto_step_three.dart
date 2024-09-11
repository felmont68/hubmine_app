import 'package:flutter/material.dart';
import 'package:mining_solutions/screens/concreto/concreto_step.dart';

Map addImage(dynamic map) {
  return map;
}

Map transformJson(dynamic json) {
  json["id"] = json["id"].toString(); // Es ID del colado o del concreto?
  json["title"] = json["concrete_type"]["concrete_type"].toString();
  json["subtitle"] = json["use_type_poured"];
  json["description"] = json["description"] ??
      "Sed dictum fermentum leo, ut vehicula neque iaculis sed.";
  return json;
}

// {
//     "pk": 7,
//     "use": "Pisos o firmes",
//     "poured_type": {
//         "id": 1,
//         "poured_type_code": "D",
//         "poured_type_description": "Tiro directo"
//     }
// },

// {
//     "id": 1,
//     "use": "Banquetas",
//     "use_type_poured": "Tiro directo",
//     "concrete_type": {
//         "code": "RFC150R10",
//         "concrete_type": "Resistencia F’C 150 Rev10"
//     }
// }

class ConcretoStepThree extends StatelessWidget {
  const ConcretoStepThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: ConcretoStep(
      title: "Elige el tipo de concreto",
      apiUrl:
          "http://23.100.25.47:8010/api/concrete/list-concret-type?poured-id=",
      tileType: ConcreteTileType.card,
      nextRoute: "concreto-details",
      addImage: addImage,
      transformJson: transformJson,
    ));
  }
}
