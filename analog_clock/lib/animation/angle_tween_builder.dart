import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:flutter/widgets.dart';

import 'clockwise_direction_tween.dart';

class AngleTweenBuilder {
  double _start;
  Duration _cumulatedDuration = Duration(seconds: 0);
  ClockAnimationController _animationController;

  AngleTweenBuilder(this._start, this._animationController);

  final List<TweenSequenceItem<double>> _items = List();

  void addAngleTween(double end, Duration duration,
      {ClockWiseDirection direction = ClockWiseDirection.Shortest,
      Curve curve = Curves.easeInOut,
      Duration pause}) {
    _cumulatedDuration += duration;
    _items.add(TweenSequenceItem(
        tween: ClockwiseDirectionTween.from(
          _start,
          end,
          direction: direction,
        ).chain(CurveTween(
          curve: curve,
        )),
        weight: _duration2Weight(duration)));

    if (pause != null) {
      _cumulatedDuration += pause;
      _items.add(TweenSequenceItem(
          tween: ClockwiseDirectionTween.from(end, end,
              direction: ClockWiseDirection.DontChange),
          weight: _duration2Weight(pause)));
    }
    _start = end;
  }

  Animation<double> build() {
    if (_cumulatedDuration < _animationController.duration) {
      _items.add(TweenSequenceItem(
        tween: ClockwiseDirectionTween.from(_start, _start,
            direction: ClockWiseDirection.DontChange),
        weight: _duration2Weight(
            _animationController.duration - _cumulatedDuration),
      ));
    }
    return TweenSequence(_items).animate(_animationController);
  }

  double _duration2Weight(Duration duration) =>
      (duration.inMilliseconds * 1000) /
      _animationController.duration.inMilliseconds;
}
