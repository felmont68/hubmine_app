import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/register/utils/business_types/business_types.dart';

class CreateAccountBottomSheet extends StatefulWidget {
  final ValueSetter<String> onTap;
  const CreateAccountBottomSheet({Key? key, required this.onTap})
      : super(key: key);

  @override
  State<CreateAccountBottomSheet> createState() =>
      _CreateAccountBottomSheetState();
}

class _CreateAccountBottomSheetState extends State<CreateAccountBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
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
            child: Text('¿Qué tipo de negocio tienes?', style: heading),
          ),
          Column(
            children: renderBusinessTypes(),
          )
        ],
      ),
    );
  }

  List<Widget> renderBusinessTypes() {
    return businessTypes
        .map((business) => Column(
              children: [
                ListTile(
                  title: Text(business, style: subHeading1),
                  onTap: () {
                    widget.onTap(business);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(color: gray20),
                )
              ],
            ))
        .toList();
  }
}

Widget renderOption(String text) {
  return Text(text);
}
