import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:flutter/widgets.dart';

import 'clockwise_direction_tween.dart';

class ClockTweenBuilder {
  double _start;
  Duration _cumulatedDuration = Duration(seconds: 0);
  Duration _animationDuration;

  ClockTweenBuilder(this._start, this._animationDuration);

  final List<TweenSequenceItem<double>> _items = List();

  void addTween(double end, Duration duration, {ClockWiseDirection direction = ClockWiseDirection.Random, Curve curve = Curves.easeInOut, Duration pause}) {
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
      _items.add(TweenSequenceItem(tween: ClockwiseDirectionTween.from(end, end, direction: ClockWiseDirection.DontChange), weight: _duration2Weight(pause)));
    }
    _start = end;
  }

  Animation<double> build(ClockAnimationController controller) {
    if (_cumulatedDuration < _animationDuration) {
      _items.add(TweenSequenceItem(
        tween: ClockwiseDirectionTween.from(_start, _start, direction: ClockWiseDirection.DontChange),
        weight: _duration2Weight(_animationDuration - _cumulatedDuration),
      ));
    }
    return TweenSequence(_items).animate(controller);
  }

  double _duration2Weight(Duration duration) => (duration.inSeconds * 1000) / _animationDuration.inSeconds;
}
