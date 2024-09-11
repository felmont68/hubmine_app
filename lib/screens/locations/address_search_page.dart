import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/demo/widgets/search_listview.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/locations/current_location_page.dart';
import 'package:mining_solutions/screens/locations/widgets/search_field.dart';

class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({Key? key}) : super(key: key);

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();

  static _AddressSearchPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AddressSearchPageState>();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  bool isLoading = false;

  bool isEmptyResponse = true;

  bool hasResponded = false;

  bool isResponseForDestination = false;

  String noRequest = 'Ingresa una ubicación';

  String noResponse = 'No hay resultados para esta búsqueda';

  List responses = [];

  TextEditingController sourceController = TextEditingController();

  TextEditingController destinationController = TextEditingController();

  // Define setters to be used by children widgets
  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 400),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(
                left: 7.0, top: 12.0, right: 7.0, bottom: 12.0),
            child: SearchBarAdressMapBox(
              hintText: "Escribe tu dirección de entrega",
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5.0),
                child: SvgPicture.asset(
                  "assets/search-normal.svg",
                  color: gray20,
                ),
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? const LinearProgressIndicator(
                    color: primaryClr,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : Container(),
            isEmptyResponse
                ? Center(
                    child: Text(hasResponded ? noResponse : "", style: body))
                : Container(),
            searchListView(responses, isResponseForDestination,
                destinationController, sourceController),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    // TODO: Revisar rutas
                    return const CurrentLocationPage(
                      navigationOptions: {
                        "nextRoute": "home",
                        "removeUntil": true
                      },
                    );
                  }),
                );
              },
              child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 5),
                    child: Icon(Iconsax.location5, color: primaryClr),
                  ),
                  title: Text("Seleccionar ubicación en el mapa",
                      style: subHeading1),
                  subtitle: Text("Marca tu dirección en el mapa", style: body)),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
