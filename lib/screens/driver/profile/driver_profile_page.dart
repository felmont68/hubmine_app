import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/intro/intro_screen.dart';
import 'package:mining_solutions/screens/profile/edit_profile_page.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/utils/custom_launch.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverProfilePage extends StatefulWidget {
  final VoidCallback? reloadState;
  const DriverProfilePage({Key? key, this.reloadState}) : super(key: key);

  @override
  DriverProfilePageState createState() => DriverProfilePageState();
}

class DriverProfilePageState extends State<DriverProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: size.width,
            height: height * 0.25,
            child: Padding(
              padding: const EdgeInsets.only(left: 28.0, right: 12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(children: [
                      Flexible(
                        child: SizedBox(
                          width: width,
                          height: height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Mi perfil", style: h2TextStyle),
                            ],
                          ),
                        ),
                      )
                    ]),
                    Row(children: [
                      Flexible(
                        child: SizedBox(
                          width: width,
                          height: height * 0.15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 45,
                                      backgroundImage: userInfo
                                                      .profilePhotoPath ==
                                                  "" ||
                                              userInfo.profilePhotoPath == null
                                          ? const NetworkImage(
                                              "https://syncronik.s3.us-east-2.amazonaws.com/Hubmine/user-by-default.png")
                                          : NetworkImage(
                                              'http://23.100.25.47:8010/media/' +
                                                  userInfo.profilePhotoPath,
                                            ),
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${userInfo.firstName.split(' ').first} ${userInfo.lastName.split(' ').first}",
                                            style: h2TextStyle,
                                          ),
                                          Text("${userInfo.businessName}",
                                              style: h3TextDarkStyle),
                                        ]),
                                    Column(
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.grey),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          EditProfilePage(
                                                    name: userInfo.firstName,
                                                    lastName: userInfo.lastName,
                                                    phone: userInfo.phone,
                                                    email: userInfo.email,
                                                    company:
                                                        userInfo.businessName,
                                                    rfc: userInfo.rfc,
                                                  ),
                                                ),
                                              )
                                                  .then((_) {
                                                print("Recargando estado");
                                                if (widget.reloadState !=
                                                    null) {
                                                  widget.reloadState!();
                                                } else {}
                                                setState(() {});
                                              });
                                            })
                                      ],
                                    )
                                  ]),
                            ],
                          ),
                        ),
                      )
                    ])
                  ]),
            ),
          ),
          Container(
            color: Colors.white,
            width: width,
            height: height * 0.75,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  buildOptionMenu(accentRed, Icons.notifications,
                      "Notificaciones", "notifications"),
                  const SizedBox(height: 10),
                  buildOptionMenu(
                      primaryClr, Icons.people, "Mis Referidos", "referals"),
                  const Divider(),
                  buildOptionMenu(Colors.black, Icons.settings, "Configuración",
                      "settings"),
                  const SizedBox(height: 10),
                  buildOptionMenu(Colors.yellow[700], Icons.headphones,
                      "Soporte           ", "help"),
                  const SizedBox(height: 10),
                  buildOptionMenuURL(Colors.blue, Icons.info,
                      "About us         ", "https://hubmine.app"),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 31.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mi cuenta",
                              style: GoogleFonts.inter(
                                  color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              print("Cerrando sesión");
                              if (await logout(context)) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const IntroScreen()),
                                    (Route<dynamic> route) => false);
                              }
                            },
                            child: Text("Cerrar Sesión",
                                style: GoogleFonts.inter(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),

                          // const SizedBox(height: 15),
                          // GestureDetector(
                          //   onTap: () async {
                          //     print("Eliminar cuenta");
                          //     Navigator.of(context)
                          //         .pushNamed("delete_account");
                          //     // TODO: Integrar popup y servicio para eliminar cuenta
                          //   },
                          //   child: Text("Solicitar eliminar cuenta",
                          //       style: GoogleFonts.inter(
                          //           color: accentRed,
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.w600)),
                          // )
                        ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildOptionMenu(
      Color? color, IconData icon, String cta, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const SizedBox(),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: color),
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white),
        ),
        Text(cta, style: h3TextStyle),
        const SizedBox(width: 80),
        IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(route);
            })
      ]),
    );
  }

  GestureDetector buildOptionMenuURL(
      Color? color, IconData icon, String cta, String url) {
    return GestureDetector(
      onTap: () {
        launchURL(url);
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const SizedBox(),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: color),
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white),
        ),
        Text(cta, style: h3TextStyle),
        const SizedBox(width: 80),
        IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {
              launchURL(url);
            })
      ]),
    );
  }
}
