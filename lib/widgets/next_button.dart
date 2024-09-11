import 'package:flutter/material.dart';
import "package:mining_solutions/hubkens/colors.dart";
import 'package:mining_solutions/hubkens/typography.dart';

class NextButton extends StatelessWidget {
  final String nextRoute;
  const NextButton({Key? key, required this.nextRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(nextRoute);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Siguiente', style: btnLight),
          const Icon(Icons.chevron_right, color: Colors.white)
        ]),
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryClr,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ));
  }
}
