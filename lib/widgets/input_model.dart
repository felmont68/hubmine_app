// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/verification_code_info.dart';
import 'package:mining_solutions/screens/home/home_page.dart';

import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:provider/provider.dart';

class Input extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Icon? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;
  final bool? isRequired;
  final bool? autoFocus;

  const Input(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint,
      this.isRequired,
      this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(inputDecorationTheme:
          themeData.inputDecorationTheme.copyWith(prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return primaryClr;
        }
        if (states.contains(MaterialState.error)) {
          return accentRed;
        }
        return gray40;
      }))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isRequired != null
              ? Text("$label *", style: subtitle)
              : Text("$label", style: subtitle),
          const SizedBox(height: 4),
          TextFormField(
              autofillHints: autofillHint,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 5,
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              style: bodyBlack,
              autocorrect: false,
              autofocus: autoFocus ?? false,
              decoration: InputDecoration(
                  prefixIcon: prefixIcon != null
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 8.0),
                          child: prefixIcon,
                        )
                      : null,
                  hintText: hintText,
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
                      borderSide: const BorderSide(color: accentRed)))),
        ],
      ),
    );
  }
}

class InputDisabled extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Icon? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;
  final bool? isRequired;
  final bool? autoFocus;

  const InputDisabled(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint,
      this.isRequired,
      this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(inputDecorationTheme:
          themeData.inputDecorationTheme.copyWith(prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return primaryClr;
        }
        if (states.contains(MaterialState.error)) {
          return accentRed;
        }
        return gray40;
      }))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isRequired != null
              ? Text("$label *", style: subtitle)
              : Text("$label", style: subtitle),
          const SizedBox(height: 4),
          TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              autofillHints: autofillHint,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 5,
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              style: bodyBlack,
              autocorrect: false,
              autofocus: autoFocus ?? false,
              decoration: InputDecoration(
                  prefixIcon: prefixIcon != null
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 8.0),
                          child: prefixIcon,
                        )
                      : null,
                  hintText: hintText,
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
                      borderSide: const BorderSide(color: accentRed)))),
        ],
      ),
    );
  }
}

