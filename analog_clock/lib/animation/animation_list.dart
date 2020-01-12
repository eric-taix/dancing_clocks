import 'package:analog_clock/draw/drawing.dart';
import 'package:analog_clock/draw/image.dart';
import 'package:flutter/animation.dart';

import 'clockwise_direction_tween.dart';


class AnimationList {
  final int _width;
  final int _height;
  final _images = List<ClockImage>();
  Duration _totalDuration = Duration();

  Duration get totalDuration => _totalDuration;
  List<ClockImage> get images => _images;

  AnimationList(this._width, this._height);

  void addImage(List<Drawing> drawings, Duration duration,
      {ClockWiseDirection direction = ClockWiseDirection.Shortest, Duration pause, Curve curve = Curves.easeInOut}) {
    _images.add(ClockImage(
      _width,
      _height,
      duration,
      direction,
      drawings,
      pause: pause,
      curve: curve,
    ));
    _totalDuration += duration;
    if (pause != null) {
      _totalDuration += pause;
    }
  }
}
