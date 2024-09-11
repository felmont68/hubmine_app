// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mining_solutions/hubkens/colors.dart';

void showAlertDialog(String message, context) {
  showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: const Text("Ups"),
          content: Text(message),
          actions: <Widget>[
            RaisedButton(
              color: primaryClr,
              child: Text(
                "Cerrar",
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
