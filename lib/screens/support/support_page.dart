import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/utils/custom_launch.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Soporte", style: subHeading1),
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
            padding: const EdgeInsets.only(left: 29.0, right: 29.0, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Preguntas frecuentes", style: heading3),
                const SizedBox(height: 30),
                ExpandablePanel(
                  header: Text("¿Qué es Hubmine", style: subHeading1),
                  collapsed: const Divider(),
                  expanded: Text(
                      "Hubmine es una plataforma tecnológica que permite adquirir material para construcción hasta tu obra, en menos de 5 minutos y con tan solo unos pocos clicks",
                      softWrap: true,
                      style: body),
                ),
                const SizedBox(height: 10),
                ExpandablePanel(
                  header: Text("¿Qué servicios ofrecen?", style: subHeading1),
                  collapsed: const Divider(),
                  expanded: Text(
                      "Venta de Agregados, Venta de Concreto Premezclado, venta de Prefabricados según las necesidades del cliente, y Financiamiento de materiales para construcción y/o remodelación de tu vivienda.",
                      softWrap: true,
                      style: body),
                ),
                const SizedBox(height: 10),
                ExpandablePanel(
                  header: Text("¿En qué lugares tienen cobertura actualmente?",
                      style: subHeading1),
                  collapsed: const Divider(),
                  expanded: Text(
                      "Actualmente tenemos cobertura en el norte de México. \nHubmine busca establecer alianzas con las principales extractoras de agregados pétreos en cada continente, con la finalidad de hacer llegar el material para la construcción en cualquier lugar donde se requiera.",
                      softWrap: true,
                      style: body),
                ),
                const SizedBox(height: 10),
                ExpandablePanel(
                  header:
                      Text("¿Con qué unidades cuentan?", style: subHeading1),
                  collapsed: const Divider(),
                  expanded: Text(
                      "Contamos con unidades de las siguientes capacidades: \n3 ½ Toneladas, Camión de Volteo de 10, 22 y 40 Toneladas y Camión de Volteo Doble Remolque 80 Toneladas.",
                      softWrap: true,
                      style: body),
                ),
                const SizedBox(height: 10),
                ExpandablePanel(
                  header: Text(
                      "¿Porqué debería comprar en Hubmine y no por fuera?",
                      style: subHeading1),
                  collapsed: const Divider(),
                  expanded: Text(
                      "Tenemos Alianzas con las empresas extractoras de caliza de mayor prestigio, lo que nos permite suministrarle material de la mejor calidad.\n\nAl utilizar nuestra aplicación su orden es asignada de manera inmediata, y será suministrada en el menor tiempo posible o en el tiempo que usted necesite su material en obra.",
                      softWrap: true,
                      style: body),
                ),
                const SizedBox(height: 25),
                Text("¿Tiene alguna otra duda?", style: subHeading1),
                const SizedBox(height: 10),
                Text(
                    "Estamos para ayudarte a resolver tus dudas. ¡Contáctanos!",
                    style: body),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        launchURL(
                            "https://api.whatsapp.com/send?phone=+528110037915&text=Hola,%20necesito%20soporte%20sobre%20Hubmine");
                      },
                      child: Container(
                          height: size.height * 0.06,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 2,
                                color: primaryClr,
                              )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const FaIcon(FontAwesomeIcons.whatsapp,
                                  color: primaryClr),
                              Text("Chat", style: categoryBlog)
                            ],
                          )),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        launchURL("tel://8110037915");
                      },
                      child: Container(
                          height: size.height * 0.06,
                          width: 140,
                          decoration: BoxDecoration(
                            color: primaryClr,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const FaIcon(FontAwesomeIcons.phone,
                                  color: Colors.white),
                              Text("Llámanos", style: btnLight)
                            ],
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
