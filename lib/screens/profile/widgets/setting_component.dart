import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/utils/custom_launch.dart';

class SettingComponent extends StatelessWidget {
  final Widget icon;
  final String title;
  final String route;
  
  const SettingComponent(this.icon, this.title, this.route, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route == "about") {
          launchURL("https://hubmine.app");
        } else {
          Navigator.of(context).pushNamed(route);
        }
      },
      child: Container(
        //margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            side: const BorderSide(width: 1.0, color: gray20),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 16,
              cornerSmoothing: 1,
            ),
          ),
        ),
        child: ListTile(
          leading:
              Padding(padding: const EdgeInsets.only(left: 16), child: icon),
          title: Text(title, style: subHeading2),
          trailing: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}