import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../hubkens/colors.dart';
import '../../hubkens/typography.dart';

class CustomTimeline extends StatelessWidget {
  const CustomTimeline({
    Key? key,
    required this.order,
    required this.isCollapsed,
    required this.onCollapseToggle,
  }) : super(key: key);

  static const List steps = [
    "Tu pedido se está procesando",
    "El conductor va rumbo a la planta",
    "El pedido está siendo cargado",
    "El conductor va en camino",
    "Tu pedido está llegando",
    "Pedido entregado"
  ];

  final Map order;
  final bool isCollapsed;
  final VoidCallback onCollapseToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCollapseToggle();
      },
      child: isCollapsed
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: FixedTimeline.tileBuilder(
                builder: TimelineTileBuilder(
                    itemCount: steps.length,
                    indicatorBuilder: (_, index) {
                      bool isActive =
                          index <= order['status']['order_status_id'] - 1;
                      return Indicator.dot(
                        color: isActive ? primaryClr : gray40,
                      );
                    },
                    startConnectorBuilder: (_, index) {
                      bool isActive =
                          index <= order['status']['order_status_id'] - 1;
                      return index > 0
                          ? Connector.solidLine(
                              color: isActive ? primaryClr : gray40,
                            )
                          : null;
                    },
                    endConnectorBuilder: (_, index) {
                      bool isActive =
                          index <= order['status']['order_status_id'] - 1;
                      bool isCurrent =
                          index == order['status']['order_status_id'] - 1;
                      return index < steps.length - 1
                          ? Connector.solidLine(
                              color: isActive ? primaryClr : gray40)
                          : null;
                    },
                    contentsBuilder: (context, index) {
                      bool isActive =
                          index <= order['status']['order_status_id'] - 1;
                      bool isCurrent =
                          index == order['status']['order_status_id'] - 1;

                      TextStyle textStyle = subHeading2Gray;

                      if (isActive) {
                        textStyle = bodyTextPrimaryStyle;
                      }
                      if (isCurrent) textStyle = subHeading1;
                      return TimelineTile(
                        node: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(steps[index], style: textStyle),
                        ),
                      );
                    }),
                theme: TimelineTheme.of(context).copyWith(
                  nodePosition: 0,
                ),
              ))
          : Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Timeline.tileBuilder(
                  builder: TimelineTileBuilder(
                      itemCount: 1,
                      indicatorBuilder: (_, index) => Indicator.dot(
                            color: primaryClr,
                          ),
                      contentsBuilder: (context, index) {
                        return TimelineTile(
                          node: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                steps[order['status']['order_status_id']],
                                style: subHeading1),
                          ),
                        );
                      }),
                  theme: TimelineTheme.of(context).copyWith(
                    nodePosition: 0,
                  ),
                ),
              ),
            ),
    );
  }
}
