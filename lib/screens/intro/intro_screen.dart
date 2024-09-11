import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/driver/register/widgets/custom_bottom_sheet.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/utils/data/countryOptions.dart';
import 'package:mining_solutions/widgets/button_model.dart';

import 'package:mining_solutions/widgets/input_model.dart';
import '../../services/location_services.dart';

import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    ServiceLocation.getCurrentLocation(context);
    super.initState();
  }

  int selectedIndex = 0;
  List<Widget> pages = [
    const IntroImage(
        height: 300,
        asset: 'assets/Onboard-Intro.png',
        text: 'Compra sin estrés',
        subtext: 'Materiales para tu construcción.'),
    const IntroImage(
        asset: 'assets/Onboard-truck.png',
        height: 300,
        text: 'Recibe tu pedido',
        subtext: 'En el día y hora que decidas.'),
    const IntroImage(
        asset: 'assets/Onboard-Best-price.png',
        height: 300,
        text: 'Obtén el mejor precio',
        subtext: 'Y recibe promociones exclusivas.'),
    const SelectLocationPage(
      asset: 'assets/Onboard-country-select.png',
      height: 300,
      text: '¿Dónde te encuentras?',
    ),
  ];
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageView.builder(
          physics: const BouncingScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              selectedIndex = page;
              // badge = badge + 1;
            });
          },
          controller: controller,
          itemBuilder: (context, position) {
            return Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  Container(child: pages[position]),
                ]);
          },
          itemCount: pages.length,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 42),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            selectedIndex == pages.length - 1
                ? Container()
                : Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.zero,
                    child: OutlinedButton(
                        onPressed: selectedIndex != 0
                            ? () {
                                controller.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                              }
                            : null,
                        child: Icon(Iconsax.arrow_left,
                            color: selectedIndex != 0
                                ? white
                                : Colors.transparent),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: selectedIndex != 0
                                  ? primaryClr
                                  : Colors.transparent,
                            ))),
                  ),
            selectedIndex == pages.length - 1
                ? Row()
                : Row(
                    children: [
                      Text("Siguiente", style: subHeading1White),
                      const SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.zero,
                        child: ElevatedButton(
                            onPressed: () {
                              controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
                            child:
                                const Icon(Iconsax.arrow_right_1, color: white),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            )),
                      ),
                    ],
                  )
          ]),
        ));
  }
}

class IntroImage extends StatelessWidget {
  final String text;
  final double height;
  final String asset;
  final String subtext;

  const IntroImage({
    required this.text,
    required this.height,
    required this.asset,
    required this.subtext,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(asset.toString()),
        fit: BoxFit.fill,
      )),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 1),
              Image.asset("hubmine-icon-name.png",
                  width: MediaQuery.of(context).size.width / 2.5),
              const SizedBox(height: 12),
              Text(
                text,
                style: onboardingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtext,
                style: onboardingSubtitle,
                textAlign: TextAlign.center,
              ),
            ]),
      ),
    );
  }
}

class SelectLocationPage extends StatefulWidget {
  final String text;
  final double height;
  final String asset;

  const SelectLocationPage({
    required this.text,
    required this.height,
    required this.asset,
    Key? key,
  }) : super(key: key);

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final TextEditingController _countryController = TextEditingController();
  String _countrySelected = "";
  String _flag = "";

  loadFields() {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    _countryController.text = userInfo.countryName;
    _flag = userInfo.countryFlag;
  }

  @override
  void initState() {
    super.initState();
    loadFields();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(widget.asset.toString()),
        fit: BoxFit.fill,
      )),
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: widget.height * 1),
              Image.asset("hubmine-icon-name.png",
                  width: MediaQuery.of(context).size.width / 2.5),
              const SizedBox(height: 12),
              Text(
                widget.text,
                style: onboardingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.vertical(
                          top: SmoothRadius(
                              cornerRadius: 20, cornerSmoothing: 1),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return BottomSheetCountry(
                            title: "Selecciona tu país",
                            options: countryOptions,
                            onTap: (value, flag, codeLanguage) {
                              ServiceStorage.saveCountryCode(codeLanguage);
                              setState(() {
                                userInfo.countryFlag = flag as String;
                                _countryController.text = value;
                                _countrySelected = value as String;
                                userInfo.countryName = _countrySelected;
                                _flag = flag;
                                _countryController.text = userInfo.countryName;
                              });
                              Navigator.pop(context);
                            });
                      });
                },
                child: InputCountryDropdown(
                    prefixIcon: userInfo.countryFlag != ""
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.asset(_flag,
                                alignment: Alignment.centerLeft,
                                width: 32,
                                height: 32),
                          )
                        : const Icon(Iconsax.location5),
                    isRequired: true,
                    controller: _countryController,
                    label: "¿Qué tipo de camiones pueden entrar a tu obra?",
                    hintText: "Selecciona tu país"),
              ),
              userInfo.countryFlag != ""
                  ? Column(
                      children: [
                        const SizedBox(height: 36),
                        Button(
                          action: () {
                            Navigator.of(context).pushNamed("login_with_phone");
                          },
                          color: primaryClr,
                          height: 56,
                          text: Text("Iniciar sesión", style: subHeading2White),
                        ),
                        const SizedBox(height: 12),
                        Text("O si no tienes cuenta", style: smallBodyWhite),
                        const SizedBox(height: 12),
                        ButtonTransparent(
                          action: () {
                            Navigator.of(context)
                                .pushNamed('select_type_account');
                          },
                          color: Colors.transparent,
                          height: 56,
                          text: Text("Regístrate en la app",
                              style: subHeading2PrimaryClr),
                        ),
                      ],
                    )
                  : Container()
            ]),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  final String text;
  final double height;
  final String asset;

  const StartPage({
    required this.text,
    required this.height,
    required this.asset,
    Key? key,
  }) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final TextEditingController _countryController = TextEditingController();
  String _countrySelected = "";
  String _flag = "";

  loadFields() {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    _countryController.text = userInfo.countryName;
    _flag = userInfo.countryFlag;
  }

  @override
  void initState() {
    super.initState();
    loadFields();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(widget.asset.toString()),
        fit: BoxFit.fill,
      )),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: widget.height * 1),
              Image.asset("hubmine-icon-name.png",
                  width: MediaQuery.of(context).size.width / 2.5),
              const SizedBox(height: 12),
              Text(
                widget.text,
                style: onboardingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.vertical(
                          top: SmoothRadius(
                              cornerRadius: 20, cornerSmoothing: 1),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return BottomSheetCountry(
                            title: "Selecciona tu país",
                            options: countryOptions,
                            onTap: (value, flag) {
                              setState(() {
                                _countryController.text = value;
                                _countrySelected = value as String;
                                userInfo.countryName = _countrySelected;
                                _flag = flag as String;
                                userInfo.countryFlag = flag;
                                _countryController.text = userInfo.countryName;
                              });
                              Navigator.pop(context);
                            });
                      });
                },
                child: InputCountryDropdown(
                    prefixIcon: userInfo.countryFlag != ""
                        ? Image.asset(_flag, alignment: Alignment.centerLeft)
                        : const Icon(Iconsax.location5),
                    isRequired: true,
                    controller: _countryController,
                    label: "¿Qué tipo de camiones pueden entrar a tu obra?",
                    hintText: "Selecciona tu país"),
              ),
            ]),
      ),
    );
  }
}
