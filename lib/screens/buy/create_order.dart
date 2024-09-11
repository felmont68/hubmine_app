import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/buy/details_order.dart';
import 'package:mining_solutions/services/orders_services.dart';

import 'package:provider/provider.dart';

class CreateOrder extends StatefulWidget {
  final Map order;
  const CreateOrder({Key? key, required this.order}) : super(key: key);

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  bool showStepOne = false;
  bool showStepTwo = false;
  bool showSucces = false;
  Map purchaseOrder = {};

  loadOrderDetails() async {
    var po = await fetchPO(widget.order['pk'].toString());
    if (po.isNotEmpty) {
      print(po);
      setState(() {
        purchaseOrder = po;
      });
    } else {}
  }

  @override
  void initState() {
    loadOrderDetails();
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () async {
      setState(() {
        showStepOne = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 200), () async {
      setState(() {
        showStepOne = false;
        showStepTwo = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 900), () async {
      setState(() {
        showStepOne = false;
        showStepTwo = false;
        showSucces = true;
      });
    });

    final userInfo = Provider.of<UserInfo>(context, listen: false);

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Holaa");
        goToNewScren(userInfo.uid, userInfo.customerTypeID, widget.order);
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
            Visibility(
                visible: showStepOne,
                child: Text("Generando pedido...", style: heading3)),
            Visibility(
                visible: showStepTwo,
                child: Text("Asignando a proveedor...", style: heading3)),
            Visibility(
                visible: showSucces,
                child: Text("¡Ya lo tienes! Pedido creado", style: heading3))
          ],
        ),
      ),
    );
  }

  void goToNewScren(userType, customerTypeID, order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsOrder(order, purchaseOrder),
      ),
    );
  }
}
