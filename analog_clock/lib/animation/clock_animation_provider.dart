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

import 'animation_list.dart';

class ClockAnimationProvider {
  final int width;
  final int height;
  final ClockModel model;
  final ClockAnimationController animationController;

  AnimationList animationList;

  ClockAnimationProvider(this.model, this.width, this.height, SingleTickerProviderStateMixin ticker)
      : animationController = new ClockAnimationController(
          vsync: ticker,
          duration: new Duration(seconds: 41),
        ) {
    animationController
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          animationController.duration = _prepareNextCycle();
          //animationController.duration = Duration(seconds: 4);
          animationController.notifyHandStatusListeners(state);
          animationController.reset();
          animationController.forward();
        }
      });
    animationController.duration = _prepareNextCycle();
    //animationController.duration = Duration(seconds: 4);
    animationController.forward();
  }

  Duration _prepareNextCycle() {
    var dancingDuration = Duration(milliseconds: 3000);

    animationList = AnimationList(width, height);
 /*    _buildTimeAnimation(
      duration: Duration(seconds: 2),
      animationCount: 4,
    );*/
    _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: 8,
    );
   /* _buildTemperatureAnimation(
      duration: Duration(seconds: 2),
      animationCount: 4,
    );
    _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: 8,
    );
    _buildWeatherAnimation(
      weatherName: model.weatherString,
      duration: Duration(seconds: 2),
      animationCount: 4,
    );
    _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: 8,
    );*/
    return animationList.totalDuration;
  }

  Animation<double> getHandAnimation(Coordinates coord, double fromRadian) {
    var builder = ClockTweenBuilder(fromRadian, animationController.duration);
    animationList.images.forEach((image) {
      var angle = coord.coordType == CoordType.hours ? image.getPixelsAt(coord).hoursAngle : image.getPixelsAt(coord).minutesAngle;
      return builder.addTween(angle, image.duration, direction: image.direction, pause: image.pause, curve: image.curve);
    });

    return builder.build(animationController);
  }

  void _buildTimeAnimation({Duration duration, int animationCount}) {
    var time = DateTime.now();
    List.generate(
        animationCount + 1,
        (index) => index % 2 == 0
            ? animationList.addImage(Drawing.fromTime(time, colon), index == 0 ? duration : Duration(seconds: 1))
            : animationList.addImage(Drawing.fromTime(time, colonBlink), Duration(seconds: 1)));
  }

  void _buildWeatherAnimation({String weatherName, Duration duration, int animationCount}) {
    for (int index = 0; index < animationCount; index++) {
      animationList.addImage([Drawing.fromKey(weatherName)], index == 0 ? duration : Duration(seconds: 1));
      animationList.addImage([Drawing.fromKey("$weatherName-blink")], index == 0 ? duration : Duration(seconds: 1));
    }
  }

  void _buildDancingAnimation({Duration duration, int dancingCount}) {
    for (int index = 0; index < dancingCount; index++) {
      animationList.addImage(
        [DrawingGenerator(width, height).generate()],
        duration,
        curve: Curves.easeInOut,
        direction: ClockWiseDirection.Shortest,
        pause: Duration(seconds: 1),
      );
    }
  }

  void _buildTemperatureAnimation({Duration duration, int animationCount}) {
    for (int index = 0; index < animationCount; index++) {
      animationList.addImage(Drawing.fromTemperature(model.temperature, degree, model.unit), index == 0 ? duration : Duration(seconds: 1));
      animationList.addImage(Drawing.fromTemperature(model.temperature, degreeBlink, model.unit), index == 0 ? duration : Duration(seconds: 1));
    }
  }
}
