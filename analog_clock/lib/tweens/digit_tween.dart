import 'package:analog_clock/tweens/digits.dart';
import 'package:flutter/widgets.dart';

class DigitTween extends Tween {
  DigitTween(double end, {double initialRadian, double direction, double speed})
      : super(begin: initialRadian, end: end);

  factory DigitTween.from(String char) {
    /*switch(char) {
      case '0': zero
    }*/
  }

  static List<ClockTween> buildFromDefinition(String definition) {
    //definition.codeUnits.setRange(start, end, iterable)


  }

}


class ClockTween {
  final DigitTween minutesTween;
  final DigitTween hoursTween;

  ClockTween(this.minutesTween, this.hoursTween);
}