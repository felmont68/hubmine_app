import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:open_settings/open_settings.dart';

FlutterSecureStorage _storage = const FlutterSecureStorage();

class LoginWithBiometricsPage extends StatefulWidget {
  static const routeName = "loginWithBiometrics";
  const LoginWithBiometricsPage({Key? key}) : super(key: key);

  @override
  State<LoginWithBiometricsPage> createState() =>
      _LoginWithBiometricsPageState();
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _LoginWithBiometricsPageState extends State<LoginWithBiometricsPage> {
  String? firstName;
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;
  String? token;
  bool hasToken = false;
  Widget? page;

  bool tokenValidated = false;

  validateToken() async {
    var token = await _storage.read(key: 'tokenhuella');
    print('Token leído: $token');
    if (token == null) {
      EasyLoading.showError(
          "Error. Datos no Validos. Inicie sesion Con el correo y contraseña registrados y guarde su huella",
          duration: const Duration(milliseconds: 4000));
      Navigator.pop(context);
    } else {
      if (await loginWithToken(token, context)) {
        setState(() {
          tokenValidated = true;
        });
        return true;
      }
    }
  }

  @override
  void initState() {
    auth.isDeviceSupported().then((bool isSupported) => setState(() =>
        supportState =
            isSupported ? SupportState.supported : SupportState.unSupported));
    super.initState();
    loadUserData();
    checkBiometric();
    getAvailableBiometrics();
  }

  Future<void> loadUserData() async {
    var fName = await getFirstName();
    print(fName);
    setState(() {
      firstName = fName;
    });
  }

  Future<void> checkBiometric() async {
    late bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      print("Biometric supported: $canCheckBiometric");
    } on PlatformException catch (e) {
      print(e);
      canCheckBiometric = false;
    }
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> biometricTypes;
    try {
      biometricTypes = await auth.getAvailableBiometrics();
      print("supported biometrics $biometricTypes");
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      availableBiometrics = biometricTypes;
    });
  }

  Future<bool> hasBiometrics() async {
    final isAvailable = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final authenticated = await auth.authenticate(
          localizedReason: 'Autentifiquese con su Biometria', stickyAuth: true);
      if (!mounted) {
        return;
      }

      if (authenticated) {
        var token = await _storage.read(key: 'tokenhuella');
        print('Token leído: $token');

        if (token == null) {
          EasyLoading.showError(
              "Error. Datos no Validos. Inicie sesion Con el correo y contraseña registrados y guarde su Biometria",
              duration: const Duration(milliseconds: 4000));
          Navigator.pop(context);
        } else {
          var result = await validateTokens(token);
          if (result == true) {
            run();
          } else {
            Navigator.pop(context);
          }
        }
      } else {
        // Mostrar mensaje de error si la autenticación falla
        EasyLoading.showError("Autenticación fallida.",
            duration: const Duration(milliseconds: 4000));
      }
    } on PlatformException catch (e) {
      print(e);
      // Mostrar mensaje de error
      EasyLoading.showError(
        "Aún no se ha registrado su biometría. Por favor, Ingrese y haga el registro.",
        duration: const Duration(milliseconds: 4000),
      );
      Navigator.pop(context);
      return;
    }
  }

  run() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
        (Route<dynamic> route) => false);
  }

  Future<bool> validateTokens(var tokens) async {
    if (tokens != null) {
      return await loginWithToken(tokens, context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: firstName != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*SvgPicture.asset(
                            color: goldRotary,
                            width: 36,
                            "assets/icons/rotary_international_icon.svg"),*/
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Hubmine",
                          style: subHeading2PrimaryClr,
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
        ),
        extendBody: true,
        backgroundColor: const Color(0XFF1A47BA),
        bottomNavigationBar: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: firstName != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, bottom: 24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ButtonSide(
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.face,
                            color: primaryClr,
                          ),
                        ),
                        color: Colors.white,
                        action: authenticateWithBiometrics,
                        height: MediaQuery.of(context).size.height * 0.067,
                        text: Text(
                          "Ingresar con Biometria",
                          style: subHeading2PrimaryClr,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ButtonSide(
                        color: Colors.transparent,
                        action: () {
                          Navigator.of(context).pushNamed("login_with_email");
                        },
                        height: MediaQuery.of(context).size.height * 0.067,
                        text: const Text(
                          "Ingresar con contraseña",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ]),
                  )
                : const SizedBox.shrink()),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitHeight,
                    image: AssetImage("assets/Onboard-Intro.png"))),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.1),
                    Colors.black45.withOpacity(0.1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonSide(
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.face,
                            color: primaryClr,
                          ),
                        ),
                        color: Colors.white,
                        action: authenticateWithBiometrics,
                        height: MediaQuery.of(context).size.height * 0.067,
                        text: Text(
                          "Ingresar con Biometria",
                          style: subHeading2PrimaryClr,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: firstName != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*SvgPicture.asset(
                                      color: goldRotary,
                                      width: 52,
                                      "assets/icons/rotary_international_icon.svg"),*/
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Bienvenido de vuelta ${firstName} 👋",
                                    key: ValueKey<String>(firstName!),
                                    //style: h2StyleWhite,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Por tu seguridad cerramos la sesión después de 5 minutos de inactividad.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }
}

class ButtonSide extends StatelessWidget {
  final Color? color;
  final Text? text;
  final double? width;
  final double? height;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  final icon;
  final side;
  const ButtonSide(
      {Key? key,
      this.color,
      this.text,
      this.width,
      this.height,
      this.action,
      this.icon,
      this.side})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialButton(
        elevation: 0,
        onPressed: () {
          action();
        },
        color: color,
        shape: SmoothRectangleBorder(
          side: const BorderSide(color: Color(0XFF1A47BA)),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 8,
            cornerSmoothing: 1,
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon ?? Container(),
              text as Widget,
            ],
          ),
        ),
      ),
    );
  }
}
