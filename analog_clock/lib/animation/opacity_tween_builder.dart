import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:flutter/animation.dart';

class OpacityTweenBuilder {
  final List<TweenSequenceItem<double>> _items = List();
  ClockAnimationController _animationController;
  double _start;

  OpacityTweenBuilder(this._start, this._animationController)
      : assert(_start != null);

  void addOpacityTween(double end, Duration duration) {
    assert(end != null);
    _items.add(TweenSequenceItem(
        tween: Tween(begin: _start, end: end).chain(CurveTween(
          curve: Curves.easeIn,
        )),
        weight: _duration2Weight(duration)));
    _start = end;
  }

  Animation<double> build() =>
      TweenSequence(_items).animate(_animationController);

  double _duration2Weight(Duration duration) =>
      (duration.inMilliseconds * 1000) /
      _animationController.duration.inMilliseconds;
}