class InputDropdown extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Icon? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;
  final bool? isRequired;
  final bool? autoFocus;

  const InputDropdown(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint,
      this.isRequired,
      this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(inputDecorationTheme:
          themeData.inputDecorationTheme.copyWith(prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return primaryClr;
        }
        if (states.contains(MaterialState.error)) {
          return accentRed;
        }
        return gray40;
      }))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isRequired != null
              ? Text("$label *", style: subtitle)
              : Text("$label", style: subtitle),
          const SizedBox(height: 4),
          IgnorePointer(
            child: TextFormField(
                autofillHints: autofillHint,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5,
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                style: bodyBlack,
                autocorrect: false,
                autofocus: autoFocus ?? false,
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset("assets/small-arrow-down.svg",
                          width: 16, height: 16),
                    ),
                    prefixIcon: prefixIcon != null
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 8.0),
                            child: prefixIcon,
                          )
                        : null,
                    hintText: hintText,
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
                        borderSide: const BorderSide(color: accentRed)))),
          ),
        ],
      ),
    );
  }
}
//icon == null ? null : icon

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? label;
  final hintText;

  final bool? isRequired;
  const PasswordField(
      {Key? key,
      this.controller,
      this.validator,
      this.label,
      this.hintText,
      this.isRequired})
      : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  bool _password = true;

  bool focus = false;

  @override
  Widget build(BuildContext context) {
    var color = gray40;
    final ThemeData themeData = Theme.of(context);
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
      void _showPassword() {
        setState(() {
          _password = !_password;
        });
      }
    }

    return Theme(
      data: themeData.copyWith(inputDecorationTheme:
          themeData.inputDecorationTheme.copyWith(prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return primaryClr;
        }
        if (states.contains(MaterialState.error)) {
          color = accentRed;
          return accentRed;
        }

        return gray40;
      }))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.isRequired != null
              ? Text("${widget.label} *", style: subtitle)
              : Text("${widget.label}", style: subtitle),
          const SizedBox(height: 4),
          Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                // do stuff
                focus = true;
              } else {
                focus = false;
              }
            },
            child: TextFormField(
              obscureText: _obscureText,
              style: bodyBlack,
              controller: widget.controller,
              autocorrect: false,
              validator: widget.validator,
              decoration: InputDecoration(
                // Bug en Android: Icon de contraseña se va hacia un
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                  child: SvgPicture.asset("assets/lock.svg",
                      color: focus ? primaryClr : gray40),
                ),
                hintText: widget.hintText,
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
                    borderSide: const BorderSide(color: accentRed)),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _toggle();
                  },
                  child: Icon(
                    _obscureText ? Iconsax.eye4 : Iconsax.eye_slash5,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Country Field Input
class CountryField extends StatefulWidget {
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? label;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;
  final bool? isRequired;

  const CountryField(
      {Key? key,
      this.keyboardType,
      this.controller,
      this.label,
      this.validator,
      this.autofillHint,
      this.isRequired})
      : super(key: key);

  @override
  State<CountryField> createState() => _CountryFieldState();
}

class _CountryFieldState extends State<CountryField> {
  String? _selectedCountryCode;
  final List<String> _countryCodes = ['+52', '+57'];

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = _countryCodes[0];
  }

  @override
  Widget build(BuildContext context) {
    final phoneOTP = Provider.of<VerificationCodeInfo>(context, listen: false);
    phoneOTP.countryCode = _selectedCountryCode as String;

    var countryDropDown = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(width: 0.5, color: gray20),
        ),
      ),
      height: 45.0,
      margin: const EdgeInsets.only(left: 3.0, right: 5.0),
      //width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _selectedCountryCode,
            items: _countryCodes.map((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: body,
                  ));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCountryCode = value as String;
                phoneOTP.countryCode = _selectedCountryCode as String;
              });
            },
          ),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.isRequired != null
            ? Text(AppLocalizations.of(context).phoneNumberLabelRequired,
                style: subtitle)
            : Text(AppLocalizations.of(context).phoneNumberHint,
                style: subtitle),
        const SizedBox(height: 4),
        TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            autofillHints: widget.autofillHint,
            style: bodyTextStyle,
            autocorrect: false,
            decoration: InputDecoration(
                hintText: "Ej: 5554443322",
                hintStyle: bodyGray40,
                prefixIcon: countryDropDown,
                labelStyle: const TextStyle(color: Colors.black),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryClr, width: 1.0),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(10.0))),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: gray20),
                ),
                border: const OutlineInputBorder(
                    borderSide: const BorderSide(color: gray20),
                    borderRadius:
                        BorderRadius.all(const Radius.circular(10.0))))),
      ],
    );
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;

  const SearchInput({
    Key? key,
    this.color,
    this.icon,
    this.label,
    this.hintText,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      style: bodyTextStyle,
      autocorrect: false,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        suffixIcon: icon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: secondaryClr),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // width: 0.0 produces a thin "hairline" border
          borderSide: const BorderSide(color: Colors.black26),
        ),
        border: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
      ),
    );
  }
}

class SearchAddressInput extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final suffixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;

  const SearchAddressInput(
      {Key? key,
      this.color,
      this.icon,
      this.suffixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onTap: () {
          Navigator.of(context).pushNamed("address_search");
        },
        readOnly: true,
        textAlign: TextAlign.left,
        autofillHints: autofillHint,
        minLines: 1, //Normal textInputField will be displayed
        maxLines: 5,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: bodyTextStyle,
        autocorrect: false,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
            hintStyle: hintTextStyle,
            hintText: "Ingresa una dirección",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                color: (Colors.grey[200])!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: (Colors.grey[200])!),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed))));
  }
}

class InputTravelInstructions extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Icon? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;

  const InputTravelInstructions(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textAlign: TextAlign.center,
        autofillHints: autofillHint,
        minLines: 1, //Normal textInputField will be displayed
        maxLines: 5,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: bodyTextStyle,
        autocorrect: false,
        decoration: InputDecoration(
            fillColor: Colors.grey[200],
            filled: true,
            label: Center(child: Text("$label", style: inputLabelTextStyle)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(
                color: (Colors.grey[200])!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(color: secondaryClr),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: accentRed)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: accentRed))));
  }
}

