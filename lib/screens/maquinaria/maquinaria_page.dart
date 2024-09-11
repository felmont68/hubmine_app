import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/services/categories_services.dart';
import 'package:mining_solutions/services/machinary_services.dart';
import 'package:mining_solutions/widgets/machinary_preview.dart';
import 'package:mining_solutions/widgets/product_preview.dart';
import 'package:skeletons/skeletons.dart';

class MaquinariaPage extends StatefulWidget {
  const MaquinariaPage({Key? key}) : super(key: key);

  @override
  State<MaquinariaPage> createState() => _MaquinariaPageState();
}

class _MaquinariaPageState extends State<MaquinariaPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text("Renta y Compra Maquinaria", style: subHeading1),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                FutureBuilder(
                    future: fetchMachinary(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                    width: MediaQuery.of(context).size.width,
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SkeletonItem(
                              child: SkeletonLine(
                                style: SkeletonLineStyle(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    height: 120,
                                    width: MediaQuery.of(context).size.width,
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SkeletonItem(
                              child: SkeletonLine(
                                style: SkeletonLineStyle(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    height: 120,
                                    width: MediaQuery.of(context).size.width,
                                    borderRadius: BorderRadius.circular(16)),
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
                                child: MachinaryPreview(
                                  productID: productByCategory['id'].toString(),
                                  supplierName: productByCategory['mark']
                                      ['name'],
                                  productName: productByCategory['name'],
                                  // TODO: Cambiar esto y hacerlo dinámico
                                  // category: productByCategory['category']
                                  //     ['category_name'],
                                  category: productByCategory['mark']
                                      ['category_name'],
                                  shortDescription:
                                      productByCategory['description']
                                              .substring(0, 57) +
                                          "...",
                                  description: productByCategory['description'],
                                  image: productByCategory['image'],
                                  disccount: "0",

                                  // TODO: Hacer dinámico
                                  // initialPrice: r"Desde $" +
                                  //     productByCategory['price']['total']
                                  //         .toString() +
                                  //     " " +
                                  //     productByCategory['price']['badge'] +
                                  //     "/" +
                                  //     productByCategory['unity']['unity'],
                                  initialPrice: "Renta / Venta",
                                ));
                          },
                          separatorBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/start_search.svg"),
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
        ));
  }
}
