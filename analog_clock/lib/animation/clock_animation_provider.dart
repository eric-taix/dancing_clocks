import 'dart:math' as math;
import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:analog_clock/animation/clock_tween_builder.dart';
import 'package:analog_clock/animation/clockwise_direction_tween.dart';
import 'package:analog_clock/tweens/coordinates.dart';
import 'package:analog_clock/tweens/image.dart';
import 'package:analog_clock/tweens/drawing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';

class ClockAnimationProvider {
  final int width;
  final int height;
  final ClockModel model;
  final ClockAnimationController animationController;

  final math.Random _random = math.Random();
  List<ClockImage> _images;
  int _selector;

  ClockAnimationProvider(this.model, this.width, this.height, SingleTickerProviderStateMixin ticker)
      : animationController = new ClockAnimationController(
          vsync: ticker,
          duration: new Duration(seconds: 9),
        ) {
    _images = List();
    animationController
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          prepareNextCycle();
          animationController.notifyHandStatusListeners(state);
          animationController.reset();
          animationController.forward();
        }
      });
    prepareNextCycle();
    animationController.forward();
  }

  @override
  void prepareNextCycle() {
    _selector = _random.nextInt(20);
    _images.clear();
    _images.add(ClockImage(width, height, Duration(seconds: 1), Drawing.fromCurrentTime(colon)));
    _images.add(ClockImage(width, height, Duration(seconds: 1), Drawing.fromCurrentTime(colonBlink)));
    _images.add(ClockImage(width, height, Duration(seconds: 1), Drawing.fromCurrentTime(colon)));
    _images.add(ClockImage(width, height, Duration(seconds: 1), Drawing.fromCurrentTime(colonBlink)));
    _images.add(ClockImage(width, height, Duration(seconds: 5), [Drawing.fromKey(model.weatherString)]));
  }

  Animation<double> getHandAnimation(Coordinates coord, double fromRadian) {
    if (_selector > 0) {
      var builder = ClockTweenBuilder(fromRadian, animationController.duration);
      _images
          .map((screen) => AngleDuration._(
                coord.coordType == CoordType.hours ? screen.getPixelsAt(coord).hoursAngle : screen.getPixelsAt(coord).minutesAngle,
                screen.duration,
              ))
          .forEach((angleDuration) => builder.addTween(
                angleDuration.angle,
                angleDuration.duration,
                direction: ClockWiseDirection.Shortest,
              ));

      return builder.build(animationController);
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

class AngleDuration {
  final double angle;
  final Duration duration;

  AngleDuration._(this.angle, this.duration);
}
