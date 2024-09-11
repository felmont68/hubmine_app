import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';

// ignore: must_be_immutable
class StepperButton extends StatelessWidget {
  StepperButton(this.type,
      {Key? key, this.width, this.height, required this.onTap})
      : super(key: key);

  final String type;
  final double? width;
  final double? height;
  final VoidCallback onTap;

  // Default values (down)
  Color backgroundColor = gray05;
  Color iconColor = Colors.black;
  IconData icon = Icons.remove;
  double left = 0, right = 8;

  @override
  Widget build(BuildContext context) {
    if (type == 'up') {
      // Up
      backgroundColor = primaryClr;
      iconColor = Colors.white;
      icon = Icons.add;
      left = 8;
      right = 0;
    }

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(4),
      margin: EdgeInsets.fromLTRB(left, 0, right, 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            color: iconColor,
          )),
    );
  }
}
