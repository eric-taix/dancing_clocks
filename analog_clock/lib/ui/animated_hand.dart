import 'dart:math' as math;
import 'dart:math';

import 'package:analog_clock/animation/hand_animation_controller.dart';
import 'package:analog_clock/theming.dart';
import 'package:analog_clock/tweens/drawing.dart';
import 'package:analog_clock/tweens/clock_animation_provider.dart';
import 'package:flutter/cupertino.dart';

import 'drawn_hand.dart';

class AnimatedHand extends StatefulWidget {
  final double startAngle;
  final double size;
  final Coordinates coordinate;
  final ClockAnimationProvider clockAnimationProvider;

  AnimatedHand({@required this.coordinate, @required this.clockAnimationProvider, this.startAngle = 0, this.size = 1});

  @override
  _AnimatedHandState createState()  => _AnimatedHandState();
}

class _AnimatedHandState extends State<AnimatedHand> {
  Animation<double> angle;

  @override
  void initState() {
    _buildTween(widget.startAngle);
    widget.clockAnimationProvider.animationController.addHandStatusListener(statusChanged);
  }

  @override
  void dispose() {
    widget.clockAnimationProvider.animationController.removeHandStatusListener(statusChanged);
  }

  void statusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _buildTween(angle.value);
    }
  }

  void _buildTween(double currentRadian) {
    // Cap angle to 2 * PI for positive values
    while (currentRadian > 2 * math.pi) {
     currentRadian = currentRadian - 2 * math.pi;
    }
    // Cap angle to - 2 * PI for negative values
    while (currentRadian < -2 * math.pi) {
      currentRadian = currentRadian + 2 * math.pi;
    }
    
    angle = widget.clockAnimationProvider.getHandAnimation(widget.coordinate, currentRadian);
  }

  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return AnimatedBuilder(
      animation: widget.clockAnimationProvider.animationController,
      builder: (BuildContext context, Widget _widget) {
        return DrawnHand(color: theming.handColor, thickness: 7.0, size: widget.size, angleRadians: angle.value);
      },
    );
  }
}

enum CoordType {
  hours,
  minutes
}

class Coordinates {
  final Point point;
  final CoordType coordType;
  Coordinates(this.point, this.coordType);
  factory Coordinates.forHours(Point point) => Coordinates(point, CoordType.hours);
  factory Coordinates.forMinutes(Point point) => Coordinates(point, CoordType.minutes);
  
  @override
  String toString() => "Coord $point for $coordType";

}