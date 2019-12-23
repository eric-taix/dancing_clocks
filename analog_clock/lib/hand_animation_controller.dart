import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

class HandAnimationController extends AnimationController {

  final _innerListeners = _InnerStatusListener();

  HandAnimationController({@required TickerProvider vsync, Duration duration}): super(vsync: vsync, duration: duration);

  void addInnerStatusListener(AnimationStatusListener listener) {
    _innerListeners.addStatusListener(listener);
  }

  void removeInnerStatusListener(AnimationStatusListener listener) {
    _innerListeners.removeStatusListener(listener);
  }

  void notifyInnerStatusListeners(AnimationStatus status) {
    _innerListeners.notifyStatusListeners(status);
  }

}

class _InnerStatusListener with AnimationEagerListenerMixin, AnimationLocalStatusListenersMixin {
}