import 'package:flutter/material.dart';

import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/driver/home/driver_home_content.dart';
import 'package:mining_solutions/screens/driver/profile/driver_profile_page.dart';
import 'package:mining_solutions/screens/driver/services/driver_online_services.dart';
import 'package:mining_solutions/screens/driver/stats/driver_stats_page.dart';
import 'package:mining_solutions/screens/driver/trips/driver_trips_page.dart';
import 'package:mining_solutions/screens/intro/intro_screen.dart';
import 'package:mining_solutions/screens/profile/profile_page.dart';
import 'package:mining_solutions/services/auth_services.dart';
import 'package:provider/provider.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final GlobalKey<ProfilePageState> _key = GlobalKey();
  PageController controller = PageController();
  int selectedIndex = 0;
  double gap = 10;
  final padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  Widget profilePage = const DriverProfilePage();

  List<Widget> pages = [
    const DriverHomeContent(),
    const DriverStatsPage(),
    const DriverTripsPage()
  ];

  loadState() {
    setState(() {});
  }

  loadKey() {
    setState(() {
      profilePage = DriverProfilePage(key: _key, reloadState: loadState);
      pages.add(profilePage);
    });
  }

  @override
  void initState() {
    loadKey();
    //_fetchDataDirections();

    // ServiceLocation.getCurrentLocation(context);
    loadOnlineStatusAPI(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Stack(children: [
          const DriverHomeContent(),
          DraggableScrollableSheet(
            expand: false,
            snap: true,
            maxChildSize: 0.11,
            initialChildSize: 0.25,
            minChildSize: 0.20,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: const CustomScrollViewContent(),
              );
            },
          ),
        ]));
  }
}

/// Content of the DraggableBottomSheet's child SingleChildScrollView
class CustomScrollViewContent extends StatelessWidget {
  const CustomScrollViewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: const CustomInnerContent(),
      ),
    );
  }
}

class CustomInnerContent extends StatelessWidget {
  const CustomInnerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        const CustomDraggingHandle(),
        const SizedBox(height: 24),
        const CustomExploreBerlin(),
        const SizedBox(height: 24),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () async {
            print("Cerrando sesión");
            if (await logout(context)) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const IntroScreen()),
                  (Route<dynamic> route) => false);
            }
          },
          child: Text("Cerrar Sesión", style: subHeading2Red),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class CustomDraggingHandle extends StatelessWidget {
  const CustomDraggingHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 30,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class CustomExploreBerlin extends StatelessWidget {
  const CustomExploreBerlin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(
            height: 32,
            width: 32,
            child: Icon(Icons.keyboard_arrow_up_rounded,
                size: 32, color: textBlack),
          ),
          Text("Bienvenido ${userInfo.firstName}", style: heading),
          const SizedBox(
            height: 32,
            width: 32,
            child: Icon(Icons.list, size: 32, color: textBlack),
          ),
        ],
      ),
    );
  }
}

class CustomHorizontallyScrollingRestaurants extends StatelessWidget {
  const CustomHorizontallyScrollingRestaurants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            // CustomRestaurantCategory(),
            // SizedBox(width: 12),
            // CustomRestaurantCategory(),
            // SizedBox(width: 12),
            // CustomRestaurantCategory(),
            // SizedBox(width: 12),
            // CustomRestaurantCategory(),
            // SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class CustomFeaturedListsText extends StatelessWidget {
  const CustomFeaturedListsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      //only to left align the text
      child: Row(
        children: <Widget>[Text("Viajes recientes", style: subHeading1Gray)],
      ),
    );
  }
}

class CustomFeaturedItemsGrid extends StatelessWidget {
  const CustomFeaturedItemsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        //to avoid scrolling conflict with the dragging sheet
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        shrinkWrap: true,
        children: const <Widget>[
          CustomFeaturedItem(),
          CustomFeaturedItem(),
        ],
      ),
    );
  }
}

class CustomRecentPhotosText extends StatelessWidget {
  const CustomRecentPhotosText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: <Widget>[
          Text("Tus ganancias", style: subHeading1Gray),
        ],
      ),
    );
  }
}

class CustomRecentPhotoLarge extends StatelessWidget {
  const CustomRecentPhotoLarge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomFeaturedItem(),
    );
  }
}

class CustomRecentPhotosSmall extends StatelessWidget {
  const CustomRecentPhotosSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomFeaturedItemsGrid();
  }
}

class CustomRestaurantCategory extends StatelessWidget {
  const CustomRestaurantCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class CustomFeaturedItem extends StatelessWidget {
  const CustomFeaturedItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
