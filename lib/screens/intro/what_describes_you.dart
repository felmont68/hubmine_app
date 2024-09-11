import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/register_provider.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:provider/provider.dart';

class WhatDescribesYouScreen extends StatefulWidget {
  const WhatDescribesYouScreen({Key? key}) : super(key: key);

  @override
  _WhatDescribesYouScreenState createState() => _WhatDescribesYouScreenState();
}

class _WhatDescribesYouScreenState extends State<WhatDescribesYouScreen> {
  // Selecciona el tipo de cuenta del usuario

  int selectedIndex = -1;
  bool isSelectedSomething = false;

  ///

  late List<TypeAccount> typesAccount;

  @override
  void initState() {
    super.initState();
    typesAccount = [
      TypeAccount(
          customerTypeID: "1",
          isSelected: false,
          icon: "assets/cart.svg",
          firstWord: 'Soy ',
          richAction: "persona física ",
          description:
              "Para ti que quieres construir, adquiere material en menos de 5 minutos, fácil y rápido."),
      TypeAccount(
          customerTypeID: "2",
          isSelected: false,
          icon: "assets/shop.svg",
          firstWord: 'Tengo un ',
          richAction: "negocio",
          description:
              "Vende tus productos en Hubmine y aumenta tu volumen de ventas."),
      TypeAccount(
          customerTypeID: "3",
          isSelected: false,
          icon: "assets/truck.svg",
          firstWord: 'Trabajo para una ',
          richAction: "empresa",
          description:
              "Conduce en Hubmine y genera más ingresos como Conductor.")
    ];
  }

  @override
  Widget build(BuildContext context) {
    final registerInfo = Provider.of<RegisterInfo>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Iconsax.arrow_left,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: isSelectedSomething
          ? Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Button(
                        color: primaryClr,
                        text: Text(
                          "Siguiente",
                          style: subHeading2White,
                        ),
                        width: double.infinity,
                        height: size.height * 0.06,
                        action: () {
                          Navigator.of(context)
                              .pushNamed('register-with-phone');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 20.0, right: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("¿Cómo te quieres registrar?", style: heading),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(
                  height: height - 80,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: typesAccount.length,
                      itemBuilder: (BuildContext context, int position) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              registerInfo.customerTypeID =
                                  typesAccount[position].customerTypeID
                                      as String;
                              selectedIndex = position;
                              isSelectedSomething = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 24, left: 14.0, right: 14.0),
                            child: Container(
                              decoration: selectedIndex == position
                                  ? ShapeDecoration(
                                      color: Colors.white,
                                      shape: SmoothRectangleBorder(
                                        side: selectedIndex == position
                                            ? const BorderSide(
                                                width: 1.0, color: primaryClr)
                                            : const BorderSide(
                                                width: 1.0, color: gray20),
                                        borderRadius: SmoothBorderRadius(
                                          cornerRadius: 24,
                                          cornerSmoothing: 1.0,
                                        ),
                                      ),
                                    )
                                  : ShapeDecoration(
                                      color: Colors.white,
                                      shape: SmoothRectangleBorder(
                                        side: const BorderSide(
                                            width: 1.0, color: gray20),
                                        borderRadius: SmoothBorderRadius(
                                          cornerRadius: 24,
                                          cornerSmoothing: 1.0,
                                        ),
                                      ),
                                    ),
                              width: width,
                              height: 104,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            "${typesAccount[position].icon}",
                                            width: 24,
                                            height: 24,
                                            color: selectedIndex == position
                                                ? primaryClr
                                                : gray20),
                                        const SizedBox(width: 5),
                                        RichText(
                                          text: TextSpan(
                                            text: typesAccount[position]
                                                .firstWord
                                                .toString(),
                                            style: subHeading1,
                                            children: [
                                              TextSpan(
                                                text: typesAccount[position]
                                                    .richAction
                                                    .toString(),
                                                style: subHeading1Primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      typesAccount[position]
                                          .description
                                          .toString(),
                                      style: bodyGray80,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ]),
        ),
      ),
    );
  }
}

class TypeAccount {
  bool? isSelected;
  String? customerTypeID;
  String? icon;
  String? firstWord;
  String? lastWord;
  String? description;
  String? richAction;

  TypeAccount(
      {this.isSelected,
      this.customerTypeID,
      this.icon,
      this.firstWord,
      this.lastWord,
      this.description,
      this.richAction});
}
