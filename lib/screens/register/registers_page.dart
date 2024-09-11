import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/register_provider.dart';

import 'package:mining_solutions/widgets/button_model.dart';
import 'package:mining_solutions/widgets/input_model.dart';

import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerInfo = Provider.of<RegisterInfo>(context);
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
                      "Crea tu cuenta ",
                      style: body,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Input(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      autofillHint: const [AutofillHints.givenName],
                      label: "Nombre",
                      hintText: "Escribe tu nombre",
                      prefixIcon: const Icon(Iconsax.profile_circle5),
                      isRequired: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Tu nombre es requerido";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Input(
                        controller: _lastNameController,
                        keyboardType: TextInputType.text,
                        autofillHint: const [AutofillHints.familyName],
                        label: "Apellido",
                        hintText: "Escribe tu apellido",
                        prefixIcon: const Icon(Iconsax.profile_circle5),
                        isRequired: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Tu apellido es requerido";
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    Input(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: "Email",
                        hintText: "Escribe tu correo electrónico",
                        prefixIcon: const Icon(Iconsax.sms5),
                        isRequired: true,
                        autofillHint: const [AutofillHints.email],
                        validator: (value) => !isEmail(value!)
                            ? "Ingrese un email valido"
                            : null),
                    const SizedBox(height: 15),
                    PasswordField(
                        isRequired: true,
                        label: "Crea una contraseña",
                        hintText: "Crea una contraseña segura",
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)
                                .validatorRequiredField;
                          }
                        }),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        Center(
                          child: Button(
                            color: primaryClr,
                            text: Text(
                              AppLocalizations.of(context).nextButtonText,
                              style: subHeading2White,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: SvgPicture.asset(
                                  "assets/small-arrow-right.svg",
                                  color: Colors.white,
                                  width: 24,
                                  height: 24),
                            ),
                            width: double.infinity,
                            height: size.height * 0.07,
                            action: () {
                              if (_formKey.currentState!.validate()) {
                                registerInfo.name = _nameController.text;
                                registerInfo.lastName =
                                    _lastNameController.text;
                                registerInfo.phone = _phoneController.text;
                                registerInfo.email = _emailController.text;
                                registerInfo.password =
                                    _passwordController.text;
                                if (registerInfo.customerTypeID == "3") {
                                  Navigator.of(context)
                                      .pushNamed('join_like_hubber');
                                } else if (registerInfo.customerTypeID == "2") {
                                  Navigator.of(context)
                                      .pushNamed('step-two-register');
                                } else {
                                  Navigator.of(context)
                                      .pushNamed('step-two-register');
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
