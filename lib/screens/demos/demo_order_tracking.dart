import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/widgets/input_model.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Your order #224543 will be delivered Today February 18 by José Perez between 13:30 and 13:49",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        height: 50,
                        color: accentRed,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                              radius: 35.0,
                              backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1593035013811-2db9b3c36980?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2944&q=80")),
                          Container(
                            width: 80.0,
                            height: 70.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://www.pngfind.com/pngs/m/464-4648415_camion-de-carga-png-hino-26-foot-truck.png"),
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text("Kenworth 10 TN"),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("4BCF25")
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: const [Text("Hubmine Driver")],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: const [
                      Text("José Perez"),
                      SizedBox(width: 10.0),
                      Text("5.0"),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(Icons.stars_rounded)
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: (Colors.grey[200])!,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                        child: IconButton(
                            color: Colors.grey,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.phone,
                              color: primaryClr,
                            )),
                      ),
                      const SizedBox(
                          width: 300,
                          child: InputTravelInstructions(
                            label: "Any travel instructions?",
                          ))
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
