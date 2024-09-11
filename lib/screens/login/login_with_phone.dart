import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/verification_code_info.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import 'package:provider/provider.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  final TextEditingController _phoneController = TextEditingController();

  late String countryCode;

  loadCountryCode() async {
    var countryCodeStorage = await ServiceStorage.getCountryCode();
    
    setState(() {
      countryCode = countryCodeStorage.toString();
    });
  }

  @override
  void initState() {    
    loadCountryCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final phoneOTP = Provider.of<VerificationCodeInfo>(context);
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
                      AppLocalizations.of(context).getCodeTitle,
                      style: heading,
                    ),
                    Text(
                      AppLocalizations.of(context).getCodeSubtitle,
                      style: body,
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Text(AppLocalizations.of(context).phoneNumberLabelRequired,
                        style: subtitle),
                    SizedBox(height: 4),
                    IntlPhoneField(
                      controller: _phoneController,
                      searchText: "Buscar país",
                      dropdownIconPosition: IconPosition.trailing,
                      invalidNumberMessage: AppLocalizations.of(context)
                          .validatorPhoneNumberInvalid,
                      dropdownTextStyle: bodyBlack,
                      flagsButtonMargin: EdgeInsets.only(left: 20),
                      style: bodyBlack,
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).phoneNumberHint,
                          hintStyle: bodyGray40,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: gray20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: primaryClr),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(color: accentRed)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(color: accentRed))),
                      initialCountryCode: countryCode,
                      onChanged: (phone) {
                        print(phone.completeNumber);
                        setState(() {
                          phoneNumber = phone.completeNumber;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Column(
                      children: [
                        Center(
                          child: Button(
                            color: primaryClr,
                            text: Text(
                              AppLocalizations.of(context).loginSendCode,
                              style: subHeading2White,
                            ),
                            width: double.infinity,
                            height: size.height * 0.07,
                            action: () async {
                              phoneOTP.phone = phoneNumber as String;

                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                if (await sendOtp(phoneOTP.phone)) {
                                  Navigator.of(context)
                                      .pushNamed("enter_verification_code");
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
                          action: () {
                            Navigator.pushReplacementNamed(context, "login");
                          },
                          color: Colors.white,
                          width: double.infinity,
                          height: size.height * 0.07,
                          text: Text(
                              AppLocalizations.of(context).loginWithEmailLabel,
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
