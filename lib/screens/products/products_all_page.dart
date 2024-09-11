import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/services/categories_services.dart';
import 'package:mining_solutions/widgets/category_widget.dart';
import 'package:mining_solutions/widgets/product_preview.dart';
import 'package:skeletons/skeletons.dart';

class ProductsAllPage extends StatefulWidget {
  final int idCategory;
  final String nameCategory;
  const ProductsAllPage(
      {Key? key, required this.idCategory, required this.nameCategory})
      : super(key: key);

  @override
  State<ProductsAllPage> createState() => _ProductsAllPageState();
}

class _ProductsAllPageState extends State<ProductsAllPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("${widget.nameCategory} para ti", style: subHeading1),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage()),
                (Route<dynamic> route) => false);
          },
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: FutureBuilder(
                        future: fetchCategories(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SkeletonItem(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        height: 40,
                                        width: 90,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                SkeletonItem(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        height: 40,
                                        width: 90,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                SkeletonItem(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        height: 40,
                                        width: 79,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                SkeletonItem(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        height: 40,
                                        width: 75,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasData) {
                            return SizedBox(
                              height: 48,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map category = snapshot.data![index];
                                    // print(category);
                                    return Category(
                                      category: category['category_name'],
                                      idCategory: category['id'],
                                      url: category['url_png'],
                                    );
                                  }),
                            );
                          } else {
                            return const Center(child: Text("No hay datos"));
                          }
                        }),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    FutureBuilder(
                        future: fetchProductsByCategory(
                            widget.nameCategory.toLowerCase()),                            
                        builder: (BuildContext context,
                            AsyncSnapshot<List> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SkeletonItem(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SkeletonItem(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SkeletonItem(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.data!.isNotEmpty) {
                            return ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const ClampingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map productByCategory = snapshot.data![index];
                                print(productByCategory);
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 7.0, bottom: 7.0),
                                  child: ProductPreview(
                                      productID:
                                          productByCategory['pk'].toString(),
                                      productName:
                                          productByCategory['product_name'],
                                      category: productByCategory['category'].toString(),
                                      /*category: productByCategory['category']
                                          ['category_name'],*/
                                      shortDescription: productByCategory[
                                          'short_description'],
                                      description:
                                          productByCategory['description'],
                                      image: productByCategory['image'].toString(),
                                      disccount: productByCategory['disscount']
                                          .toString(),
                                      initialPrice: r"Desde $" +
                                      productByCategory['price'].toString(),
                                          /*productByCategory['price']['total']
                                              .toString() +
                                          " " +
                                          productByCategory['price']['badge'] +
                                          "/" +
                                          productByCategory['unity']['unity'],*/
                                      /*measures: productByCategory[
                                          'technical_features']['measures'],*/
                                      /*volumetricWeight: productByCategory[
                                                  'technical_features']
                                              ['volumetric_weight']
                                          .toString()*/),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Divider(color: gray20),
                                );
                              },
                            );
                          } else {
                            return Column(
                              children: [
                                Container(
                                  height: size.height / 1.5,
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/start_search.svg"),
                                        const SizedBox(height: 16),
                                        Text("Sin stock", style: heading3),
                                        const SizedBox(height: 8),
                                        Text(
                                            "No hay productos de esa categoria disponibles en este momento",
                                            textAlign: TextAlign.center,
                                            style: bodyLight),
                                        const SizedBox(height: 70),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//  InkWell(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (BuildContext context) => DetailsProductPage(
//                             descrption:
//                                 'La piedra caliza es una roca sedimentaria de forma rectangular y colores claros. De aspecto poroso, en su textura pueden apreciarse fragmentos de fósiles o diferentes rangos de color.',
//                             imageAsset:
//                                 'https://syncronik.s3.us-east-2.amazonaws.com/Hubmine/grava-producto.png',
//                             measures: '1.65',
//                             titleProduct: 'Piedra caliza',
//                             weight: '-3/16” + 0',
//                             category: widget.nameCategory,
//                             price: r",000",
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 3.0,
//                       child: Container(
//                         height: 80,
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: primaryClr,
//                           ),
//                           title: Container(
//                             padding: EdgeInsets.only(top: 10, bottom: 2),
//                             child: Text('Arena 4D'),
//                           ),
//                           subtitle: Container(
//                             padding: EdgeInsets.only(bottom: 10),
//                             child: Text(
//                                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),