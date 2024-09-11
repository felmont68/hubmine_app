import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/utils/custom_launch.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestProfilePage extends StatefulWidget {
  final VoidCallback? reloadState;
  const GuestProfilePage({Key? key, this.reloadState}) : super(key: key);

  @override
  GuestProfilePageState createState() => GuestProfilePageState();
}

class GuestProfilePageState extends State<GuestProfilePage> {
  final List settingsList = [
    {
      "title": "Centro de ayuda",
      "icon": SvgPicture.asset("assets/headphone.svg", color: primaryClr),
      "route": "help"
    },
    {
      "title": "Sobre Hubmine",
      "icon": SvgPicture.asset("assets/hubmine.svg"),
      "route": "about"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Mi perfil", style: subHeading1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          color: Colors.white,
          // height: size.height + 30,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Container(
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.darken),
                      image: const AssetImage("assets/camion-revolvedor.jpeg"),
                      fit: BoxFit.fitWidth,
                    ),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 16,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Disfruta de todo lo que',
                            style: guestProfileCardTitle,
                            children: <InlineSpan>[
                              TextSpan(
                                  text: ' Hubmine ',
                                  style: guestProfileCardTitlePrimary),
                              TextSpan(
                                  text: 'tiene para ti',
                                  style: guestProfileCardTitle),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Inicia sesión para empezar a comprar',
                            style: carrouselSubHeading),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("login");
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                color: primaryClr,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text('Iniciar sesión',
                                  style: subHeading2White),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Column(children: const []),
              Column(
                children: renderSettings(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Versión 2.0.6", style: bodyGray60),
              const SizedBox(
                height: 10,
              ),
              Text("Hubmine SAPI de CV ® 2022 All Rights Reserved",
                  style: bodyGray60),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> renderSettings() {
    List<Widget> settings = [];

    for (var element in settingsList) {
      Map currentSettings = element;
      String title = currentSettings["title"];
      Widget icon = currentSettings["icon"];
      String route = currentSettings["route"];
      settings.add(SettingComponent(icon, title, route));
    }

    return settings;
  }
}

class SettingComponent extends StatelessWidget {
  final Widget icon;
  final String title;
  final String route;
  const SettingComponent(this.icon, this.title, this.route, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route == "about") {
          launchURL("https://hubmine.app");
        } else {
          Navigator.of(context).pushNamed(route);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            side: const BorderSide(width: 1.0, color: gray20),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 16,
              cornerSmoothing: 1,
            ),
          ),
        ),
        child: ListTile(
          leading:
              Padding(padding: const EdgeInsets.only(left: 16), child: icon),
          title: Text(title, style: subHeading2),
          trailing: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
