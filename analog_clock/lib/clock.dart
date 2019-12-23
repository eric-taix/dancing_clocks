import 'package:analog_clock/animated_hand.dart';
import 'package:analog_clock/clock_frame.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'theming.dart';


final _radiansPerTick = radians(360 / 60);
final _radiansPerHour = radians(360 / 12);

class Clock extends StatelessWidget {

  final DateTime dateTime;
  final AnimationController animationController;

  Clock({Key key, this.dateTime, this.animationController}): super(key: key);

  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    var now = dateTime;
    return Container(
        color: theming.backgroundColor,
        child: Stack(
          children: [
            Center(
              child: ClockFrame(),
            ),
            AnimatedHand(ValueKey<String>(key.toString() + "_h"), animationController, now.hour * _radiansPerHour + (now.minute / 60), 1.0, 0.2),
            AnimatedHand(ValueKey<String>(key.toString() + "_m"), animationController, now.minute * _radiansPerTick, 0.9, 0.7),
            Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: new BoxDecoration(
                  color: theming.backgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
    );
  }
}
