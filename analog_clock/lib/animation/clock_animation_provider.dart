import 'dart:math' as math;
import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:analog_clock/animation/clock_tween_builder.dart';
import 'package:analog_clock/animation/clockwise_direction_tween.dart';
import 'package:analog_clock/draw/coordinates.dart';
import 'package:analog_clock/draw/generator/drawing_generator.dart';
import 'package:analog_clock/draw/image.dart';
import 'package:analog_clock/draw/drawing.dart';
import 'package:flutter/material.dart';
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
    duration: new Duration(seconds: 20),
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
    _selector = _random.nextInt(15);
    _images.clear();
  /*  _images.addAll(_buildTimeAnimation(
      initialDuration: Duration(seconds: 12),
      blinkDuration: Duration(seconds: 20),
    ));*/
    _images.addAll(_buildDancingAnimation(Duration(seconds: 5)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 5)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 5)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 5)));
/*    _images.add(
      ClockImage(
        width,
        height,
        Duration(seconds: 10),
        ClockWiseDirection.Random,
        [Drawing.fromKey(model.weatherString)],
        pause: Duration(seconds: 2),
      ),
    );*/
  }

  Animation<double> getHandAnimation(Coordinates coord, double fromRadian) {
    if (_selector > 0) {
      var builder = ClockTweenBuilder(fromRadian, animationController.duration);
      _images.forEach((screen) {
        var angle = coord.coordType == CoordType.hours ? screen
            .getPixelsAt(coord)
            .hoursAngle : screen
            .getPixelsAt(coord)
            .minutesAngle;
        return builder.addTween(angle, screen.duration, direction: screen.direction, pause: screen.pause);
      });

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

  List<ClockImage> _buildTimeAnimation({Duration initialDuration, Duration blinkDuration}) {
    var time = DateTime.now();
    return List.generate(
        blinkDuration.inSeconds,
            (index) =>
        index % 2 == 0
            ? ClockImage(
          width,
          height,
          index == 0 ? initialDuration : Duration(seconds: 1),
          index == 0 ? ClockWiseDirection.Random : ClockWiseDirection.Shortest,
          Drawing.fromTime(time, colon),
        )
            : ClockImage(
          width,
          height,
          Duration(seconds: 1),
          ClockWiseDirection.Shortest,
          Drawing.fromTime(time, colonBlink),
        ));
  }

  List<ClockImage> _buildDancingAnimation(Duration duration) {
    return [
      ClockImage(width, height, duration, ClockWiseDirection.Shortest,[DrawingGenerator(width, height).generate()])
    ];
  }
}
