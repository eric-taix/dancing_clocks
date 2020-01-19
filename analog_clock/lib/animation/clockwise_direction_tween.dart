import 'dart:math' as math;
import 'package:flutter/animation.dart';

class ClockwiseDirectionTween extends Tween<double> {

  static final math.Random _random = math.Random(42);

  factory ClockwiseDirectionTween.from(double begin, double end, {ClockWiseDirection direction = ClockWiseDirection.Random}) {
    while (begin > 2 * math.pi) {
      begin -= 2 * math.pi;
    }
    while (end > 2 * math.pi) {
      end -= 2 * math.pi;
    }
    var computedEnd = end;
    switch (direction) {
      case ClockWiseDirection.ClockWise:
        computedEnd = end > begin ? end : end + math.pi * 2;
        break;
      case ClockWiseDirection.CounterClockWise:
        computedEnd = end < begin ? end : end - math.pi * 2;
        break;
      case ClockWiseDirection.Random:
        computedEnd = _random.nextBool() ? end : end + math.pi * 2;
        break;
      case ClockWiseDirection.DontChange:
        computedEnd = end;
        break;
      case ClockWiseDirection.Shortest:
        if (end == begin || (end - begin).abs() <= math.pi) {
          computedEnd = end;
        } else {
          computedEnd = end < begin ? end + math.pi * 2 : end - math.pi * 2;
        }
    }
    return ClockwiseDirectionTween._(begin, computedEnd);
  }

  ClockwiseDirectionTween._(double begin, double end) : super(begin: begin, end: end);
}

enum ClockWiseDirection {
  ClockWise, // Always clockwise regardless of values
  CounterClockWise, // Always counterclockwise regardless of value
  Random, // Really random regardless of values
  DontChange, // Let values choose the direction: end>begin then clockwise otherwise counterclockwise
  Shortest, // Find the shortest direction
}
