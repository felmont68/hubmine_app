import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/vAlpha/home_page_alpha.dart';
import 'package:mining_solutions/widgets/button_model.dart';

import 'package:provider/provider.dart';

class ConcretoOrderReady extends StatefulWidget {
  const ConcretoOrderReady({Key? key}) : super(key: key);

  @override
  State<ConcretoOrderReady> createState() => _ConcretoOrderReadyState();
}

class _ConcretoOrderReadyState extends State<ConcretoOrderReady>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Gracias por tu orden", style: subHeading1),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Load a Lottie file from your assets
              Lottie.asset(
                'assets/order-in-progress.json',
                controller: _controller,
                onLoaded: (composition) {
                  // Configure the AnimationController with the duration of the
                  // Lottie file and start the animation.
                  _controller
                    ..duration = composition.duration
                    ..repeat();

                  //goToNewScren();
                },
              ),
              const SizedBox(height: 20),
              Text("Orden recibida ✅", style: heading),
              Text(
                "Su pedido se está procesando en breve un ejecutivo de ventas se comunicará con usted para confirmar su orden.",
                style: body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Button(
                  action: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const HomePage()),
                        (Route<dynamic> route) => false);
                  },
                  text: Text("Ir a inicio", style: subHeading2White),
                  color: primaryClr,
                  width: 279,
                  height: 56)
            ],
          ),
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
