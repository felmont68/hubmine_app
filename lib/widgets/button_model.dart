import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:mining_solutions/generated/l10n.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'dart:async';

class Button extends StatelessWidget {
  final Color? color;
  final Text? text;
  final double? width;
  final double? height;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  final icon;
  final suffixIcon;
  const Button(
      {Key? key,
      this.color,
      this.text,
      this.width,
      this.height,
      this.action,
      this.icon,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialButton(
        elevation: 0,
        onPressed: () {
          action();
        },
        color: color,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 1,
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon ?? Container(),
              text as Widget,
              suffixIcon ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonTransparent extends StatelessWidget {
  final Color? color;
  final Text? text;
  final double? width;
  final double? height;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  final icon;
  final suffixIcon;
  const ButtonTransparent(
      {Key? key,
      this.color,
      this.text,
      this.width,
      this.height,
      this.action,
      this.icon,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialButton(
        elevation: 0,
        onPressed: () {
          action();
        },
        color: color,
        shape: SmoothRectangleBorder(
          side: const BorderSide(
            color: primaryClr,
            width: 1,
          ),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 1,
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon ?? Container(),
              text as Widget,
              suffixIcon ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonCart extends StatelessWidget {
  final Color? color;
  final Text? text;
  final double? width;
  final double? height;
  final child;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  final icon;
  final suffixIcon;
  const ButtonCart(
      {Key? key,
      this.color,
      this.text,
      this.width,
      this.height,
      this.action,
      this.icon,
      this.suffixIcon,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: MaterialButton(
            elevation: 0,
            onPressed: () {
              action();
            },
            color: color,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 16,
                cornerSmoothing: 1,
              ),
            ),
            child: child));
  }
}

// TODO Refactor: Una sola clase para el button
class ButtonDisabled extends StatelessWidget {
  final Color? color;
  final Text? text;
  final double? width;
  final double? height;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  const ButtonDisabled({
    Key? key,
    this.color,
    this.text,
    this.width,
    this.height,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialButton(
        disabledColor: secondaryWhiteGreen,
        elevation: 0,
        onPressed: null,
        color: color,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 1,
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: text,
          ),
        ),
      ),
    );
  }
}

class TimerCountDownWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final onTimerFinish;

  const TimerCountDownWidget(
      {this.onTimerFinish, this.width, this.height, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimerCountDownWidgetState();
}

class TimerCountDownWidgetState extends State<TimerCountDownWidget> {
  late Timer _timer;
  int _countdownTime = 0;
  @override
  void initState() {
    if (_countdownTime == 0) {
      setState(() {
        _countdownTime = 10;
      });
      // Iniciar cuenta regresiva
      startCountdownTimer();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: MaterialButton(
      elevation: 0,
      onPressed: () {
        if (_countdownTime > 0) {
          null;
        } else if (_countdownTime == 0) {
          widget.onTimerFinish();
          setState(() {
            _countdownTime = 10;
          });
          // Iniciar cuenta regresiva
          startCountdownTimer();
        }
      },
      color: _countdownTime > 0 ? Colors.white38 : Colors.white,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 16,
          cornerSmoothing: 1,
        ),
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Text(
            _countdownTime > 0
                ? 'Solicita un nuevo código en $_countdownTime segundos'
                : AppLocalizations.of(context).resendVerificationCode,
            style: _countdownTime > 0
                ? subHeading2PrimaryClr
                : subHeading2PrimaryClr,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  void startCountdownTimer() {
//    const oneSec = const Duration(seconds: 1);
//    var callback = (timer) => {
//      setState(() {
//        if (_countdownTime < 1) {
//          widget.onTimerFinish();
//          _timer.cancel();
//        } else {
//          _countdownTime = _countdownTime - 1;
//        }
//      })
//    };
//
//    _timer = Timer.periodic(oneSec, callback);

    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_countdownTime < 1) {
                  _timer.cancel();
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

// Button Side Re-Design

class ButtonSide extends StatelessWidget {
  final Color? color;
  final Text? text;
  final double? width;
  final double? height;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  final icon;
  final side;
  const ButtonSide(
      {Key? key,
      this.color,
      this.text,
      this.width,
      this.height,
      this.action,
      this.icon,
      this.side})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialButton(
        elevation: 0,
        onPressed: () {
          action();
        },
        color: color,
        shape: SmoothRectangleBorder(
          side: const BorderSide(color: primaryClr),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 1,
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon ?? Container(),
              text as Widget,
            ],
          ),
        ),
      ),
    );
  }
}

class TimerTripDetails extends StatefulWidget {
  final double? width;
  final double? height;
  final onTimerFinish;

  // ignore: use_key_in_widget_constructors
  const TimerTripDetails({this.onTimerFinish, this.width, this.height})
      : super();

  @override
  State<StatefulWidget> createState() => TimerTripDetailsState();
}

class TimerTripDetailsState extends State<TimerTripDetails> {
  late Timer _timer;
  int _countdownTime = 0;
  @override
  void initState() {
    if (_countdownTime == 0) {
      setState(() {
        _countdownTime = 10;
      });
      // Iniciar cuenta regresiva
      startCountdownTimer();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: MaterialButton(
      elevation: 0,
      onPressed: () {
        if (_countdownTime > 0) {
          widget.onTimerFinish();
        } else if (_countdownTime == 0) {}
      },
      color: _countdownTime > 0 ? Colors.white38 : Colors.white,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 16,
          cornerSmoothing: 1,
        ),
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Text(
            _countdownTime > 0
                ? 'Ver detalles del viaje $_countdownTime'
                : AppLocalizations.of(context).resendVerificationCode,
            style: _countdownTime > 0
                ? subHeading2PrimaryClr
                : subHeading2PrimaryClr,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  void startCountdownTimer() {
//    const oneSec = const Duration(seconds: 1);
//    var callback = (timer) => {
//      setState(() {
//        if (_countdownTime < 1) {
//          widget.onTimerFinish();
//          _timer.cancel();
//        } else {
//          _countdownTime = _countdownTime - 1;
//        }
//      })
//    };
//
//    _timer = Timer.periodic(oneSec, callback);

    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_countdownTime < 1) {
                  _timer.cancel();
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
