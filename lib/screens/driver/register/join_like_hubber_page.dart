import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/user.dart';
import 'package:mining_solutions/providers/register_provider.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/providers/verification_code_info.dart';
import 'package:mining_solutions/screens/driver/providers/register_like_hubber_provider.dart';
import 'package:mining_solutions/screens/driver/register/widgets/custom_bottom_sheet.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/utils/custom_launch.dart';
import 'package:mining_solutions/widgets/alert_dialog.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/check_ready.dart';
import 'package:mining_solutions/widgets/input_model.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'utils/number_of_trucks.dart';
import 'utils/states_of_mexico.dart';

class JoinLikeHubberPage extends StatefulWidget {
  const JoinLikeHubberPage({Key? key}) : super(key: key);

  @override
  State<JoinLikeHubberPage> createState() => _JoinLikeHubberPageState();
}

class _JoinLikeHubberPageState extends State<JoinLikeHubberPage> {
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _listMateriales = TextEditingController();
  final TextEditingController _numberOfTrucks = TextEditingController();
  String? bussinessType = "";

  String? stateSelected;
  String? materialSelected;
  String? totalOfTrucks;

  String? selectedValue;

  bool? isTermsAgree = false;
  final _formKey = GlobalKey<FormState>();

  List<String> options = [
    "Aguascalientes",
    "Constructora",
    "Casa de material",
    "Contratista general",
    "Pedrera",
    "Profesional de construcción",
    "Transportista",
    "Trituradora",
    "No soy un negocio",
    "Otro"
  ];

  bool _isLoading = false;

