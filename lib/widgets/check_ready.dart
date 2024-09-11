import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/vAlpha/home_page_alpha.dart';
import 'package:provider/provider.dart';

class CheckReady extends StatefulWidget {
  const CheckReady({Key? key}) : super(key: key);

  @override
  State<CheckReady> createState() => _CheckReadyState();
}

class _CheckReadyState extends State<CheckReady> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    final userInfo = Provider.of<UserInfo>(context, listen: false);

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        goToNewScren(userInfo.uid, userInfo.customerTypeID);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Load a Lottie file from your assets
            Lottie.asset(
              'assets/check-mark-success.json',
              width: 100,
              height: 100,
              controller: _controller,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..forward();

                //goToNewScren();
              },
            ),
            const SizedBox(height: 20),
            Text("¡Ya lo tienes!", style: heading3)
          ],
        ),
      ),
    );
  }

  void goToNewScren(userType, customerTypeID) {
    if (customerTypeID.toString() == "3") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePageAlpha()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()),
          (Route<dynamic> route) => false);
    }
  }
}
