import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/services/machinary_services.dart';
import 'package:mining_solutions/widgets/machinary_preview.dart';
import 'package:skeletons/skeletons.dart';

class SupplierPage extends StatefulWidget {
  final String supplierName;
  const SupplierPage({Key? key, required this.supplierName}) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          physics: ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              toolbarHeight: size.width / 5,
              snap: true,
              floating: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Iconsax.arrow_left, color: Colors.black))),
              ),
              actions: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isFavorite ? Colors.red : Colors.black),
                        ))),
                const SizedBox(
                  width: 20,
                ),
              ],
              flexibleSpace: Container(
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://hubmine-d.s3.amazonaws.com/Covers/1633051759938+(1).jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://hubmine-d.s3.amazonaws.com/Covers/logo_genie.jpeg")),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${widget.supplierName}", style: heading),
                            SizedBox(width: 2),
                            Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                showDuration: const Duration(seconds: 3),
                                waitDuration: const Duration(milliseconds: 200),
                                message: "Este es un proveedor certificado",
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: const LinearGradient(
                                      colors: <Color>[primaryClr, primaryClr]),
                                ),
                                child: Icon(Icons.verified,
                                    size: 18, color: primaryClr))
                          ],
                        ),
                        // TODO: Detalles del proveedor, una pequeña descripción
                        Text("Maquinaria y equipo", style: bodyBlack),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sobre el proveedor", style: subHeading1),
                      // TODO: Detalles del proveedor, una descripción larga
                      Text(
                          "Aquí encontrará información detallada sobre las plataformas elevadoras Genie®, incluyendo las plataformas telescópicas S®, plataformas articuladas Z®, plataformas articuladas remolcables TZ™, plataformas de tijera GS™, manipuladores telescópicos GTH™, elevadores de personas, elevadores de material y brazos verticales.",
                          style: body)
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 20, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Productos", style: subHeading1)],
                  ),
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: FutureBuilder(
                      future: fetchMachinaryByBrand(widget.supplierName),
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    productID:
                                        productByCategory['pk'].toString(),
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
                                    description:
                                        productByCategory['description'],
                                    image: productByCategory['image'],
                                    disccount: "0",

                                    initialPrice: "Renta / Venta",
                                  ));
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
                                height: size.height / .5,
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                ),
              ],
            ),
          ),
        ));
  }
}
