import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:timelines/timelines.dart';

import '../helpers/shared_prefs.dart';
import '../screens/turn_by_turn.dart';

Widget reviewRideBottomSheet(
    orderDetails,
    VoidCallback agreeTrip,
    bool hasAgreeTrip,
    BuildContext context,
    String distance,
    String dropOffTime,
    String duration,
    String material,
    String totalMaterial,
    String plantaRecoleccion,
    String destino,
    String time,
    String priceShipping) {
  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');
  final _width = MediaQuery.of(context).size.width;
  final _height = MediaQuery.of(context).size.height;

  return Stack(
    alignment: Alignment.center,
    children: [
      Positioned(
        top: 50,
        right: 20,
        child: InkWell(
          onTap: () {},
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Iconsax.close_circle5, size: 48)),
        ),
      ),
      Positioned(
        bottom: 20,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 16,
                cornerSmoothing: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(material, style: heading3),
                            Text(totalMaterial, style: heading3),
                          ],
                        ),
                        Text(r"Flete: " r"$" + priceShipping, style: heading3)
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$duration min.', style: subHeading1),
                        Text('$distance km', style: subHeading1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        TimelineTile(
                          nodeAlign: TimelineNodeAlign.start,
                          contents: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Recolección: $plantaRecoleccion',
                                style: body),
                          ),
                          node: const TimelineNode(
                            indicator: DotIndicator(color: primaryLightClr),
                            endConnector: DecoratedLineConnector(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [primaryLightClr, primaryLightClr],
                                ),
                              ),
                            ),
                          ),
                        ),
                        TimelineTile(
                          nodeAlign: TimelineNodeAlign.start,
                          contents: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Destino: $destino', style: body),
                          ),
                          node: const TimelineNode(
                            indicator: DotIndicator(color: primaryClr),
                            startConnector: DecoratedLineConnector(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [primaryLightClr, primaryClr],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        agreeTrip();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    TurnByTurn(orderDetails: orderDetails)));
                      },
                      color: primaryClr,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 16,
                          cornerSmoothing: 1,
                        ),
                      ),
                      child: SizedBox(
                        width: _width,
                        height: _height * 0.068,
                        child: Center(
                          child: Text(
                            'Aceptar viaje',
                            style: subHeading2White,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 300,
        left: MediaQuery.of(context).size.width / 2.3,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Container(
            decoration: const BoxDecoration(
                color: primaryLightClr, shape: BoxShape.circle),
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation(primaryClr),
              backgroundColor: Colors.white,
              value: 1 - int.parse(time) / 20,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 300,
        left: MediaQuery.of(context).size.width / 2.3,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset("assets/truck.svg", color: primaryClr),
          ),
        ),
      ),
    ],
  );
  // Positioned(
  //   bottom: 0,
  //   child: SizedBox(
  //     width: MediaQuery.of(context).size.width,
  //     child: Card(
  //       clipBehavior: Clip.antiAlias,
  //       child: Padding(
  //         padding: const EdgeInsets.all(15),
  //         child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 '$sourceAddress ➡ $destinationAddress',
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 10),
  //                 child: ListTile(
  //                   tileColor: Colors.grey[200],
  //                   leading: const Image(
  //                       image: AssetImage('assets/camion-revolvedor.jpeg'),
  //                       height: 50,
  //                       width: 50),
  //                   title: const Text('Premier',
  //                       style: TextStyle(
  //                           fontSize: 18, fontWeight: FontWeight.bold)),
  //                   subtitle: Text('$distance km, $dropOffTime drop off'),
  //                   trailing: const Text('\$384.22',
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 18)),
  //                 ),
  //               ),
  //               ElevatedButton(
  //                   onPressed: () => Navigator.push(context,
  //                       MaterialPageRoute(builder: (_) => const TurnByTurn())),
  //                   style: ElevatedButton.styleFrom(
  //                       padding: const EdgeInsets.all(20)),
  //                   child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: const [
  //                         Text('Start your premier ride now'),
  //                       ])),
  //             ]),
  //       ),
  //     ),
  //   ),
  // );
}
