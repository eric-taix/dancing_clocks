import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

/// A specific AnimationController with hand listeners to be able
/// to update the status in AnimatedHand before the controller's value
/// has been updated with stop, reset, forward, ...
class ClockAnimationController extends AnimationController {
  final _handStatusListeners = _InnerStatusListener();

  ClockAnimationController({@required TickerProvider vsync, Duration duration})
      : super(vsync: vsync, duration: duration);

  void addHandStatusListener(AnimationStatusListener listener) {
    _handStatusListeners.addStatusListener(listener);
  }

  void removeHandStatusListener(AnimationStatusListener listener) {
    _handStatusListeners.removeStatusListener(listener);
  }

  void notifyHandStatusListeners(AnimationStatus status) {
    _handStatusListeners.notifyStatusListeners(status);
  }
}

class _InnerStatusListener
    with AnimationEagerListenerMixin, AnimationLocalStatusListenersMixin {}
