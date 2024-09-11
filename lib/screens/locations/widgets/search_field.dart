import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/demo/helpers/mapbox_handler.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';

import '../address_search_page.dart';

class SearchBarAdressMapBox extends StatefulWidget {
  final Color? color;
  final Icon? icon;
  final prefixIcon;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final validator;
  final autofillHint;

  const SearchBarAdressMapBox(
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
  State<SearchBarAdressMapBox> createState() => _SearchBarAdressMapBoxState();
}

class _SearchBarAdressMapBoxState extends State<SearchBarAdressMapBox> {
  Timer? searchOnStoppedTyping;
  String query = '';

  _onChangeHandler(value) {
    print(value);
    // Set isLoading = true in parent
    AddressSearchPage.of(context)?.isLoading = true;

    // Make sure that requests are not made
    // until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping =
        Timer(const Duration(seconds: 1), () => _searchHandler(value)));
  }

  _searchHandler(String value) async {
    // Get response using Mapbox Search API
    List response = await getParsedResponseForQuery(value, context);

    // Set responses and isDestination in parent
    AddressSearchPage.of(context)?.responsesState = response;
    setState(() => query = value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: true,
        showCursor: true,
        textAlign: TextAlign.left,
        autofillHints: widget.autofillHint,
        minLines: 1, //Normal textInputField will be displayed
        onChanged: _onChangeHandler,
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        style: bodyTextStyle,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: widget.hintText,
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
