import 'package:badges/badges.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/services/cart_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:get/get.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import '../../providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class DetailsProductPage extends StatefulWidget {
  final String productID;
  final String imageAsset;
  final String category;
  final String titleProduct;
  final String descrption;
  final String weight;
  final String measures;
  final String price;
  const DetailsProductPage({
    Key? key,
    required this.productID,
    required this.imageAsset,
    required this.titleProduct,
    required this.descrption,
    required this.weight,
    required this.measures,
    required this.category,
    required this.price,
  }) : super(key: key);

  @override
  State<DetailsProductPage> createState() => _DetailsProductPageState();
}

class _DetailsProductPageState extends State<DetailsProductPage> {
  List dataCategories = [
    {"value": r"-3/16'+0", "caracteristic": "Medidas"},
    {"value": "1.65", "caracteristic": "Peso volumétrico"}
  ];
  int totalCart = 0;

  _fetchCart() async {
    var cart = await fetchMyCart();
    setState(() {
      totalCart = cart.length;
    });
  }

  bool _hasLoggedIn = false;

  loadHasLoggedIn() async {
    var hasLoggedIn = await ServiceStorage.getHasLoggedIn();

    setState(() {
      _hasLoggedIn = hasLoggedIn;
    });
    if (_hasLoggedIn) {
      _fetchCart();
    }
  }

