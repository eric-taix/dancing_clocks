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

  ClockAnimationProvider(this.model, this.width, this.height, SingleTickerProviderStateMixin ticker)
      : animationController = new ClockAnimationController(
          vsync: ticker,
          duration: new Duration(seconds: 4),
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
    _images.clear();
    /*   _images.addAll(_buildTimeAnimation(
      initialDuration: Duration(seconds: 6),
      blinkDuration: Duration(seconds: 10),
    ));*/
    // 12 seconds
    _images.addAll(_buildDancingAnimation(Duration(seconds: 3)));
   /* _images.addAll(_buildDancingAnimation(Duration(seconds: 3)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 3)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 3))); */
/*    _images.add(
      ClockImage(
        width,
        height,
        Duration(seconds: 5),
        ClockWiseDirection.Shortest,
        [Drawing.fromKey(model.weatherString)],
        pause: Duration(seconds: 2),
      ),
    );
    // 12 seconds
    _images.addAll(_buildDancingAnimation(Duration(seconds: 3)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 3)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 3)));
    _images.addAll(_buildDancingAnimation(Duration(seconds: 3))); */
  }

  Animation<double> getHandAnimation(Coordinates coord, double fromRadian) {
    var builder = ClockTweenBuilder(fromRadian, animationController.duration);
    _images.forEach((image) {
      var angle = coord.coordType == CoordType.hours ? image.getPixelsAt(coord).hoursAngle : image.getPixelsAt(coord).minutesAngle;
      return builder.addTween(angle, image.duration, direction: image.direction, pause: image.pause, curve: image.curve);
    });

    return builder.build(animationController);
  }

  List<ClockImage> _buildTimeAnimation({Duration initialDuration, Duration blinkDuration}) {
    var time = DateTime.now();
    return List.generate(
        blinkDuration.inSeconds,
        (index) => index % 2 == 0
            ? ClockImage(
                width,
                height,
                index == 0 ? initialDuration : Duration(seconds: 1),
                ClockWiseDirection.Shortest,
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
    var drawingGenerator = DrawingGenerator(width, height);
    return [
      ClockImage(width, height, duration, ClockWiseDirection.Shortest, [drawingGenerator.generate()], curve: Curves.easeInOut),
      ClockImage(width, height, duration, ClockWiseDirection.Shortest, [drawingGenerator.generateFromPrevious()], curve: Curves.easeInOut),
    ];
  }
}
