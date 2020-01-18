import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:flutter/animation.dart';

class ThicknessTweenBuilder {
  final List<TweenSequenceItem<double>> _items = List();
  ClockAnimationController _animationController;
  double _start;

  ThicknessTweenBuilder(this._start, this._animationController);

  void addThicknessTween(double thickness, Duration duration) {
    _items.add(TweenSequenceItem(
        tween: Tween(begin: _start, end: thickness).chain(CurveTween(
          curve: Curves.easeInCubic,
        )),
        weight: _duration2Weight(duration)));
    _start = thickness;
  }

  Animation<double> build() => TweenSequence(_items).animate(_animationController);

  double _duration2Weight(Duration duration) => (duration.inMilliseconds * 1000) / _animationController.duration.inMilliseconds;

}
