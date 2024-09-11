import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/models/location_data.dart';
import 'package:mining_solutions/screens/blog/hubmine_blog.dart';
import 'package:mining_solutions/screens/home/home_content_layout.dart';
import 'package:mining_solutions/screens/orders/orders_page.dart';
import 'package:mining_solutions/screens/profile/guest_profile_page.dart';
import 'package:mining_solutions/screens/profile/profile_page.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:mining_solutions/services/storage_services.dart';
import 'package:mining_solutions/services/directions_services.dart';
import '../../services/location_services.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ProfilePageState> _key = GlobalKey();
  int selectedIndex = 0;

  List<LocationData> _dataLocations = [];
  final padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  int badge = 0;
  Widget profilePage = const ProfilePage();
  Widget betweenPage = const OrdersPage();

  loadState() {
    setState(() {});
  }

  List<Widget> pages = [
    //const HomeContent(),
    const HomeContentLayout(),
  ];
  double gap = 10;

  PageController controller = PageController();

  bool haveLocations = false;

  _fetchDataDirections() async {
    try {
      //buscar direcciones asociadas
      _dataLocations = await ServiceDirections.fetchDirectionsAll();
      setState(() {
        haveLocations = true;
      });
    } catch (_) {}
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _hasLoggedIn = false;

  loadHasLoggedIn() async {
    var hasLoggedIn = await ServiceStorage.getHasLoggedIn();
    if (hasLoggedIn) {
      loadInfoUserProfile(context);
      _fetchDataDirections();
      setState(() {
        _hasLoggedIn = hasLoggedIn;
        profilePage = ProfilePage(key: _key, reloadState: loadState);
        pages.add(betweenPage);
        pages.add(profilePage);
      });
    } else {
      var blogPage = const BlogPage();
      setState(() {
        pages.add(blogPage);
        profilePage = const GuestProfilePage();
        pages.add(profilePage);
      });
    }
  }

  @override
  void initState() {
    loadHasLoggedIn();
    ServiceLocation.getCurrentLocation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            selectedIndex = page;
            print("New selceted index: $selectedIndex");
          });
        },
        controller: controller,
        itemBuilder: (context, position) {
          return Container(child: pages[_selectedIndex]);
        },
        itemCount: 4,
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
                  items: <BottomNavigationBarItem>[
                    const BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Iconsax.home_25),
                        ),
                        label: 'Tienda',
                        backgroundColor: Colors.green),
                    _hasLoggedIn
                        ? const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Iconsax.document_text5),
                            ),
                            label: 'Pedidos',
                            backgroundColor: Colors.yellow)
                        : BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: _selectedIndex == 1
                                  ? SvgPicture.asset("assets/community.svg",
                                      color: primaryClr, width: 30)
                                  : SvgPicture.asset("assets/community.svg",
                                      color: gray40, width: 30),
                            ),
                            label: 'Comunidad',
                          ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SvgPicture.asset("assets/profile.svg",
                            color: _selectedIndex == 2 ? primaryClr : gray60,
                            width: 20),
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
