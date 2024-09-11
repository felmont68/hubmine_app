import 'package:figma_squircle/figma_squircle.dart';
import "package:flutter/material.dart";
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';

void showCustomBottomSheet(BuildContext context, String title,
    String? description, Widget sheetBody, VoidCallback? onDismiss) {
  showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius.vertical(
            top: SmoothRadius(cornerRadius: 32, cornerSmoothing: 1)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setParentState) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Decoración al principio del bottom sheet
                    Center(
                      child: Wrap(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: SizedBox(
                              width: 20,
                              height: 6,
                              child: Container(
                                // color: HMColor.primary,
                                decoration: const BoxDecoration(
                                    color: primaryClr,
                                    borderRadius:
                                        // ignore: unnecessary_const
                                        const BorderRadius.all(
                                            Radius.circular(4))),
                              )),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0),
                      child: Column(
                        children: [
                          Text(title, style: heading),
                          if (description != null)
                            Text(description, style: body)
                        ],
                      ),
                    ),
                    sheetBody,
                    const SizedBox(height: 8),
                  ],
                )),
          );
        });
      }).whenComplete(() => onDismiss?.call());
}
