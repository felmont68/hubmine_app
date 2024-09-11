import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/typography.dart';

import 'package:intl/date_symbol_data_local.dart';

class PreviewOrder extends StatefulWidget {
  final String? status;
  final String product;
  final String urlImage;
  final String order;
  final String fechaEntrega;
  const PreviewOrder(
      {Key? key,
      this.status,
      required this.product,
      required this.urlImage,
      required this.order,
      required this.fechaEntrega})
      : super(key: key);

  @override
  State<PreviewOrder> createState() => _PreviewOrderState();
}

class _PreviewOrderState extends State<PreviewOrder> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(imageUrl: widget.urlImage),
              ),
            )),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.product, style: subHeading1),
              Text(
                widget.status!,
                style: subHeading1Primary,
              ),
              // Text("Entrega ${widget.fechaEntrega}",
              //     //  ${DateFormat.MMMMd("es").format(DateTime.parse(orders[index]["delivery_date"])
              //     style: body),
              Text("Pedido #${widget.order}", style: bodyGray60),
            ],
          ),
        ),
        const Expanded(flex: 1, child: Icon(Icons.chevron_right)),
      ],
    );
  }
}
