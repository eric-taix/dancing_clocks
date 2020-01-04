import 'dart:math' as math;
import 'package:analog_clock/animation/hand_animation_controller.dart';
import 'package:analog_clock/animation/screen.dart';
import 'package:analog_clock/tweens/drawing.dart';
import 'package:analog_clock/ui/animated_hand.dart';
import 'package:flutter/widgets.dart';

class ClockAnimationProvider {
  final int width;
  final int height;

  final ClockAnimationController animationController;

  final math.Random _random = math.Random();
  List<Screen> _screens;
  int _selector;

  ClockAnimationProvider(this.width, this.height, SingleTickerProviderStateMixin ticker)
      : animationController = new ClockAnimationController(
          vsync: ticker,
          duration: new Duration(seconds: 15),
        ) {
    _screens = List();
    animationController
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          next();
          animationController.notifyHandStatusListeners(state);
          animationController.reset();
          animationController.forward();
        }
      });
    next();
    animationController.forward();
  }

  @override
  void next() {
    _selector = _random.nextInt(20);
    _screens.clear();
    _screens.add(Screen(width, height, Drawing.fromCurrentTime()));
    _screens.add(Screen(width, height, [Drawing.fromName("cloud")]));
    _screens.add(Screen(width, height, [Drawing.fromName("sun")]));
  }

  Animation<double> getHandAnimation(Coordinates coord, double fromRadian) {
    if (_selector > 0) {
      var direction0 = _random.nextBool() ? 1 : -1;
      var angles0 = _screens[0].getPixelsAt(coord);
      var randomAngle0 = _random.nextInt(2) * 2 * math.pi;
      var end0 = (coord.coordType == CoordType.hours ? angles0.hoursAngle : angles0.minutesAngle) + randomAngle0 * direction0;
      var animation0 = Tween(begin: fromRadian, end: end0).chain(CurveTween(
        curve: Curves.easeInOut,
      ));

      var direction1 = _random.nextBool() ? 1 : -1;
      var angles1 = _screens[1].getPixelsAt(coord);
      var randomAngle1 = _random.nextInt(2) * 2 * math.pi;
      var end1 = (coord.coordType == CoordType.hours ? angles1.hoursAngle : angles1.minutesAngle) + randomAngle1 * direction1;
      var animation1 = Tween(begin: end0, end: end1).chain(CurveTween(
        curve: Curves.easeInOut,
      ));

      var direction2 = _random.nextBool() ? 1 : -1;
      var angles2 = _screens[2].getPixelsAt(coord);
      var randomAngle2 = _random.nextInt(2) * 2 * math.pi;
      var end2 = (coord.coordType == CoordType.hours ? angles2.hoursAngle : angles2.minutesAngle) + randomAngle2 * direction2;
      var animation2 = Tween(begin: end1, end: end2).chain(CurveTween(
        curve: Curves.easeInOut,
      ));

      return TweenSequence(
        [
          TweenSequenceItem(tween: animation0, weight: 50),
          TweenSequenceItem(tween: animation1, weight: 50),
          TweenSequenceItem(tween: animation2, weight: 50),
        ],
      ).animate(animationController);
    } else {
      var direction = _random.nextBool() ? 1 : -1;

      var randomAngle = (_random.nextDouble() * (3 * math.pi));
      var end = fromRadian + randomAngle * direction;
      return Tween(begin: fromRadian, end: end).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval(
            0,
            1,
            curve: Curves.easeInOut,
          )));
    }
  }
}
