import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/orders/order_preview.dart';
import 'package:mining_solutions/screens/orders/order_summary.dart';
import 'package:mining_solutions/services/orders_services.dart';

import 'package:intl/date_symbol_data_local.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Mis pedidos", style: subHeading1),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 18.0),
            child: Container(
              color: Colors.white.withOpacity(0.49),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: fetchOrders(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: const CircularProgressIndicator());
            } else if (snapshot.data!.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Map order = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderSummary(
                            order,
                          ),
                        ),
                      );
                    },
                    child: PreviewOrder(
                        product: "${order['product']['product_name']}",
                        urlImage: "${order['product']['product_url_image']}",
                        status: "${order['status']['order_description']}",
                        order: order['pk'].toString(),
                        fechaEntrega: "13 de Mayo"),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Divider(color: gray20),
                  );
                },
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                            color: gray05,
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(28),
                        child: const Icon(Iconsax.document_text5,
                            color: gray80, size: 32),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
                            child: Text(
                              "Todavía no has realizado ninguna compra",
                              style: bodyGray80,
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  String getOrderName(Map order) {
    int count = 0;

    for (Map _ in order["products"]) {
      count++;
    }

    if (count > 1) {
      return "${order["products"][0]["product__product_name"]} y ${count - 1} más";
    } else {
      return order["products"][0]["product__product_name"];
    }
  }
}
