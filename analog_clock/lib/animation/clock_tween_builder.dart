import 'package:analog_clock/animation/clock_animation_controller.dart';
import 'package:flutter/widgets.dart';

import 'clockwise_direction_tween.dart';

class ClockTweenBuilder {

  double _start;
  Duration _animationDuration;
  ClockTweenBuilder(this._start, this._animationDuration);

  final List<TweenSequenceItem<double>> _items = List();

  void addTween(double end, Duration duration, {ClockWiseDirection direction = ClockWiseDirection.Random, Curve curve = Curves.easeInOut}) {
    _items.add(TweenSequenceItem(tween: ClockwiseDirectionTween.from(
      _start,
      end,
      direction: direction,
    ).chain(CurveTween(
      curve: curve,
    )), weight: (duration.inSeconds * 1000) / _animationDuration.inSeconds));
    _start = end;
  }

  Animation<double> build(ClockAnimationController controller) => TweenSequence(_items).animate(controller);
}