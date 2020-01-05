import 'dart:math';

import 'package:analog_clock/animation/clock_animation_provider.dart';
import 'package:analog_clock/tweens/coordinates.dart';
import 'package:analog_clock/widgets//animated_hand.dart';
import 'package:analog_clock/widgets/clock_axis.dart';
import 'package:analog_clock/widgets/clock_frame.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'package:analog_clock/theming.dart';

final _radiansPerMinute = radians(360 / 60);
final _radiansPerHour = radians(360 / 12);

// Start at 10:10 (i.e. '\/') which is, for watchmakers, the best time
// because it's like smiling to your customers
final _startHours = 10;
final _startMinutes = 10;

class Clock extends StatelessWidget {
  final Point point;
  final ClockAnimationProvider clockAnimationProvider;

  Clock({@required this.point, @required this.clockAnimationProvider});

  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return Container(
      color: theming.backgroundColor,
      child: Stack(
        children: [
          ClockFrame(),
          AnimatedHand(
            coordinate: Coordinates.forHours(point),
            clockAnimationProvider: clockAnimationProvider,
            startAngle: _startHours * _radiansPerHour + (_startMinutes / 60),
            size: 1.0,
          ),
          AnimatedHand(
            coordinate: Coordinates.forMinutes(point),
            clockAnimationProvider: clockAnimationProvider,
            startAngle: _startMinutes * _radiansPerMinute,
            size: 0.9,
          ),
          ClockAxis(),
        ],
      ),
    );
  }
}
