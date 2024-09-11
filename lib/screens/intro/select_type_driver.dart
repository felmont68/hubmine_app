import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/register_provider.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:provider/provider.dart';

class SelectTypeDriver extends StatefulWidget {
  const SelectTypeDriver({Key? key}) : super(key: key);

  @override
  _SelectTypeDriverState createState() => _SelectTypeDriverState();
}

class _SelectTypeDriverState extends State<SelectTypeDriver> {
  int selectedIndex = -1;
  bool isSelectedSomething = false;
  late List<TypeAccount> typesAccount;

  @override
  void initState() {
    super.initState();
    typesAccount = [
      TypeAccount(
          typeDriver: "1",
          isSelected: false,
          icon: "assets/truck.svg",
          title: "Transportista",
          description:
              "Dispongo de uno o más vehículos y tengo colaboradores conductores (Pero no soy conductor)."),
      TypeAccount(
          typeDriver: "2",
          isSelected: false,
          icon: "assets/truck_n_driver.svg",
          title: "Transportista y conductor",
          description:
              "Dispongo de uno o más vehículos, algunos conductores, pero también soy conductor."),
      TypeAccount(
          typeDriver: "3",
          isSelected: false,
          icon: "assets/driver.svg",
          title: "Conductor",
          description:
              "Soy un conductor sin vehículo(s) buscando oportunidades.")
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
                      const EdgeInsets.only(top: 10.0, left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                          child: Text("¿Cómo te identificas?", style: heading)),
                      const Flexible(child: SizedBox(height: 6)),
                      Flexible(
                        child: Text(
                          "Según tu necesidad de transporte, cuéntanos cuál es tu perfil.",
                          style: bodyGray80,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height - 100,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: typesAccount.length,
                      itemBuilder: (BuildContext context, int position) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              registerInfo.typeDriver =
                                  typesAccount[position].typeDriver as String;
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
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
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
                                              : gray20,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            typesAccount[position]
                                                .title
                                                .toString(),
                                            style: subHeading1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Text(
                                        typesAccount[position]
                                            .description
                                            .toString(),
                                        style: bodyGray80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //height: 104,
                              /*child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
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
                                                  .title
                                                  .toString(),
                                              style: subHeading1,
                                            ),
                                          ),
                                        ],
                                      ),
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
                              ),*/
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
  String? typeDriver;
  String? icon;
  String? title;
  String? description;
  String? richAction;

  TypeAccount(
      {this.isSelected,
      this.typeDriver,
      this.icon,
      this.title,
      this.description,
      this.richAction});
}
