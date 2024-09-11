import 'package:flutter/material.dart';

import 'package:mining_solutions/hubkens/colors.dart';

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    disabledColor: gray40,
    unselectedWidgetColor: gray40,
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: primaryClr,
          secondary: primaryClr,
        ),
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
    primaryColor: primaryClr,
  );
}
