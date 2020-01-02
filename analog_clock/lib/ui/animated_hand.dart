import 'dart:math' as math;

import 'package:analog_clock/animation/hand_animation_controller.dart';
import 'package:analog_clock/theming.dart';
import 'package:analog_clock/tweens/drawing.dart';
import 'package:analog_clock/tweens/tween_provider.dart';
import 'package:flutter/cupertino.dart';

import 'drawn_hand.dart';

class AnimatedHand extends StatefulWidget {
  final HandAnimationController animationController;
  final double startAngle;
  final double size;
  final Coordinates id;
  final TweenProvider tweenProvider;

  AnimatedHand({Key key, @required this.id, @required this.animationController, @required this.tweenProvider, this.startAngle = 0, this.size = 1}) : super(key: key);

  @override
  _AnimatedHandState createState()  => _AnimatedHandState();
}

class _AnimatedHandState extends State<AnimatedHand> {
  Animation<double> angle;

  @override
  void initState() {
    _buildTween(widget.startAngle);
    widget.animationController.addHandStatusListener(statusChanged);
  }

  @override
  void dispose() {
    widget.animationController.removeHandStatusListener(statusChanged);
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
    
    angle = widget.tweenProvider.getAnimationForCoordinates(widget.id, currentRadian, widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return AnimatedBuilder(
      animation: widget.animationController,
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
  final int coordX;
  final int coordY;
  final CoordType coordType;
  Coordinates(this.coordX, this.coordY, this.coordType);

  @override
  String toString() => "Coord X:$coordX Y:$coordY";

}