  @override
  void initState() {
    super.initState();
    loadHasLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final size = MediaQuery.of(context).size;

    // TODO: Cargar en provider al inicio el carrito completo desde API
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    List cart = userInfo.cart;
    int itemsInCart = userInfo.itemsInCart;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(Iconsax.arrow_left, color: Colors.white)),
            ),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.01),
                    ]),
              ),
            ),
            // ignore: prefer_const_literals_to_create_immutables
            actions: [
              totalCart > 0
                  ? Badge(
                      position: BadgePosition.topStart(top: 10, start: 12),
                      badgeContent: Text("$totalCart", style: cartBadge),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed("cart")
                                .then((value) => _fetchCart());
                          },
                          icon: const Icon(Iconsax.bag5, color: Colors.white)),
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("cart")
                            .then((value) => _fetchCart());
                      },
                      icon: const Icon(Iconsax.bag5, color: Colors.white)),
              const SizedBox(
                width: 10,
              )
            ]),
        bottomNavigationBar: Container(
          height: 110,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  stops: [0.5, 0.8],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hasLoggedIn
                      ? Button(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SvgPicture.asset(
                                widget.category == "Concreto"
                                    ? "assets/document.svg"
                                    : "assets/bag.svg",
                                color: white),
                          ),
                          color: primaryClr,
                          text: Text(
                            widget.category == "Concreto"
                                ? "Solicitar cotización"
                                : "Añadir al carrito",
                            style: subHeading2White,
                          ),
                          width: double.infinity,
                          height: 56,
                          action: () async {
                            if (cart.isNotEmpty) {
                              bool? changeOrder =
                                  await showModalBottomSheet<bool>(
                                context: context,
                                enableDrag: false,
                                shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.vertical(
                                    top: SmoothRadius(
                                        cornerRadius: 20, cornerSmoothing: 1),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ListView(
                                        children: <Widget>[
                                          // Decoración al principio del bottom sheet
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Center(
                                              child: Wrap(children: [
                                                SizedBox(
                                                    width: 20,
                                                    height: 6,
                                                    child: Container(
                                                      // color: HMColor.primary,
                                                      decoration: const BoxDecoration(
                                                          color: primaryClr,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                    )),
                                              ]),
                                            ),
                                          ),
                                          Text("¿Quieres cambiar de orden?",
                                              style: heading),
                                          const SizedBox(height: 16),

                                          Text(
                                              "Actualmente tienes productos de otro proveedor agregados en el carrito. ¿Quieres remover esos productos y añadir estos nuevos?",
                                              style: body),
                                          const SizedBox(height: 20),
                                          Column(
                                            children: [
                                              Button(
                                                  color: primaryClr,
                                                  text: Text(
                                                    "Sí, quítalos",
                                                    style: subHeading1White,
                                                  ),
                                                  width: double.infinity,
                                                  height: size.height * 0.06,
                                                  action: () {
                                                    Navigator.pop(
                                                        context, true);
                                                  }),
                                              const SizedBox(height: 16),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: primaryClr,
                                                      width: 1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(16)),
                                                ),
                                                child: Button(
                                                    color: white,
                                                    text: Text(
                                                      "No, manténlos",
                                                      style: subHeading1Primary,
                                                    ),
                                                    width: double.infinity,
                                                    height: size.height * 0.06,
                                                    action: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    }),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              changeOrder ??= false;

                              if (changeOrder) {
                                await clearMyCart();
                              } else {
                                return;
                              }
                            }

                            if (widget.category == "Concreto") {
                              print("Ahora voy a cotizar concreto");
                              Navigator.of(context)
                                  .pushNamed("concreto-step-one");
                              double parsedPrice = double.parse(widget.price
                                  .replaceAll(RegExp('[^0-9]'), ''));
                              if (await addToCart(
                                  widget.productID,
                                  parsedPrice.toString(),
                                  parsedPrice.toString(),
                                  context)) {
                                _fetchCart();
                                Map cartItem = {
                                  "productID": widget.productID,
                                  "price": parsedPrice
                                };

                                setState(() {
                                  cart.add(cartItem);
                                  print(cart.length);
                                  itemsInCart = cart.length;
                                });
                              }
                            } else {
                              double parsedPrice = double.parse(widget.price
                                  .replaceAll(RegExp('[^0-9]'), ''));
                              if (await addToCart(
                                  widget.productID,
                                  parsedPrice.toString(),
                                  parsedPrice.toString(),
                                  context)) {
                                _fetchCart();
                                Map cartItem = {
                                  "productID": widget.productID,
                                  "price": parsedPrice
                                };

                                Get.snackbar("Producto agregado",
                                    "Se ha agregado el producto al carrito",
                                    backgroundColor: primaryClr,
                                    colorText: Colors.white,
                                    onTap: (GetSnackBar snackbar) {
                                  Navigator.of(context).pushNamed('cart');
                                });

                                setState(() {
                                  cart.add(cartItem);
                                  print(cart.length);
                                  itemsInCart = cart.length;
                                });
                                Navigator.of(context)
                                    .pushNamed("cart")
                                    .then((value) => _fetchCart());
                              }
                            }
                          })
                      : Button(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SvgPicture.asset("assets/bag.svg",
                                color: primaryClr),
                          ),
                          color: primaryLightClr,
                          text: Text(
                            "Inicia sesión para comprar",
                            style: subHeading2PrimaryClr,
                          ),
                          width: double.infinity,
                          height: 56,
                          action: () async {
                            Navigator.of(context).pushNamed("login");
                          }),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 375,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    SizedBox(
                      width: size.width,
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        height: 375,
                        imageUrl: widget.imageAsset,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.category, style: captions),
                        const SizedBox(height: 2),
                        Text(widget.titleProduct, style: heading),
                        const SizedBox(height: 8),
                        Text(widget.price, style: priceProductDetailsPage),
                        const SizedBox(height: 16),
                        Text(widget.descrption, style: body),
                        const SizedBox(height: 20),
                        // TODO: Características técnicas dinámicas
                        widget.category == "Agregados"
                            ? Text("Características técnicas", style: subtitle)
                            : Container(),
                        const SizedBox(height: 8),
                        widget.category == "Agregados"
                            ? SizedBox(
                                height: 70,
                                child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dataCategories.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: gray05,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                              children: const [
                                                                Icon(
                                                                    Iconsax
                                                                        .document_text5,
                                                                    color:
                                                                        primaryClr)
                                                              ]),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  dataCategories[
                                                                          index]
                                                                      ['value'],
                                                                  style:
                                                                      subHeading1),
                                                              Text(
                                                                  dataCategories[
                                                                          index]
                                                                      [
                                                                      'caracteristic'],
                                                                  style:
                                                                      captions),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    }),
                              )
                            : Container()
                      ]),
                ),
              ),
            ],
          ),
        ));
  }
}

// Container(
//                 color: Colors.white,
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(10.0),
//                     bottomRight: Radius.circular(10.0),
//                   ),
//                   child: CachedNetworkImage(
//                     width: MediaQuery.of(context).size.width,
//                     fit: BoxFit.fitWidth,
//                     height: 260,
//                     imageUrl: widget.imageAsset,
//                     placeholder: (context, url) => const Center(
//                       child: SizedBox(
//                         width: 40,
//                         height: 40,
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                   ),
//                 ),
//               ),
