import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:expandable/expandable.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Recompensas", style: subHeading1),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.04,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hubcoins", style: heading3),
                    ],
                  ),
                ),
                SizedBox(
                  child: Material(
                    elevation: 0.6,
                    shadowColor: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                        height: size.height * 0.21,
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(r"$100.00", style: heading2Black),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage(
                                                "assets/hubcoin.png"))
                                      ],
                                    ),
                                    Text("Disponible", style: bodyBlack),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black45,
                                  thickness: 0.0,
                                ),
                                Text("Balance:", style: bodyBlack),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(r"$100.00",
                                              style: heading2Black),
                                          Text("Para compras", style: body)
                                        ]),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(r"$0.00", style: heading2Black),
                                          Text("Para envíos", style: body)
                                        ])
                                  ],
                                )
                              ]),
                        )),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: size.height * 0.04,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Historial", style: heading3)],
                  ),
                ),
                SizedBox(
                  child: Material(
                    elevation: 0.6,
                    shadowColor: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                        height: size.height * 0.13,
                        width: size.width,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Bono de bienvenida",
                                              style: subHeading1),
                                          Text("Expira en: 15 de Sept. 2024",
                                              style: body),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/cart.svg",
                                                  color: gray20,
                                                  width: 18,
                                                  height: 18),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text("Para compras",
                                                  style: bodyGray40)
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(r"$100.00", style: subHeading1)
                                        ],
                                      )
                                    ]),
                              ],
                            ))),
                  ),
                ),
                const SizedBox(height: 30),
                Text("Sobre tus Hubcoins", style: heading3),
                const SizedBox(height: 30),
                ExpandablePanel(
                  header: Text("¿Qué son los Hubcoins", style: subHeading1),
                  collapsed: const Divider(),
                  expanded: Text(
                      "Los Hubcoins son la moneda de recompensas que obtienes en Hubmine al referir a tus amigos y realizar compras. El uso de estas está limitada a la aplicación Hubmine.",
                      softWrap: true,
                      style: body),
                ),
                const SizedBox(height: 10),
                ExpandablePanel(
                  header: Text("¿Que valor tienen?", style: subHeading1),
                  collapsed: const Text(
                    "",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Text(
                      "1 Hubcoin = 1 MXN. Puedes utilizar tus Hubcoins para comprar productos o pagar parte del envío de tus productos",
                      style: body,
                      softWrap: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
