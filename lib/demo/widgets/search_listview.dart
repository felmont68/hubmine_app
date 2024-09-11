import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/main.dart';
import 'package:mining_solutions/screens/locations/search/search_location_map.dart';

Widget searchListView(
    List responses,
    bool isResponseForDestination,
    TextEditingController destinationController,
    TextEditingController sourceController) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: responses.length,
    itemBuilder: (BuildContext context, int index) {
      return Column(
        children: [
          ListTile(
            onTap: () {
              String text = responses[index]['name'];
              LatLng location = responses[index]['location'];

              destinationController.text = text;
              sharedPreferences.setString(
                  'destination', json.encode(responses[index]));

              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SearchLocationMapPage(
                          text: text,
                          lat: responses[index]['lat'],
                          long: responses[index]['long']),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(2.5, 2.0);
                    var end = Offset.zero;
                    var curve = Curves.bounceIn;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            leading: const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 5),
              child: Icon(Iconsax.location5, color: gray40),
            ),
            title: Text(responses[index]['name'], style: subHeading1),
            subtitle: Text(responses[index]['place'],
                overflow: TextOverflow.ellipsis),
          ),
          const Divider(),
        ],
      );
    },
  );
}
