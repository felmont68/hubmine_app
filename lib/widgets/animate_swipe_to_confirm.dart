import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/driver/services/driver_storage_services.dart';

class AnimatedSwipeToConfirm extends StatefulWidget {
  const AnimatedSwipeToConfirm({
    Key? key,
    this.height = 45,
    this.borderWidth = 3,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  final double? height;
  final double? borderWidth;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  _AnimatedSwipeToConfirmState createState() => _AnimatedSwipeToConfirmState();
}

class _AnimatedSwipeToConfirmState extends State<AnimatedSwipeToConfirm> {
  late double _maxWidth;
  late double _handleSize;
  double _dragValue = 0;
  double _dragWidth = 0;
  bool _confirmed = false;

  loadOnlineStatus() async {
    var isOnlineStatus = await DriverServiceStorage.getOnlineStatus();

    if (isOnlineStatus) {
      setState(() {
        _dragWidth = _maxWidth;
      });
      // print(_dragWidth);
    }
    setState(() {
      _confirmed = isOnlineStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    loadOnlineStatus();
  }

  @override
  Widget build(BuildContext context) {
    _handleSize = (widget.height! - (widget.borderWidth! * 2));
    return LayoutBuilder(builder: (context, constraint) {
      _maxWidth = constraint.maxWidth;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        decoration: BoxDecoration(
          color: _confirmed ? primaryClr : primaryLightClr,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: _confirmed ? primaryClr : primaryLightClr,
            width: widget.borderWidth!,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Text(
                  _confirmed ? "En línea" : "Off-line",
                  style: _confirmed ? swipeBtnSecondary : swipeBtnPrimary,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: _dragWidth <= _handleSize ? _handleSize : _dragWidth,
                child: Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    GestureDetector(
                      onVerticalDragUpdate: _onDragUpdate,
                      onVerticalDragEnd: _onDragEnd,
                      child: Container(
                        width: _handleSize,
                        height: _handleSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: _confirmed
                            ? const Icon(
                                Icons.time_to_leave_sharp,
                                color: primaryClr,
                                size: 30,
                              )
                            : const Icon(
                                Icons.power_off_outlined,
                                color: primaryClr,
                                size: 30,
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragValue = (details.globalPosition.dx) / _maxWidth;
      _dragWidth = _maxWidth * _dragValue;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragValue > .9) {
      _dragValue = 1;
    } else {
      _dragValue = 0;
    }

    setState(() {
      _dragWidth = _maxWidth * _dragValue;
      _confirmed = _dragValue == 1;
    });

    if (_dragValue == 1) {
      widget.onConfirm();
    } else {
      widget.onCancel();
    }
  }
}
