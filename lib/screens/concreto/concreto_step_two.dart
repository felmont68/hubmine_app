import 'package:flutter/material.dart';
import 'package:mining_solutions/screens/concreto/concreto_step.dart';

Map addImage(dynamic map) {
  switch (map['title']) {
    case "Tiro directo":
      map.addAll({"image": "assets/directo.png"});
      break;
    case "Tiro con bomba":
      map.addAll({"image": "assets/bomba.png"});
      break;
    default:
      break;
  }

  return map;
}

Map transformJson(dynamic json) {
  json["id"] = json["poured_type"]["id"].toString();
  json["title"] = json["poured_type"]["poured_type_description"].toString();
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

class ConcretoStepTwo extends StatelessWidget {
  const ConcretoStepTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: ConcretoStep(
      title: "Elige el tipo de colado",
      apiUrl: "http://23.100.25.47:8010/api/concrete/list-poured-type?use-id=",
      tileType: ConcreteTileType.tile,
      nextRoute: "concreto-step-three",
      addImage: addImage,
      transformJson: transformJson,
    ));
  }
}
