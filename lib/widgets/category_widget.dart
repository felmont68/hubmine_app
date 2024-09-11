import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/products/products_all_page.dart';

class Category extends StatefulWidget {
  final String url;
  final String category;
  final int idCategory;
  const Category(
      {Key? key,
      required this.url,
      required this.category,
      required this.idCategory})
      : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.category == "Concreto") {
          Navigator.of(context).pushNamed("concreto-step-one");
        } else if (widget.category == "Maquinaria") {
          Navigator.of(context).pushNamed("maquinaria");
        } else {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProductsAllPage(
                    idCategory: widget.idCategory,
                    nameCategory: widget.category,
                  ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(2.7, 2.0);
                var end = Offset.zero;
                var curve = Curves.bounceIn;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              }));
        }
      },
      child: Padding(
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (widget.url.toString().isNotEmpty)                      
                      SvgPicture.network(
                        widget.url,
                        semanticsLabel: 'category icon',
                        placeholderBuilder: (BuildContext context) => 
                        Image.asset(
                          'assets/icon-hubmine.png',
                          width: 24,
                          height: 24,
                        ),
                        height: 24.0,
                        width: 24.0,
                      )
                    else
                      Image.asset(
                        'assets/icon-hubmine.png',
                        width: 24,
                        height: 24,
                      ),
                    const SizedBox(width: 8),
                    Text(widget.category, style: categoriesLabel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
