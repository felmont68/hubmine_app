import 'package:flutter/material.dart';
import 'package:mining_solutions/screens/home/home_content.dart';

class HomeContentLayout extends StatefulWidget {
  const HomeContentLayout({Key? key}) : super(key: key);

  @override
  State<HomeContentLayout> createState() => _HomeContentLayoutState();
}

class _HomeContentLayoutState extends State<HomeContentLayout> {
  bool _status = true;
  final bool _isDriver = false;

  @override
  void initState() {
    // TODO: Añadir validación si la app ya se abrió ya no mostrar el skeleton
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _status = false;
      //setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HomeContent();
  }
}
