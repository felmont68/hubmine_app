import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/buy/details_order.dart';
import 'package:mining_solutions/services/orders_services.dart';
import 'package:mining_solutions/utils/custom_launch.dart';
import '../../hubkens/colors.dart';
import 'package:intl/intl.dart';
import 'custom_timeline.dart';

import 'package:intl/date_symbol_data_local.dart';

class OrderSummary extends StatefulWidget {
  final Map order;
  const OrderSummary(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  bool hasOrderDetails = false;
  Map purchaseOrder = {};
  loadOrderDetails() async {
    var po = await fetchPO(widget.order['pk'].toString());
    if (po.isNotEmpty) {
      setState(() {
        purchaseOrder = po;
        hasOrderDetails = true;
      });
    } else {}
  }

  @override
  void initState() {
    initializeDateFormatting('es_MX', null);
    super.initState();
    loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Resumen del pedido #${widget.order['pk']}",
            style: subHeading1),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.call),
                  label:
                      Text('Llámanos si tienes dudas', style: subHeading2White),
                  style: TextButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.all(16),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 16,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Llamar al teléfono de atención

                    launchURL("tel://8110037915");
                  },
                )),
            const SizedBox(width: 10),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: const Icon(Icons.headphones, color: Colors.black),
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    side: const BorderSide(color: primaryClr),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("help");
                  },
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                            "${widget.order['product']['product_url_image']}"))),
                Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.order["product"]['product_name']}',
                              style: heading2Black),
                          Text(
                              '${widget.order["quantity"]} ${widget.order["product"]["unity_name"]}',
                              style: subHeading2),
                          Text(
                              '\$${(widget.order["total"] as double).toStringAsFixed(2)} MXN',
                              style: subHeading2),
                        ],
                      ),
                    )),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tu pedido será entregado el',
                                style: subHeading2Gray),
                            Text(
                                // dateFormatterHelper(
                                //     widget.order["delivery_date"]),
                                hasOrderDetails
                                    ? dateFormatterHelper(
                                        purchaseOrder['date_delivery'],
                                        purchaseOrder['order_details']['order']
                                            ['hour_delivery'])
                                    : "Cargando...",
                                style: subHeading1),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              // TODO: Lógica a rastreo
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsOrder(widget.order, purchaseOrder),
                                ),
                              );
                            },
                            child: Text('Rastrear', style: bodyLink))
                      ],
                    ),
                    CustomTimeline(
                        order: widget.order,
                        isCollapsed: true,
                        onCollapseToggle: () {})
                  ]),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: primaryClr, size: 28),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Dirección de entrega', style: subHeading1),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                        '${widget.order["address"]['location_name']}, ${widget.order["address"]['location_direction_line_1']}, ${widget.order["address"]['location_city']}, ${widget.order["address"]['location_state']}, MX',
                        style: body),
                  ],
                )),
            const SizedBox(height: 10),
            Text('Pedido número ${widget.order["pk"]}', style: subHeading2Gray),
          ],
        ),
      ),
    );
  }
}

String dateFormatterHelper(dateTime, time) {
  // return "${date.day}/${date.month}/${date.year}";
  DateTime date = DateFormat("yyyy-MM-dd").parse(dateTime);
  DateTime timeFormat = DateFormat('HH:mm').parse(time);
  String formatTime = DateFormat('HH:mm').format(timeFormat);

  int comparison = date.compareTo(DateTime.now());
  int dia = date.day;
  String mes = DateFormat("MMMM", 'es_MX').format(date).toString();

  if (comparison == 0) {
    return "$dia de $mes a las $formatTime hrs";
  } else {
    return "$dia de $mes a las $formatTime hrs";
  }
}
