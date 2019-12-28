import 'package:analog_clock/ui/animated_hand.dart';
import 'package:analog_clock/ui/clock_axis.dart';
import 'package:analog_clock/ui/clock_frame.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import '../theming.dart';

final _radiansPerTick = radians(360 / 60);
final _radiansPerHour = radians(360 / 12);

class Clock extends StatelessWidget {
  final DateTime dateTime;
  final AnimationController animationController;

  Clock({Key key, this.dateTime, @required this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return Container(
      color: theming.backgroundColor,
      child: Stack(
        children: [
          ClockFrame(),
          AnimatedHand(
            animationController: animationController,
            startAngle: dateTime.hour * _radiansPerHour + (dateTime.minute / 60),
            size: 1.0,
          ),
          AnimatedHand(
            animationController: animationController,
            startAngle: dateTime.minute * _radiansPerTick,
            size: 0.9,
          ),
          ClockAxis(),
        ],
      ),
    );
  }
}
