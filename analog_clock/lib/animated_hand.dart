import 'dart:math' as math;

import 'package:analog_clock/hand_animation_controller.dart';
import 'package:analog_clock/tweens/hand_tween.dart';
import 'package:analog_clock/theming.dart';
import 'package:flutter/cupertino.dart';

import 'drawn_hand.dart';

class AnimatedHand extends StatefulWidget {
  final HandAnimationController _animationController;
  final double _startRadian;
  final double _size;
  final double _speed;

  AnimatedHand(Key key, this._animationController, this._startRadian, this._size, this._speed) : super(key: key);

  @override
  _AnimatedHandState createState()  => _AnimatedHandState();
}

class _AnimatedHandState extends State<AnimatedHand> {
  Animation<double> angle;

  @override
  void initState() {
    buildTween(widget._startRadian);
    widget._animationController.addInnerStatusListener(statusChanged);
  }

  @override
  void dispose() {
    widget._animationController.removeStatusListener(statusChanged);
  }

  void statusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      buildTween(angle.value);
    }
  }

  void buildTween(double initialRadian) {
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
                parent: widget._animationController,
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
      animation: widget._animationController,
      builder: (BuildContext context, Widget _widget) {
        return DrawnHand(color: theming.handColor, thickness: theming.handThickness, size: widget._size, angleRadians: angle.value);
      },
    );
  }
}