class Search extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Widget? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;

  const Search(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onTap: () {
          Navigator.of(context).pushNamed("search_page");
        },
        readOnly: true,
        textAlign: TextAlign.left,
        autofillHints: autofillHint,
        minLines: 1, //Normal textInputField will be displayed
        maxLines: 5,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: bodyTextStyle,
        autocorrect: false,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintStyle: hintTextStyle,
            hintText: "Buscar en Hubmine",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                color: (Colors.grey[200])!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: (Colors.grey[200])!),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed))));
  }
}

class SearchBar extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Widget? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;

  const SearchBar(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: true,
        showCursor: true,
        textAlign: TextAlign.left,
        autofillHints: autofillHint,
        minLines: 1, //Normal textInputField will be displayed

        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: bodyTextStyle,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintTextStyle,
            prefixIcon: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Iconsax.arrow_left)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                color: (Colors.grey[200])!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: secondaryClr),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed))));
  }
}

class SearchBarCategories extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Widget? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;

  const SearchBarCategories(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: true,
        showCursor: true,
        textAlign: TextAlign.left,
        autofillHints: autofillHint,
        minLines: 1, //Normal textInputField will be displayed

        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: bodyTextStyle,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: "Buscar en Hubmine",
            hintStyle: hintTextStyle,
            prefixIcon: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const HomePage()),
                    (Route<dynamic> route) => false);
              },
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Iconsax.arrow_left)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                color: (Colors.grey[200])!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: secondaryClr),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: accentRed))));
  }
}

class InputQuantity extends StatefulWidget {
  final Color? color;
  final Icon? icon;
  final Icon? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;
  final bool? isRequired;
  final bool? autoFocus;

  const InputQuantity(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint,
      this.isRequired,
      this.autoFocus})
      : super(key: key);

  @override
  State<InputQuantity> createState() => _InputQuantityState();
}

class _InputQuantityState extends State<InputQuantity> {
  final FocusNode _nodeText = FocusNode();
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: _nodeText, toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () {
                node.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text("Listo", style: subHeading1Primary),
              ),
            );
          }
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(inputDecorationTheme:
          themeData.inputDecorationTheme.copyWith(prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return primaryClr;
        }
        if (states.contains(MaterialState.error)) {
          return accentRed;
        }
        return gray40;
      }))),
      child: KeyboardActions(
        config: _buildConfig(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            TextFormField(
                focusNode: _nodeText,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) {},
                textAlign: TextAlign.center,
                minLines: 1, //Normal textInputField will be displayed
                controller: widget.controller,
                validator: widget.validator,
                style: subHeading1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: widget.prefixIcon != null
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 8.0),
                            child: widget.prefixIcon,
                          )
                        : null,
                    hintText: widget.hintText,
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
                        borderSide: const BorderSide(color: accentRed)))),
          ],
        ),
      ),
    );
  }
}

class InputCountryDropdown extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final Widget? prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;
  final bool? isRequired;
  final bool? autoFocus;

  const InputCountryDropdown(
      {Key? key,
      this.color,
      this.icon,
      this.prefixIcon,
      this.label,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.validator,
      this.autofillHint,
      this.isRequired,
      this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(inputDecorationTheme:
          themeData.inputDecorationTheme.copyWith(prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return primaryClr;
        }
        if (states.contains(MaterialState.error)) {
          return accentRed;
        }
        return gray40;
      }))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          IgnorePointer(
            child: TextFormField(
                autofillHints: autofillHint,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5,
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                style: bodyWhite,
                autocorrect: false,
                autofocus: autoFocus ?? false,
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset("assets/small-arrow-down.svg",
                          width: 16, height: 16, color: white),
                    ),
                    prefixIcon: prefixIcon != null
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 0.0),
                            child: prefixIcon,
                          )
                        : null,
                    hintText: hintText,
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
                        borderSide: const BorderSide(color: accentRed)))),
          ),
        ],
      ),
    );
  }
}
