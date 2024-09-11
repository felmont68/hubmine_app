import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/maquinaria/form_maquinaria.dart';
import 'package:mining_solutions/screens/supplier/supplier_page.dart';
import 'package:mining_solutions/services/cart_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/widgets/button_model.dart';
import '../../providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class DetailsMachinaryPage extends StatefulWidget {
  final String productID;
  final String supplierName;
  final String imageAsset;
  final String category;
  final String titleProduct;
  final String descrption;
  final String price;
  const DetailsMachinaryPage({
    Key? key,
    required this.productID,
    required this.supplierName,
    required this.imageAsset,
    required this.titleProduct,
    required this.descrption,
    required this.category,
    required this.price,
  }) : super(key: key);

  @override
  State<DetailsMachinaryPage> createState() => _DetailsMachinaryPageState();
}

class _DetailsMachinaryPageState extends State<DetailsMachinaryPage> {
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
                            child: SvgPicture.asset("assets/document.svg",
                                color: white),
                          ),
                          color: primaryClr,
                          text: Text(
                            "Solicitar cotización",
                            style: subHeading2White,
                          ),
                          width: double.infinity,
                          height: 56,
                          action: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FormMachinaryPage(
                                  name: userInfo.firstName,
                                  lastName: userInfo.lastName,
                                  phone: userInfo.phone,
                                  email: userInfo.email,
                                  urlImage: widget.imageAsset,
                                  productID: widget.productID,
                                  brand: widget.supplierName,
                                  titleProduct: widget.titleProduct,
                                ),
                              ),
                            );
                            // Navegación a página de que deseas hacer comprar o rentar
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
                        Row(
                          children: [
                            Text(widget.category, style: captions),
                            SizedBox(width: 2),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SupplierPage(
                                              supplierName:
                                                  widget.supplierName),
                                    ),
                                  );
                                },
                                child: Text(widget.supplierName,
                                    style: captionPrimary)),
                          ],
                        ),
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
