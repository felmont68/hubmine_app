import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/widgets/input_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
              child: SearchBar(
                label: "¿Qué producto quieres ver?",
                prefixIcon: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 5, bottom: 5.0),
                  child: SvgPicture.asset(
                    "assets/search-normal.svg",
                    color: gray20,
                  ),
                ),
              ),
            )),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/start_search.svg"),
                const SizedBox(height: 16),
                Text("Empieza tu búsqueda", style: heading3),
                const SizedBox(height: 8),
                Text(
                    "Escribe el nombre de los productos que deseas que busquemos.",
                    textAlign: TextAlign.center,
                    style: bodyLight),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ));
  }
}
