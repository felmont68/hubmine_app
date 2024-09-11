import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/widgets/stepper_button.dart';

class IncrementQuantity extends StatefulWidget {
  final options;
  final String title;
  Map? item;
  IncrementQuantity({Key? key, this.options, required this.title, this.item})
      : super(key: key);

  @override
  State<IncrementQuantity> createState() => _IncrementQuantityState();
}

class _IncrementQuantityState extends State<IncrementQuantity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: ListView(
        children: <Widget>[
          // Decoración al principio del bottom sheet
          Center(
            child: Wrap(children: [
              SizedBox(
                  width: 20,
                  height: 6,
                  child: Container(
                    // color: HMColor.primary,
                    decoration: const BoxDecoration(
                        color: primaryClr,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: Text(widget.title, style: heading),
          ),
          Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  StepperButton("down", onTap: () {
                    if (widget.item!["quantity"] > 0.25) {
                      setState(() {
                        widget.item!["quantity"] -= 0.25;

                        widget.item!["subtotal"] =
                            widget.item!["price"] * widget.item!["quantity"];
                      });
                    }
                  }),
                  Text("${(widget.item!["quantity"]).toStringAsFixed(2)} tons",
                      style: cartItemQuantity),
                  StepperButton(
                    "up",
                    onTap: () {
                      if (widget.item!["quantity"] < 5000) {
                        setState(() {
                          widget.item!["quantity"] += 0.25;
                          widget.item!["subtotal"] =
                              widget.item!["price"] * widget.item!["quantity"];
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}
