import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/vAlpha/services/check_user_type_services.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/input_model.dart';

import 'package:validators/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAdmin = false;

  loadMyUserType() async {
    var _isAdmin = await CheckUserTypeServices.loadUserType();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("home");
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(AppLocalizations.of(context).loginAsGuest,
                      style: subHeading2Gray),
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).loginStartSession,
                      style: heading,
                    ),
                    Text(
                      AppLocalizations.of(context).loginStartSessionSubtitle,
                      style: body,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Input(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHint: const [AutofillHints.email],
                        label: AppLocalizations.of(context).loginEmailLabel,
                        hintText:
                            AppLocalizations.of(context).loginEmailHintText,
                        prefixIcon: const Icon(Iconsax.sms5),
                        autoFocus: true,
                        validator: (value) => !isEmail(value!)
                            ? AppLocalizations.of(context).validatorEmailError
                            : null),
                    const SizedBox(
                      height: 15,
                    ),
                    PasswordField(
                        label: AppLocalizations.of(context).loginPasswordLabel,
                        hintText:
                            AppLocalizations.of(context).loginPasswordHintText,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .validatorRequiredField;
                          }
                        }),
                    const SizedBox(height: 20),
                    Container(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () async {
                            // TODO Implementar el servicio
                            Navigator.of(context)
                                .pushNamed("recovery-password");
                          },
                          child: Text(
                            AppLocalizations.of(context)
                                .loginForgotPasswordLink,
                            style: bodyLink,
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Center(
                          child: Button(
                            color: primaryClr,
                            text: Text(
                              // TODO: Verificar el tamaño de fuente para el botón
                              AppLocalizations.of(context).loginButton,
                              style: subHeading2White,
                            ),
                            width: double.infinity,
                            height: size.height * 0.07,
                            action: () async {
                              print("INICIANDO SESIÓN");
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                if (await signIn(_emailController.text,
                                    _passwordController.text, context)) {
                                } else {
                                  EasyLoading.dismiss();
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context).loginOrOption,
                            style: body),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonSide(
                          color: Colors.white,
                          width: double.infinity,
                          height: size.height * 0.07,
                          action: () {
                            Navigator.of(context).pushNamed('login_with_phone');
                          },
                          text: Text(
                              AppLocalizations.of(context).loginWithPhoneLabel,
                              style: subHeading2PrimaryClr),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context).loginOrOption,
                            style: body),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonSide(
                          action: () {
                            Navigator.pushReplacementNamed(context, "loginWithBiometrics");
                          },
                          color: Colors.white,
                          width: double.infinity,
                          height: size.height * 0.07,
                          text: Text(
                              AppLocalizations.of(context).loginWithBiometriaLabel,
                              style: subHeading2PrimaryClr),
                        ),
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
      ),
    );
  }
}
