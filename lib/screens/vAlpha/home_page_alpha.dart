import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/location_data.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/blog/hubmine_blog.dart';
import 'package:mining_solutions/screens/profile/profile_page.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/services/categories_services.dart';
import 'package:mining_solutions/services/directions_services.dart';
import 'package:mining_solutions/widgets/categorie_demo.dart';
import 'package:provider/provider.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';

class HomePageAlpha extends StatefulWidget {
  const HomePageAlpha({Key? key}) : super(key: key);

  @override
  _HomePageAlphaState createState() => _HomePageAlphaState();
}

class _HomePageAlphaState extends State<HomePageAlpha> {
  int selectedIndex = 0;
  final GlobalKey<ProfilePageState> _key = GlobalKey();
  Widget profilePage = const ProfilePage();
  loadState() {
    print("Recargando estado del navbar");
    setState(() {});
  }

  loadKey() {
    setState(() {
      profilePage = ProfilePage(key: _key, reloadState: loadState);
      pages.add(profilePage);
    });
  }

  List<LocationData> _dataLocations = [];
  final padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12);

  List<Widget> pages = [
    //const HomeContent(),
    const HomeContent(),
    const BlogPage(),
    const ProfilePage(),
  ];

  PageController controller = PageController();

  bool haveLocations = false;

  String profilePhotoPath = "";

  _fetchDataDirections() async {
    try {
      _dataLocations = await ServiceDirections.fetchDirectionsAll();
      setState(() {
        haveLocations = true;
      });
    } catch (_) {}
  }

  _loadDataUser() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      var name = _prefs.getString('firstName');
      var profile = _prefs.getString("profilePhoto");
      setState(() {
        profilePhotoPath = profile as String;
      });
    } catch (_) {
      print(_);
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    loadKey();
    loadInfoUserProfile(context);
    _loadDataUser();
    // ServiceLocation.getCurrentLocation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(0.0, 0.0),
          child: AppBar(
            // Here we create one to set status bar color
            elevation: 0,
            backgroundColor: Colors
                .white, // Set any color of status bar you want; or it defaults to your theme's primary color
          )),
      extendBody: true,
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            selectedIndex = page;
            // badge = badge + 1;
          });
        },
        controller: controller,
        itemBuilder: (context, position) {
          print(position);
          return Container(child: pages[_selectedIndex]);
        },
        itemCount: 2,
      ),
      bottomNavigationBar: Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 6.0,
            ),
            child: Opacity(
              opacity: 0.9,
              child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Iconsax.home_25),
                      ),
                      label: 'Tienda',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Iconsax.people5),
                      ),
                      label: 'Comunidad',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Iconsax.profile_circle5),
                      ),
                      label: 'Mi Perfil',
                      backgroundColor: Colors.blue,
                    ),
                  ],
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  selectedItemColor: primaryClr,
                  selectedLabelStyle: selectedLabelStyle,
                  unselectedLabelStyle: unSelectedLabelStyle,
                  unselectedItemColor: gray40,
                  backgroundColor: Colors.white,
                  unselectedFontSize: 14,
                  iconSize: 24,
                  onTap: _onItemTapped,
                  elevation: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<LocationData> _dataLocations = [];
  String firstName = "";
  String profilePhotoPath = "";

  _fetchDataDirections() async {
    try {
      _dataLocations = await ServiceDirections.fetchDirectionsAll();
      //print(_dataLocations[0].toMap());
      setState(() {});
    } catch (_) {}
  }

  _loadDataUser() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      var name = _prefs.getString('firstName');
      var profile = _prefs.getString("profilePhoto");
      setState(() {
        firstName = name as String;
        profilePhotoPath = profile as String;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    // ServiceLocation.getCurrentLocation(context);
    super.initState();
    _fetchDataDirections();
    _loadDataUser();
  }

  List dataCarrousel = [
    {
      "heading": "Grava, arena y agregados",
      "subHeading": "Muy pronto en tu ciudad",
      "urlPhoto": "assets/agregado.jpeg",
      "category": "agregates"
    },
    {
      "heading": "Concreto",
      "subHeading": "Muy pronto en tu ciudad",
      "urlPhoto": "assets/camion-revolvedor.jpeg",
      "category": "concrete"
    },
    {
      "heading": "Maquinaria e insumos",
      "subHeading": "Muy pronto en tu ciudad",
      "urlPhoto": "assets/maquinaria.jpg",
      "category": "machines"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 30.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30.0,
                          width: 120.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/Logo-Hubmine.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("help");
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.3,
                                  color: Colors.black26,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        10.0) //                 <--- border radius here
                                    ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset("assets/headphone.svg",
                                    color: primaryClr, height: 12, width: 12),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                // TODO: Revisar el overflow en dispositivos más pequeños
                SizedBox(
                    height: 32,
                    child: Container(
                      color: Colors.white,
                    )),
                Container(
                  color: Colors.white,
                  height: _height / 3.1,
                  width: _width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Hola $firstName 👋", style: heading),
                          Text(
                              "Te contactaremos en un momento para verificar tu información y brindarte información sobre los pasos a seguir para que empieces a disfrutar de Hubmine",
                              style: body,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 18),
                          Container(
                            width: 140.0,
                            height: 140.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/waitlist.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  color: Colors.white,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 131.0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                    items: dataCarrousel.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                        ])
                                  ],
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                    height: _height / 3,
                    color: Colors.white,
                    child: buildCategories(_height, _width)),
              ],
            ),
          ),
        ));
  }

  Column buildCategories(height, width) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 5, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Podrás transportar", style: heading2Black),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: FutureBuilder(
              future: fetchCategories(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 80,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map category = snapshot.data![index];
                          // print(category);
                          return CategoryDemo(
                            category: category['category_name'],
                            idCategory: category['id'],
                            urlSVG: category['url'],
                          );
                        }),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SkeletonItem(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              height: 40,
                              width: 90,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SkeletonItem(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              height: 40,
                              width: 90,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SkeletonItem(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              height: 40,
                              width: 79,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SkeletonItem(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              height: 40,
                              width: 75,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }

  Container buildCarrousel(imageList, height) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      child: CarouselSlider.builder(
        itemCount: imageList.length,
        options: CarouselOptions(
            enlargeCenterPage: true,
            height: height * 0.25,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            reverse: false,
            aspectRatio: 16 / 9),
        itemBuilder: (context, i, id) {
          //for onTap to redirect to another screen
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white,
                  )),
              //ClipRRect for image border radius
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageList[i],
                  height: 100,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              var url = imageList[i];
              print(url.toString());
            },
          );
        },
      ),
    );
  }
}