  signUpHubber(
      String name,
      String lastName,
      String email,
      String password,
      String phoneNumber,
      String customerTypeID,
      String hubberTypeID,
      String state,
      String totalOfTrucks,
      context) async {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    print("Tipo de usuario $customerTypeID");
    //final SharedPreferences prefs = await _prefs;
    var url = Uri.parse("http://23.100.25.47:8010/api/auth/register/");
    Map body = {
      "first_name": name,
      "last_name": lastName,
      "email": email,
      "password": password,
      "phone_number": phoneNumber,
      "business_name": "",
      "business_type": "",
      "rfc": "",
      "user_type_id": "2",
      // TODO: Actualizar con la pantalla de selección de tipo de cliente
      "customer_type_id": customerTypeID,
      "hubber_type_id": hubberTypeID,
      "state": state,
      // Si el usaurio dice que es Transportista, o Transportista y Conductor haganle la pregunta cuantos camiones tienes, si dice
      // que es chofer, no le pregunten
      "total_of_trucks": totalOfTrucks,
    };
    var jsonResponse;
    EasyLoading.show(status: "Creando cuenta...");
    var res = await http.post(url, body: body);

    jsonResponse = json.decode(res.body);
    print(jsonResponse);

    if (res.statusCode == 201) {
      EasyLoading.dismiss();
      jsonResponse = json.decode(res.body);
      print("Status code ${res.statusCode}");
      print("Response JSON ${res.body}");

      if (jsonResponse != Null) {
        setState(() {
          _isLoading = false;
        });
        ServiceStorage.saveDataUser(User.fromMap(jsonResponse));

        userInfo.password = password;
        userInfo.uid = jsonResponse['id'];
        userInfo.firstName = jsonResponse['first_name'];
        userInfo.lastName = jsonResponse['last_name'];
        userInfo.email = jsonResponse['email'];
        userInfo.phone = jsonResponse['phone_number'];
        userInfo.businessName = jsonResponse['business_name'];
        userInfo.bussinessType = jsonResponse['business_type'];
        userInfo.rfc = jsonResponse['rfc'];
        userInfo.userTypeId = jsonResponse['user_type_id'];
        userInfo.customerTypeID = jsonResponse['customer_type_id'];
        userInfo.statusAccountId = jsonResponse['status_account_id'];

        // prefs.setInt("user_id", jsonResponse['id']);
        // prefs.setString("token", jsonResponse['token']);
        // prefs.setString("email", jsonResponse['email']);

        // String urlPhoto =
        //     "http://rotary.syncronik.com/api/v1/profile-pic/${userInfo.uid}";
        // var res_photo = await http.get(urlPhoto);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const CheckReady()),
            (Route<dynamic> route) => false);
        // try {
        //   //var jsonResponsePicture = json.decode(res_photo.body);
        //   //userInfo.urlPicture = jsonResponsePicture['picture'];
        //   print("Picture User info: ${userInfo.urlPicture}");

        // } catch (e) {
        //   Navigator.of(context).pushNamed('/wait');
        // }
      }
    } else if (res.statusCode == 401) {
      setState(() {
        _isLoading = false;
      });
      print("Error");
      showAlertDialog("Ocurrió un error...", context);
    } else if (res.statusCode == 500) {
      print("Error del servidor");
      EasyLoading.showError("Ups! Ocurrió un error...",
          duration: const Duration(milliseconds: 3000));
    } else if (res.statusCode == 400) {
      setState(() {
        _isLoading = false;
      });
      print("Error");
      EasyLoading.showInfo(
          "Ya existe una cuenta asociada a tu email o número telefónico, inicia sesión",
          duration: const Duration(milliseconds: 3000));
      Navigator.of(context).pushReplacementNamed("login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final registerInfo = Provider.of<RegisterInfo>(context);
    final hubberInfo = Provider.of<RegisterHubberInfo>(context);
    final phoneOTP = Provider.of<VerificationCodeInfo>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: "¿Estás de vuelta? ",
                  style: body,
                  children: [
                    TextSpan(
                      text: "Inicia sesión",
                      style: bodyLink,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            Navigator.of(context).popAndPushNamed("login"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Container(
            height: size.height,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Regístrate",
                      style: heading,
                    ),
                    Text(
                      "Completa el siguiente formulario",
                      style: body,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
                              return CustomBottomSheet(
                                  title:
                                      "¿De que estado de México te registras?",
                                  options: statesOfMexico,
                                  onTap: (value) {
                                    _stateController.text = value;
                                    setState(() {
                                      stateSelected = value as String;
                                    });
                                    Navigator.pop(context);
                                  });
                            });
                      },
                      child: InputDropdown(
                          isRequired: true,
                          controller: _stateController,
                          label: "¿De que estado de México te registras?",
                          hintText: "Selecciona un estado"),
                    ),
                    const SizedBox(height: 15),
                    registerInfo.typeDriver == "1" ||
                            registerInfo.typeDriver == "2"
                        ? InkWell(
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
                                    return CustomBottomSheet(
                                        title:
                                            "¿Con cuantos camiones cuentas para uso en la app?",
                                        options: numberOfTrucks,
                                        onTap: (value) {
                                          _numberOfTrucks.text = value;
                                          setState(() {
                                            totalOfTrucks = value;
                                          });
                                          Navigator.pop(context);
                                        });
                                  });
                            },
                            child: InputDropdown(
                                isRequired: true,
                                controller: _numberOfTrucks,
                                label:
                                    "¿Con cuantos camiones cuentas para uso en la app?",
                                hintText: "Selecciona una opción"),
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 4,
                                    cornerSmoothing: 1,
                                  ),
                                ),
                                activeColor: primaryClr,
                                checkColor: primaryLightClr,
                                value: isTermsAgree,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isTermsAgree = value;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "* He leído y acepto los ",
                                    style: body,
                                    children: [
                                      TextSpan(
                                        text: "Términos y Condiciones de Uso ",
                                        style: bodyTermsPrimaryStyle,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => launchURL(
                                              "https://hubmine.app/tyc"),
                                      ),
                                      const TextSpan(
                                        text: "y la ",
                                      ),
                                      TextSpan(
                                        text: "Política de Privacidad ",
                                        style: bodyTermsPrimaryStyle,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => launchURL(
                                              "https://hubmine.app/privacy"),
                                      ),
                                      const TextSpan(text: "de Hubmine")
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Center(
                            child: isTermsAgree!
                                ? Button(
                                    color: primaryClr,
                                    text: Text(
                                      "Finalizar registro",
                                      style: buttonTextStyle,
                                    ),
                                    width: double.infinity,
                                    height: size.height * 0.07,
                                    action: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (registerInfo.typeDriver == "1" ||
                                            registerInfo.typeDriver == "2") {
                                          hubberInfo.state =
                                              stateSelected as String;
                                          hubberInfo.numberOfTrucks =
                                              totalOfTrucks as String;
                                          signUpHubber(
                                              registerInfo.name,
                                              registerInfo.lastName,
                                              registerInfo.email,
                                              registerInfo.password,
                                              phoneOTP.phone,
                                              registerInfo.customerTypeID,
                                              registerInfo.typeDriver,
                                              hubberInfo.state,
                                              hubberInfo.numberOfTrucks,
                                              context);
                                        } else {
                                          hubberInfo.state =
                                              stateSelected as String;
                                          signUpHubber(
                                              registerInfo.name,
                                              registerInfo.lastName,
                                              registerInfo.email,
                                              registerInfo.password,
                                              phoneOTP.phone,
                                              registerInfo.customerTypeID,
                                              registerInfo.typeDriver,
                                              hubberInfo.state,
                                              hubberInfo.numberOfTrucks,
                                              context);
                                        }
                                      }
                                    },
                                  )
                                : ButtonDisabled(
                                    color: secondaryWhiteGreen,
                                    text: Text(
                                      "Finalizar registro",
                                      style: buttonTextStyle,
                                    ),
                                    width: double.infinity,
                                    height: size.height * 0.07,
                                  )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
