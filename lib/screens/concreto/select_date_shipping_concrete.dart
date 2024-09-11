import 'dart:convert';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/concreto_provider.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/concreto/resumen_cotizacion.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class SelectDateShippingConcretePage extends StatefulWidget {
  const SelectDateShippingConcretePage({Key? key}) : super(key: key);

  @override
  State<SelectDateShippingConcretePage> createState() =>
      _SelectDateShippingConcretePageState();
}

class _SelectDateShippingConcretePageState
    extends State<SelectDateShippingConcretePage> {
  List dates = [];
  DateTime _selectedValue = DateTime.now().add(const Duration(days: 1));

  DateTime? _dateSelected;

  int? dateTaped;

  loadDatesAvailable(date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    var _url = Uri.parse(
        "http://23.100.25.47:8010/api/concrete/hour-available?date=$formatted");
    var _res = await http.get(_url);
    if (_res.statusCode == 200) {
      var _jsonResponse = json.decode(_res.body);
      setState(() {
        dates.clear();
        dates = _jsonResponse;
      });
    } else if (_res.statusCode == 401) {
    } else if (_res.statusCode == 500) {}
  }

  formatTime(value) {
    DateTime time = DateFormat('HH:mm').parse(value);
    String formatTime = DateFormat('HH:mm').format(time);
    return formatTime;
  }

  @override
  void initState() {
    super.initState();
    loadDatesAvailable(_selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    final concretoProvider = Provider.of<ConcretoInfo>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 100,
          // margin: const EdgeInsets.only(bottom: 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                    // TODO: Lógica de pago
                    onPressed: () {
                      if (dateTaped != null) {
                        //Navigator.of(context).popAndPushNamed("checkout");
                        //Navigator.of(context).pushNamed("select-date-shipping");
                        userInfo.timeShipping = dates[dateTaped!]['start_hour'];
                        userInfo.hourDeliveryID =
                            dates[dateTaped!]['id'].toString();
                        concretoProvider.hourDeliveryID =
                            dates[dateTaped!]['id'].toString();
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String formatted =
                            formatter.format(_selectedValue);
                        concretoProvider.dateDelivery = formatted;
                        userInfo.dateShipping = _selectedValue;
                        print(userInfo.hourDeliveryID);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const ResumenCotizacionPage()),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                                dateTaped != null
                                    ? "Continuar"
                                    : 'Selecciona una fecha y hora',
                                style: subHeading2White),
                          ],
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      elevation: 0,
                      backgroundColor: dateTaped != null ? primaryClr : gray60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 16,
                          cornerSmoothing: 1,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text("Programa tu envío", style: subHeading1),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DatePicker(
                DateTime.now().add(const Duration(days: 1)),
                initialSelectedDate: _selectedValue,
                deactivatedColor: gray05,
                selectionColor: primaryClr,
                selectedTextColor: Colors.white,
                daysCount: 7,
                locale: 'es_MX',
                onDateChange: (date) {
                  // New date selected
                  setState(() {
                    _selectedValue = date;
                  });
                  loadDatesAvailable(date);
                },
              ),
            ),
            const SizedBox(height: 24),
            dates.length > 1
                ? Text("Selecciona uno de los horarios disponibles",
                    style: subHeading1)
                : Container(),
            const SizedBox(height: 12),
            dates.length > 1
                ? Expanded(
                    child: GridView.count(
                      childAspectRatio: 2.5,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(dates.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              dateTaped = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(12.0),
                            decoration: ShapeDecoration(
                              color: dateTaped == index
                                  ? primaryClr
                                  : Colors.white,
                              shape: SmoothRectangleBorder(
                                side: dateTaped == index
                                    ? const BorderSide(
                                        width: 1.0, color: primaryClr)
                                    : const BorderSide(
                                        width: 1.0, color: gray20),
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 12,
                                  cornerSmoothing: 1,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${formatTime(dates[index]['start_hour'])} - ${formatTime(dates[index]['end_hour'])}",
                                style: dateTaped == index
                                    ? subHeading2White
                                    : subHeading2,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/no_search.svg"),
                        const SizedBox(height: 16),
                        Text("No hay horarios disponibles para este día",
                            style: heading3),
                        const SizedBox(height: 8),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
          ],
        ));
  }
}
