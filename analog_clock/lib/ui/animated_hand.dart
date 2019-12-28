import 'dart:math' as math;

import 'package:analog_clock/animation/hand_animation_controller.dart';
import 'package:analog_clock/theming.dart';
import 'package:analog_clock/tweens/character_code.dart';
import 'package:flutter/cupertino.dart';

import 'drawn_hand.dart';

class AnimatedHand extends StatefulWidget {
  final HandAnimationController animationController;
  final double startAngle;
  final double size;

  AnimatedHand({Key key, @required this.animationController, this.startAngle = 0, this.size = 1}) : super(key: key);

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

  void _buildTween(double initialRadian) {
    while (initialRadian > 2 * math.pi) {
     initialRadian = initialRadian - 2 * math.pi;
    }
    while (initialRadian < -2 * math.pi) {
      initialRadian = initialRadian + 2 * math.pi;
    }
    var direction = math.Random().nextBool() ? 1 : -1;
    var end = initialRadian + (math.Random().nextDouble() * (4 * math.pi)) * direction;
    angle =
        Tween(begin: initialRadian, end: end)
            .animate(CurvedAnimation(
                parent: widget.animationController,
                curve: Interval(
                  0,
                  1,
                  curve: Curves.easeInOut,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget _widget) {
        return DrawnHand(color: theming.handColor, thickness: 9.0, size: widget.size, angleRadians: angle.value);
      },
    );
  }
}
