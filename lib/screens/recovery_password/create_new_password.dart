import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/login/login_page.dart';
import 'package:mining_solutions/screens/vAlpha/services/check_user_type_services.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/input_model.dart';

class CreateNewPassword extends StatefulWidget {
  final String token;
  const CreateNewPassword({Key? key, required this.token}) : super(key: key);

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
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
    // print(widget.token);
  }

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
              child: Form(
                key: _formKey,
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
                      "Crear nueva contraseña",
                      style: heading,
                    ),
                    Text(
                      "Crea una nueva contraseña para acceder a tu cuenta",
                      style: body,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PasswordField(
                        label: "Nueva contraseña",
                        isRequired: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .validatorRequiredField;
                          }
                        }),
                    const SizedBox(height: 20),
                    PasswordField(
                        label: "Confirmar contraseña",
                        isRequired: true,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .validatorRequiredField;
                          } else if (value != _passwordController.text) {
                            return "Las contraseñas no coinciden";
                          }
                        }),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Center(
                          child: Button(
                            color: primaryClr,
                            text: Text(
                              "Actualizar contraseña",
                              style: subHeading2White,
                            ),
                            width: double.infinity,
                            height: size.height * 0.07,
                            action: () async {
                              // print("Guardar nueva contraseña");
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                if (await saveNewPassword(
                                    _confirmPasswordController.text,
                                    widget.token,
                                    context)) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginPage()),
                                      (Route<dynamic> route) => false);
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
