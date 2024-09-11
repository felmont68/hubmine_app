import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/location_data.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/home/widgets/waiting_categories.dart';
import 'package:mining_solutions/screens/home/widgets/waiting_products.dart';
import 'package:mining_solutions/screens/locations/current_location_page.dart';
import 'package:mining_solutions/screens/locations/edit_location_page.dart';
import 'package:mining_solutions/screens/login/login_page.dart';
import 'package:mining_solutions/screens/products/products_all_page.dart';
import 'package:mining_solutions/services/cart_services.dart';
import 'package:mining_solutions/services/categories_services.dart';
import 'package:mining_solutions/services/directions_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/widgets/category_widget.dart';
import 'package:mining_solutions/widgets/input_model.dart';
import 'package:mining_solutions/widgets/product_preview.dart';
import 'package:mining_solutions/widgets/show_custom_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import '../locations/current_location_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:figma_squircle/figma_squircle.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<LocationData> _dataLocations = [];
  int totalCart = 0;

  _fetchDataDirections() async {
    if (mounted) {
      _dataLocations = await ServiceDirections.fetchDirectionsAll();
    }
  }

  _fetchCart() async {
    if (mounted) {
      var cart = await fetchMyCart();
      final userInfo = Provider.of<UserInfo>(context, listen: false);
      userInfo.cart = cart;
      setState(() {
        totalCart = cart.length;
      });
    }
  }

  bool _hasLoggedIn = false;

  loadHasLoggedIn() async {
    if (mounted) {
      var hasLoggedIn = await ServiceStorage.getHasLoggedIn();
      setState(() {
        _hasLoggedIn = hasLoggedIn;
      });
      if (_hasLoggedIn) {
        await _fetchDataDirections();
        await _fetchCart();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadHasLoggedIn();
  }

  List dataCarrousel = [
    {
      "heading": "Grava, arena y agregados",
      "subHeading": "Entrega express",
      "urlPhoto": "assets/camion-con-grava.jpeg",
      "category": "Agregados"
    },
    {
      "heading": "Concreto",
      "subHeading": "Rastreo en tiempo real",
      "urlPhoto": "assets/camion-revolvedor.jpeg",
      "category": "Concreto"
    },
    {
      "heading": "Maquinaria e insumos",
      "subHeading": "Compra y renta",
      "urlPhoto": "assets/maquinaria.jpg",
      "category": "Maquinaria"
    },
  ];

  List dataCategories = [
    {
      "category": "Cemento",
      "url":
          "https://syncronik.s3.us-east-2.amazonaws.com/Hubmine/categories/cemento.svg"
    },
    {
      "category": "Prefabricados",
      "url":
          "https://syncronik.s3.us-east-2.amazonaws.com/Hubmine/categories/prefabricados.svg"
    }
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 18.0),
                child: Container(
                  color: Colors.white.withOpacity(0.49),
                ),
              ),
            ),
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
                          icon: const Icon(Iconsax.bag5, color: textBlack)),
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("cart")
                            .then((value) => _fetchCart());
                      },
                      icon: const Icon(Iconsax.bag5, color: textBlack)),
              const SizedBox(width: 10)
            ],
            title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.vertical(
                            top: SmoothRadius(
                                cornerRadius: 20, cornerSmoothing: 1),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter myState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 250,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10.0, right: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //mapa y direcciones
                                    Center(
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
                                                          Radius.circular(4))),
                                            )),
                                      ]),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 20,
                                          bottom: 10,
                                          right: 10),
                                      child: Text(
                                        'Agrega o escoge una dirección de entrega',
                                        style: heading,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                          right: 10,
                                          bottom: 10),
                                      child: const SearchAddressInput(
                                        hintText: "Ingresa una dirección",
                                        suffixIcon: Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5.0, right: 20),
                                            child: Icon(Iconsax.location5,
                                                color: gray20)),
                                      ),
                                    ),
                                    _hasLoggedIn
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 10.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                    // TODO: establecer rutas
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
                                                  padding: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: Icon(Iconsax.gps5),
                                                ),
                                                title: Text(
                                                  'Ubicación Actual',
                                                  style: subHeading1,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 10.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                    return const LoginPage();
                                                  }),
                                                );
                                              },
                                              child: ListTile(
                                                leading: const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: Icon(
                                                    Iconsax.gps5,
                                                    color: primaryClr,
                                                  ),
                                                ),
                                                title: Text(
                                                  'Inicia sesión para guardar la ubicación de tu obra',
                                                  style: subHeading1Primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                    Expanded(
                                      child: ListView.separated(
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemCount: _dataLocations.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              locationProvider
                                                  .setiDLocationSelected(
                                                      _dataLocations[index].id);
                                              // TODO: Hacer el cambio de ubicación seleccionada
                                              print(locationProvider
                                                  .iDLocationSelected);
                                              myState(() {});
                                            },
                                            child: ListTile(
                                              leading: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4),
                                                  child: _setIcon(
                                                      _dataLocations[index]
                                                          .tagId,
                                                      locationProvider
                                                          .iDLocationSelected)),
                                              trailing: locationProvider
                                                          .iDLocationSelected ==
                                                      _dataLocations[index].id
                                                  ? const Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      color: primaryClr)
                                                  : DropdownButton(
                                                      underline: Container(),
                                                      icon: const Icon(
                                                          Iconsax.more),
                                                      elevation: 4,
                                                      style: subHeading1,
                                                      onChanged: (int?
                                                          newValue) async {
                                                        if (newValue == 0) {
                                                          if (await ServiceDirections
                                                              .deleteDirection(
                                                                  _dataLocations[
                                                                          index]
                                                                      .id)) {
                                                            Navigator.of(context).pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        const HomePage()),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                          }
                                                        } else {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  EditLocationPage(
                                                                data:
                                                                    LocationData(
                                                                  id: _dataLocations[
                                                                          index]
                                                                      .id,
                                                                  city: _dataLocations[
                                                                          index]
                                                                      .city,
                                                                  details: _dataLocations[
                                                                          index]
                                                                      .details,
                                                                  directionInOneLine:
                                                                      _dataLocations[
                                                                              index]
                                                                          .directionInOneLine,
                                                                  name: _dataLocations[
                                                                          index]
                                                                      .name,
                                                                  state: _dataLocations[
                                                                          index]
                                                                      .state,
                                                                  tagId: _dataLocations[
                                                                          index]
                                                                      .tagId,
                                                                  lat: _dataLocations[
                                                                          index]
                                                                      .lat,
                                                                  log: _dataLocations[
                                                                          index]
                                                                      .log,
                                                                  haveDetails:
                                                                      _dataLocations[
                                                                              index]
                                                                          .haveDetails,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      items: [
                                                        DropdownMenuItem<int>(
                                                          value: 0,
                                                          child: Text(
                                                              'Eliminar',
                                                              style: body),
                                                        ),
                                                        DropdownMenuItem<int>(
                                                          value: 1,
                                                          child: Text('Editar',
                                                              style: body),
                                                        ),
                                                      ],
                                                    ),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _dataLocations[index].name,
                                                    style: subHeading2,
                                                  ),
                                                  Text(
                                                    _dataLocations[index].city,
                                                    style: body,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      );
                      // Navigator.of(context).pushNamed('demo_maps');
                      // print("Obteniendo ubicación");
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Iconsax.location5,
                            size: 27, color: primaryClr),
                        const SizedBox(width: 6),
                        Consumer<LocationProvider>(
                            builder: (context, locationProvider, child) {
                          return Text(
                            locationProvider.nameStreet != ""
                                ? locationProvider.nameStreet
                                : "Selecciona una ubicación",
                            style: subHeading2,
                          );
                        }),
                        const Icon(Icons.arrow_drop_down_outlined,
                            color: Colors.black),
                      ],
                    ),
                  ),
                ])),
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Encuentra',
                      style: smallBody,
                    ),
                    Text(
                      'Todo para tu construcción',
                      style: heading,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CarouselSlider(
                options: CarouselOptions(
                  height: 131.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                items: dataCarrousel.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          //load carrousel
                          if (i['category'] == "Concreto") {
                            Navigator.of(context)
                                .pushNamed("concreto-step-one");
                          } else if (i['category'] == "Maquinaria") {
                            Navigator.of(context).pushNamed("maquinaria");
                          } else {
                            //navegacion categorias
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ProductsAllPage(
                                  idCategory: 1,
                                  nameCategory: i['category'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(2.7, 2.0);
                                  var end = Offset.zero;
                                  var curve = Curves.bounceIn;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                                image: AssetImage(i["urlPhoto"]),
                                fit: BoxFit.fitWidth,
                              ),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 24,
                                  cornerSmoothing: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(i['heading'], style: carrouselHeading),
                                  Text(i['subHeading'],
                                      style: carrouselSubHeading),
                                  const SizedBox(height: 4),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 70.0,
                                          height: 16.0,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/hubmine-icon-name.png'),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                            "assets/arrow_right.svg",
                                            width: 24,
                                            height: 24,
                                            color: Colors.white),
                                      ])
                                ],
                              ),
                            )),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FutureBuilder(
                  future: fetchCategories(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const WaitingCategories();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List dataHome = snapshot.data!.length > 4
                          ? snapshot.data!.sublist(0, 4)
                          : snapshot.data!;
                      return SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          itemCount: dataHome.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == dataHome.length) {
                              return InkWell(
                                onTap: () {
                                  showCustomBottomSheet(
                                    context,
                                    "Elige la categoría de tu interés",
                                    null,
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceEvenly,
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: snapshot.data!.map((item) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Center(
                                                child: Category(
                                                  category:
                                                      item['category_name'],
                                                  idCategory: item['id'],
                                                  url: item['url'] ?? '',
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    null,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: gray05),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Ver más",
                                                  style: categoriesLabel),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            Map category = dataHome[index];
                            return Category(
                              category: category['category_name'],
                              idCategory: category['id'],
                              url: category['url'] ?? '',
                            );
                          },
                        ),
                      );
                    } else {
                      //return const Text('No se encontraron categorías');
                      return ListView.builder(
                        itemCount: dataCategories.length,
                        itemBuilder: (context, index) {
                          final category = dataCategories[index];
                          print(category['url']);
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: category['url'] != null &&
                                      category['url'].toString().isNotEmpty
                                  ? SvgPicture.network(
                                      category['url'].toString(),
                                      placeholderBuilder: (context) =>
                                          const CircularProgressIndicator(),
                                      width: 40,
                                      height: 40,
                                    )
                                  : Image.asset(
                                      'assets/hubmine-icon-name.png',
                                      width: 40,
                                      height: 40,
                                    ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 18),
              FutureBuilder(
                //call api products
                future: fetchStarredProducts(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const WaitingProducts();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return SizedBox(
                      height: snapshot.data!.length * 180,
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map product = snapshot.data![index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 7.0, bottom: 7.0),
                            child: ProductPreview(
                              productID: product['pk'].toString(),
                              productName: product['product_name'],
                              category: product['category']['category_name'],
                              shortDescription: product['short_description'],
                              description: product['description'],
                              image: product['image'],
                              disccount: product['disscount'].toString(),
                              initialPrice: r"Desde $" +
                                  product['price']['total'].toString() +
                                  " " +
                                  product['price']['badge'],
                              measures: product['technical_features']
                                  ['measures'],
                              volumetricWeight: product['technical_features']
                                      ['volumetric_weight']
                                  .toString(),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(color: gray20),
                          );
                        },
                      ),
                    );
                  } else {
                    return const WaitingProducts();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _setIcon(int typeLocation, int iDLocationSelected) {
    switch (typeLocation) {
      case 1:
        return SvgPicture.asset("assets/house.svg",
            width: 25, height: 25, color: gray80);

      case 2:
        return SvgPicture.asset("assets/buliding.svg",
            width: 25, height: 25, color: gray80);

      case 3:
        return SvgPicture.asset("assets/plant.svg",
            width: 25, height: 25, color: gray80);

      case 4:
        return SvgPicture.asset("assets/corporate.svg",
            width: 25, height: 25, color: gray80);
    }
  }
}
