import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/verification_code_info.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';

import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterVerificationCode extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const EnterVerificationCode({
    Key? key,
  });

  @override
  _EnterVerificationCodeState createState() => _EnterVerificationCodeState();
}

class _EnterVerificationCodeState extends State<EnterVerificationCode> {
  TextEditingController otpController = TextEditingController();
  bool newCodeSend = false;

  bool isCompletedSomewhere = false;

  clearTextInput() {
    otpController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final phoneOTP = Provider.of<VerificationCodeInfo>(context);

    String currentText = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
                  text:
                      AppLocalizations.of(context).loginBottomNavHaventAccount,
                  style: body,
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)
                          .loginBottomNavHaventAccountLink,
                      style: bodyLink,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context)
                            .pushReplacementNamed("select_type_account"),
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
            color: Colors.white,
            height: size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //     height: 35.0,
                  //     width: 180.0,
                  //     decoration: const BoxDecoration(
                  //         image: DecorationImage(
                  //       image: AssetImage('assets/Logo-Hubmine.png'),
                  //       fit: BoxFit.fitWidth,
                  //     ))),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Text(
                    "Inicia Sesión",
                    style: heading,
                  ),
                  Text(
                    "Bienvenido de vuelta, entra a tu cuenta",
                    style: body,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  newCodeSend
                      ? Text(
                          AppLocalizations.of(context).newCodeSentText,
                          style: subtitleLoginTextDoneStyle,
                        )
                      : SizedBox(),
                  Text(
                    "Ingresa el código de verificación",
                    style: body,
                  ),

                  RichText(
                    text: TextSpan(
                        text: AppLocalizations.of(context).weSendACodeText,
                        style: body,
                        children: [
                          TextSpan(
                            text: phoneOTP.phone,
                            style: bodyLink,
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PinCodeTextField(
                    keyboardType: TextInputType.number,
                    textStyle: const TextStyle(color: Colors.black),
                    length: 5,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      borderWidth: 0.4,
                      selectedColor: primaryClr,
                      activeColor: primaryClr,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.grey,
                      shape: PinCodeFieldShape.box,
                      selectedFillColor: Colors.white12,
                      errorBorderColor: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                      fieldHeight: 60,
                      fieldWidth: 60,
                    ),
                    animationDuration: const Duration(milliseconds: 200),
                    enableActiveFill: true,
                    controller: otpController,
                    onCompleted: (value) async {
                      clearTextInput();
                      // TODO Mandar a llamar el WebService de verifcación del código
                      if (await verificateOTP(value, phoneOTP.phone, context)) {
                      } else {
                        clearTextInput();
                      }
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Button(
                          // TODO Desabilitar botón
                          color: primaryClr,
                          text: Text(
                            AppLocalizations.of(context).verifyCodeLabel,
                            style: subHeading2White,
                          ),
                          width: double.infinity,
                          height: size.height * 0.07,
                          action: () async {
                            clearTextInput();
                            if (await verificateOTP(
                                currentText, phoneOTP.phone, context)) {}
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Text(AppLocalizations.of(context).didntGetACode),
                      const SizedBox(
                        height: 20,
                      ),
                      TimerCountDownWidget(
                          width: double.infinity,
                          height: size.height * 0.07,
                          onTimerFinish: () async {
                            var countryCode = phoneOTP.countryCode;
                            if (await sendOtp(phoneOTP.phone)) {
                              setState(() {
                                newCodeSend = true;
                                clearTextInput();
                              });
                              await Future.delayed(Duration(seconds: 10));
                              setState(() {
                                newCodeSend = false;
                              });
                            }
                          }),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
