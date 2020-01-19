import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:analog_clock/animation/angle_tween_builder.dart';
import 'package:analog_clock/animation/clockwise_direction_tween.dart';
import 'package:analog_clock/animation/opacity_tween_builder.dart';
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

  ClockAnimationProvider(this.model, this.width, this.height,
      SingleTickerProviderStateMixin ticker)
      : animationController = new ClockAnimationController(
          vsync: ticker,
          duration: new Duration(seconds: 60),
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
    var dancingDuration = Duration(milliseconds: 4000);
    var dancingPause = Duration(milliseconds: 1000);
    var dancingCount = 2;
    animationList = AnimationList(width, height);
    _buildTimeAnimation(
      duration: Duration(milliseconds: 4000),
      blinkDuration: Duration(milliseconds: 2000),
      animationCount: 4,
    );
    _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: dancingCount,
      pause: dancingPause,
    );
    _buildTemperatureAnimation(
      duration: Duration(milliseconds: 4000),
      blinkDuration: Duration(milliseconds: 1000),
      animationCount: 2,
    );
    _buildWeatherAnimation(
      weatherName: model.weatherString,
      duration: Duration(milliseconds: 4000),
      blinkDuration: Duration(milliseconds: 1000),
      animationCount: 2,
    );
    _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: dancingCount,
      pause: dancingPause,
    );
    /*   _buildDancingAnimation(
      duration: dancingDuration,
      dancingCount: dancingCount,
      pause: dancingPause,
    );*/
    return animationList.totalDuration;
  }

  HandAnimation getHandAnimation(
      Coordinates coord, double fromRadian, double fromOpacity) {
    var angleBuilder = AngleTweenBuilder(fromRadian, animationController);
    var colorBuilder = OpacityTweenBuilder(fromOpacity, animationController);

    animationList.images.forEach((image) {
      var pixel = image.getPixelsAt(coord);
      var angle;
      if (pixel != null) {
        angle = coord.coordType == CoordType.hours
            ? pixel.hoursAngle
            : pixel.minutesAngle;
        colorBuilder.addOpacityTween(1.0, image.duration);
      } else {
        angle = 3.926990816987242;
        colorBuilder.addOpacityTween(0.25, image.duration);
      }
      angleBuilder.addAngleTween(angle, image.duration,
          direction: image.direction, pause: image.pause, curve: image.curve);
    });

    return HandAnimation(angleBuilder.build(), colorBuilder.build());
  }

  void _buildTimeAnimation({
    @required Duration duration,
    @required Duration blinkDuration,
    @required int animationCount,
  }) {
    var time = DateTime.now();
    List.generate(
        animationCount + 1,
        (index) => index % 2 == 0
            ? animationList.addImage(
                Drawing.fromTime(time, colon, model.is24HourFormat),
                index == 0 ? duration : blinkDuration)
            : animationList.addImage(
                Drawing.fromTime(time, colonBlink, model.is24HourFormat),
                blinkDuration));
  }

  void _buildWeatherAnimation({
    @required String weatherName,
    @required Duration duration,
    @required Duration blinkDuration,
    @required int animationCount,
  }) {
    for (int index = 0; index < animationCount; index++) {
      animationList.addImage([Drawing.fromKey("$weatherName-blink")],
          index == 0 ? duration : blinkDuration);
      animationList.addImage([Drawing.fromKey(weatherName)], blinkDuration);
    }
  }

  void _buildDancingAnimation({
    @required Duration duration,
    @required int dancingCount,
    @required Duration pause,
  }) {
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

  void _buildTemperatureAnimation({
    @required Duration duration,
    @required int animationCount,
    @required Duration blinkDuration,
  }) {
    for (int index = 0; index < animationCount; index++) {
      animationList.addImage(
          Drawing.fromTemperature(model.temperature, degree, model.unit),
          index == 0 ? duration : blinkDuration);
      animationList.addImage(
          Drawing.fromTemperature(model.temperature, degreeBlink, model.unit),
          blinkDuration);
    }
  }
}

class HandAnimation {
  final Animation<double> angleAnimation;
  final Animation<double> opacityAnimation;

  HandAnimation(this.angleAnimation, this.opacityAnimation);
}
