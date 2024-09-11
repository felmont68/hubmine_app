import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/utils/fetch_json.dart';
import 'package:mining_solutions/widgets/cart_topbar.dart';
import 'package:skeletons/skeletons.dart';

class ConcretoStep extends StatefulWidget {
  final String title;
  final String apiUrl;
  final ConcreteTileType tileType;
  final String nextRoute;
  final Map Function(dynamic) addImage;
  final Map Function(dynamic) transformJson;

  const ConcretoStep(
      {required this.title,
      Key? key,
      required this.apiUrl,
      required this.tileType,
      required this.nextRoute,
      required this.addImage,
      required this.transformJson})
      : super(key: key);

  @override
  State<ConcretoStep> createState() => _ConcretoStepState();
}

class _ConcretoStepState extends State<ConcretoStep> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;

    final parsedArg = arg.toString().isNotEmpty ? arg.toString() : "";

    final String finalUrl;
    if (parsedArg.isNotEmpty && arg != null) {
      finalUrl = widget.apiUrl + parsedArg;
    } else {
      finalUrl = widget.apiUrl;
    }

    Future fetchData = fetchJson(finalUrl, transformingFunctions: [
      widget.transformJson,
      widget.addImage,
    ]);

    return Scaffold(
      appBar: CartTopbar(title: widget.title),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SkeletonListView();
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map item = snapshot.data[index];

                return ConcreteTile(
                    item: ConcreteStepItem.fromJson(item),
                    type: widget.tileType,
                    nextRoute: widget.nextRoute);
              },
            );
          },
          future: fetchData),
    );
  }
}

class ConcreteTile extends StatelessWidget {
  const ConcreteTile(
      {Key? key,
      required this.item,
      required this.nextRoute,
      required this.type})
      : super(key: key);

  final ConcreteStepItem item;
  final String nextRoute;
  final ConcreteTileType type;
  // late String arg;

  @override
  Widget build(BuildContext context) {
    if (type == ConcreteTileType.card) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, nextRoute, arguments: item.id);
        },
        child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: gray20),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: cardTitle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(item.subtitle, style: body),
                ),
                Text("Falta definir precio en modelo", style: bodyLink),
              ],
            )),
      );
    } else {
      return ListTile(
        dense: false,
        leading:
            (item.image).isNotEmpty ? Image.asset(item.image) : Container(),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            item.title,
            style: cardTitle,
          ),
        ),
        minLeadingWidth: 60,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        subtitle: Text(item.description, style: body),
        trailing: const Icon(Icons.chevron_right, color: primaryClr),
        onTap: () {
          Navigator.pushNamed(context, nextRoute, arguments: item.id);
        },
      );
    }
  }
}

class ConcreteStepItem {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String description;

  ConcreteStepItem(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.image,
      required this.description,
      Key? key});

  factory ConcreteStepItem.fromJson(Map<dynamic, dynamic> json) {
    return ConcreteStepItem(
        id: json["id"].toString(),
        title: json["title"],
        subtitle: json["subtitle"] ?? "",
        image: json["image"] ?? "",
        description: json["description"]);
  }
}

enum ConcreteTileType { card, tile }
