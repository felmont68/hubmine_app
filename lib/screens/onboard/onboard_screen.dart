import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/services/location_services.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          decoration: getPageDecoration(),
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/hubmine-icon-mini.png", width: 35),
              const SizedBox(height: 10),
              Text("Conoce Hubmine", style: h2TextStyle),
            ],
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Ya está aquí, la app que tiene todo para la Construcción, en un solo lugar. Nos alegra tenerte acá y que formes parte de nuestra comunidad.",
                    textAlign: TextAlign.center,
                    style: descriptionProduct),
              ],
            ),
          ),
          image: buildImage('assets/know-hubmine.png'),
        ),
        PageViewModel(
          decoration: getPageDecoration(),
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/hubmine-icon-mini.png", width: 35),
              const SizedBox(height: 10),
              Text("Compra express", style: h2TextStyle),
            ],
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Visualiza nuestro catálogo y añade productos a tu carrito para realizar tu compra.",
                    textAlign: TextAlign.center,
                    style: descriptionProduct),
              ],
            ),
          ),
          image: buildImage('assets/compra-express.png'),
        ),
        PageViewModel(
          decoration: getPageDecoration(),
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: accentRed, size: 40),
              const SizedBox(height: 10),
              Text("Ubicación", style: h2TextStyle),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),
                  child: GestureDetector(
                    onTap: () {},
                    child: FittedBox(
                        child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Text("Quizás luego", style: swipeBtnGrey),
                    )),
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: primaryClr,
                      border: Border.all(
                        color: primaryClr,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),
                  child: GestureDetector(
                    onTap: () {
                      ServiceLocation.requestPermissions(context);
                    },
                    child: FittedBox(
                        child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Text("Activar ubicación", style: swipeBtnWhite),
                    )),
                  )),
            ],
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Enviamos tu pedido por la ruta más óptima. Solamente tienes que especificar el destino, nosotros nos encargamos del resto.",
                    textAlign: TextAlign.center,
                    style: descriptionProduct),
              ],
            ),
          ),
          image: buildImage('assets/activate-location-hubmine.png'),
        ),
        PageViewModel(
          decoration: getPageDecoration(),
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/hubmine-icon-mini.png", width: 35),
              const SizedBox(height: 10),
              Text("Todo listo ✅", style: h2TextStyle),
            ],
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("¡Nos vemos en la obra!",
                    textAlign: TextAlign.center, style: descriptionProduct),
              ],
            ),
          ),
          image: buildImage('assets/nos-vemos-en-obra.png'),
        ),
      ],
      done: Text("Hecho", style: swipeBtnPrimary),
      onDone: () {
        // When done button is press
        Navigator.of(context).pushReplacementNamed("intro_screen");
      },
      showBackButton: true,
      showSkipButton: false,
      next: const Icon(Icons.arrow_forward, color: primaryClr, size: 28),
      back: const Icon(Icons.arrow_back, color: primaryClr, size: 28),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: primaryClr,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    ));
  }

  Widget buildImage(String path) => Padding(
        padding: const EdgeInsets.only(top: 145.0),
        child: Center(child: Image.asset(path, width: 350)),
      );
  PageDecoration getPageDecoration() =>
      const PageDecoration(imagePadding: EdgeInsets.all(0));
}
