import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/home/home_page.dart';
import 'package:mining_solutions/screens/vAlpha/home_page_alpha.dart';
import 'package:mining_solutions/widgets/button_model.dart';

import 'package:provider/provider.dart';

class MachinaryQuotationRequested extends StatefulWidget {
  const MachinaryQuotationRequested({Key? key}) : super(key: key);

  @override
  State<MachinaryQuotationRequested> createState() =>
      _MachinaryQuotationRequestedState();
}

class _MachinaryQuotationRequestedState
    extends State<MachinaryQuotationRequested> with TickerProviderStateMixin {
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
        title: Text("Tu solicitud ha sido recibida", style: subHeading1),
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
              Text(
                "Solicitud de cotización recibida ✅",
                style: heading,
                textAlign: TextAlign.center,
              ),
              Text(
                "Tus datos serán enviados a un representante comercial quién se podrá en contacto contigo a la brevedad",
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
