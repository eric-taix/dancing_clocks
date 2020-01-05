import 'dart:math' as math;
import 'package:flutter/animation.dart';

class ClockwiseDirectionTween extends Tween<double> {
  factory ClockwiseDirectionTween.from(double begin, double end, {ClockWiseDirection direction = ClockWiseDirection.Random}) {
    
    var computedEnd = end;
    switch (direction) {
      case ClockWiseDirection.ClockWise:
        computedEnd = end > begin ? end : end + math.pi * 2;
        break;
      case ClockWiseDirection.CounterClockWise:
        computedEnd = end < begin ? end : end - math.pi * 2;
        break;
      case ClockWiseDirection.Random:
        computedEnd = math.Random().nextBool() ? end - math.pi * 2 : end + math.pi * 2;
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
