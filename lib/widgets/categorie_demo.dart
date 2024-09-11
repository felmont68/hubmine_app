import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';

class CategoryDemo extends StatefulWidget {
  final String urlSVG;
  final String category;
  final int idCategory;
  const CategoryDemo(
      {Key? key,
      required this.urlSVG,
      required this.category,
      required this.idCategory})
      : super(key: key);

  @override
  State<CategoryDemo> createState() => _CategoryDemoState();
}

class _CategoryDemoState extends State<CategoryDemo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: gray05,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SvgPicture.network(widget.urlSVG, width: 32, height: 32),
                    const SizedBox(width: 8),
                    Text(widget.category, style: categoriesLabel),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
