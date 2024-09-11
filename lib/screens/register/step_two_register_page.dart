import 'dart:convert';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/user.dart';
import 'package:mining_solutions/providers/register_provider.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/providers/verification_code_info.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/utils/custom_launch.dart';
import 'package:mining_solutions/widgets/alert_dialog.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/check_ready.dart';
import 'package:mining_solutions/widgets/input_model.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'widgets/create_account_bottom_sheet.dart';

class StepTwoRegisterPage extends StatefulWidget {
  const StepTwoRegisterPage({Key? key}) : super(key: key);

  @override
  State<StepTwoRegisterPage> createState() => _StepTwoRegisterPageState();
}

class _StepTwoRegisterPageState extends State<StepTwoRegisterPage> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  String? bussinessType = "";

  String? selectedValue;

  bool? isTermsAgree = false;
  final _formKey = GlobalKey<FormState>();

  List<String> options = [
    "Concretera",
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

  signUp(
      String name,
      String lastName,
      String email,
      String password,
      String phoneNumber,
      String businessName,
      String businessType,
      String rfc,
      String customerTypeID,
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
      "business_name": businessName,
      "business_type": businessType,
      "rfc": rfc,
      "user_type_id": "2",
      "customer_type_id": customerTypeID
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
        setState(() {});
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
        userInfo.statusAccountId = jsonResponse['status_account_id'];
        userInfo.hasLoggedIn = true;
        userInfo.customerTypeID = jsonResponse['customer_type_id'];

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const CheckReady()),
            (Route<dynamic> route) => false);
      }
    } else if (res.statusCode == 401) {
      setState(() {});
      print("Error");
      showAlertDialog("Ocurrió un error...", context);
    } else if (res.statusCode == 500) {
      print("Error del servidor");
      EasyLoading.showError("Ups! Ocurrió un error...",
          duration: const Duration(milliseconds: 3000));
    } else if (res.statusCode == 400) {
      setState(() {});
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
                      "Cuéntanos sobre tu negocio y hagamos trato",
                      style: body,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Input(
                        isRequired: true,
                        controller: _businessNameController,
                        keyboardType: TextInputType.text,
                        autofillHint: const [AutofillHints.organizationName],
                        label: "¿Cómo se llama tu negocio?",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "El nombre de tu negocio es requerido";
                          }
                        }),
                    const SizedBox(height: 15),
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
                              return CreateAccountBottomSheet(onTap: (value) {
                                _businessTypeController.text = value;
                                setState(() {
                                  selectedValue = value;
                                });
                                Navigator.pop(context);
                              });
                            });
                      },
                      child: InputDropdown(
                          isRequired: true,
                          controller: _businessTypeController,
                          label: "¿Qué tipo de negocio tienes?",
                          hintText: "¿Qué tipo de negocio eres?"),
                    ),
                    const SizedBox(height: 15),
                    Input(
                        controller: _rfcController,
                        keyboardType: TextInputType.text,
                        label: "RFC (Opcional)"),
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
                                  print(value);
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
                                      AppLocalizations.of(context)
                                          .finishedButtonText,
                                      style: subHeading2White,
                                    ),
                                    width: double.infinity,
                                    height: size.height * 0.07,
                                    action: () {
                                      if (_formKey.currentState!.validate()) {
                                        registerInfo.businessName =
                                            _businessNameController.text;
                                        registerInfo.businessType =
                                            selectedValue as String;
                                        registerInfo.rfc = _rfcController.text;
                                        signUp(
                                            registerInfo.name,
                                            registerInfo.lastName,
                                            registerInfo.email,
                                            registerInfo.password,
                                            phoneOTP.phone,
                                            registerInfo.businessName,
                                            registerInfo.businessType,
                                            registerInfo.rfc,
                                            registerInfo.customerTypeID,
                                            context);
                                      }
                                    },
                                  )
                                : ButtonDisabled(
                                    color: secondaryWhiteGreen,
                                    text: Text(
                                      AppLocalizations.of(context)
                                          .finishedButtonText,
                                      style: subHeading2White,
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
