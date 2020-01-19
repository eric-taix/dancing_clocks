import 'dart:math' as math;

import 'package:analog_clock/theming.dart';
import 'package:analog_clock/animation/clock_animation_provider.dart';
import 'package:analog_clock/draw/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'drawn_hand.dart';

class AnimatedHand extends StatefulWidget {
  final double startAngle;
  final double startOpacity;
  final double size;
  final Coordinates coordinate;
  final ClockAnimationProvider clockAnimationProvider;

  AnimatedHand(
      {@required this.coordinate,
      @required this.clockAnimationProvider,
      this.startAngle = 0,
      this.startOpacity = 1.0,
      this.size = 1});

  @override
  _AnimatedHandState createState() => _AnimatedHandState();
}

class _AnimatedHandState extends State<AnimatedHand> {
  HandAnimation animation;

  @override
  void initState() {
    super.initState();
    _buildTween(widget.startAngle, widget.startOpacity);
    widget.clockAnimationProvider.animationController
        .addHandStatusListener(statusChanged);
  }

  @override
  void dispose() {
    widget.clockAnimationProvider.animationController
        .removeHandStatusListener(statusChanged);
    super.dispose();
  }

  void statusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _buildTween(
          animation.angleAnimation.value, animation.opacityAnimation.value);
    }
  }

  void _buildTween(double currentRadian, double currentOpacity) {
    // Cap angle to 2 * PI for positive values
    while (currentRadian > 2 * math.pi) {
      currentRadian = currentRadian - 2 * math.pi;
    }
    // Cap angle to - 2 * PI for negative values
    while (currentRadian < -2 * math.pi) {
      currentRadian = currentRadian + 2 * math.pi;
    }

    animation = widget.clockAnimationProvider
        .getHandAnimation(widget.coordinate, currentRadian, currentOpacity);
  }

  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return AnimatedBuilder(
      animation: widget.clockAnimationProvider.animationController,
      builder: (BuildContext context, Widget _widget) {
        return Opacity(
            opacity: animation.opacityAnimation.value,
            child: DrawnHand(
              color: theming.handColor,
              shadowColor: theming.handShadowColor,
              thickness: 7.0,
              size: widget.size,
              angleRadians: animation.angleAnimation.value,
            ));
      },
    );
  }
}
