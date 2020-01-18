import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:analog_clock/animation/angle_tween_builder.dart';
import 'package:analog_clock/animation/clockwise_direction_tween.dart';
import 'package:analog_clock/animation/thickness_tween_builder.dart';
import 'package:analog_clock/draw/coordinates.dart';
import 'package:analog_clock/draw/generator/drawing_generator.dart';
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
          animationController.notifyHandStatusListeners(state);
          animationController.reset();
          animationController.forward();
        }
      });
    animationController.duration = _prepareNextCycle();
    animationController.forward();
  }

  Duration _prepareNextCycle() {
    var dancingDuration = Duration(milliseconds: 5000);
    var dancingPause = Duration(milliseconds: 0100);
    var dancingCount = 3;
    animationList = AnimationList(width, height);
    /*_buildTimeAnimation(
      Duration(seconds: 4),
      Duration(seconds: 4),
      2,
    );
    _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: dancingCount,
      pause: dancingPause,
    );
    _buildTemperatureAnimation(
      duration: Duration(seconds: 2),
      animationCount: 4,
    );
    _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: dancingCount,
      pause: dancingPause,
    );*/
    _buildWeatherAnimation(
      weatherName: model.weatherString,
      duration: Duration(seconds: 4),
      blinkDuration: Duration(seconds: 2),
      animationCount: 3,
    );

    /*_buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: dancingCount,
      pause: dancingPause,
    );*/
    return animationList.totalDuration;
  }

  HandAnimation getHandAnimation(Coordinates coord, double fromRadian, double fromOpacity) {
    var angleBuilder = AngleTweenBuilder(fromRadian, animationController);
    var thicknessBuilder = ThicknessTweenBuilder(fromOpacity, animationController);

    animationList.images.forEach((image) {
      var pixel = image.getPixelsAt(coord);
      var angle;
      if (pixel != null) {
        angle = coord.coordType == CoordType.hours ? pixel.hoursAngle : pixel.minutesAngle;
        thicknessBuilder.addThicknessTween(1.0, image.duration);
      } else {
        angle = 3.926990816987242;
        thicknessBuilder.addThicknessTween(0.15, image.duration);
      }
      angleBuilder.addAngleTween(angle, image.duration, direction: image.direction, pause: image.pause, curve: image.curve);
    });

    return HandAnimation(angleBuilder.build(), thicknessBuilder.build());
  }

  void _buildTimeAnimation(Duration duration, Duration blinkDuration, int animationCount) {
    var time = DateTime.now();
    List.generate(
        animationCount + 1,
        (index) => index % 2 == 0
            ? animationList.addImage(Drawing.fromTime(time, colon), index == 0 ? duration : blinkDuration)
            : animationList.addImage(Drawing.fromTime(time, colonBlink), blinkDuration));
    time = time.add(Duration(minutes: 1));
    List.generate(
        animationCount + 1,
        (index) => index % 2 == 0
            ? animationList.addImage(Drawing.fromTime(time, colonBlink), index == 0 ? duration : blinkDuration)
            : animationList.addImage(Drawing.fromTime(time, colon), blinkDuration));
  }

  void _buildWeatherAnimation({
    @required String weatherName,
    @required Duration duration,
    @required Duration blinkDuration,
    @required int animationCount,
  }) {
    for (int index = 0; index < animationCount; index++) {
      animationList.addImage([Drawing.fromKey("$weatherName-blink")], index == 0 ? duration : blinkDuration);
      animationList.addImage([Drawing.fromKey(weatherName)], index == 0 ? duration : blinkDuration);
    }
  }

  void _buildDancingAnimation({Duration duration, int dancingCount, Duration pause}) {
    for (int index = 0; index < dancingCount; index++) {
      animationList.addImage(
        [DrawingGenerator(width, height).generate()],
        duration,
        curve: Curves.easeInOut,
        direction: ClockWiseDirection.Shortest,
        pause: pause,
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

class HandAnimation {
  final Animation<double> angleAnimation;
  final Animation<double> thicknessAnimation;

  HandAnimation(this.angleAnimation, this.thicknessAnimation);
}
