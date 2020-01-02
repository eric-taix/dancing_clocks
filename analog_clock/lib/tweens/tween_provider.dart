import 'dart:math' as math;
import 'package:analog_clock/animation/hand_animation_controller.dart';
import 'package:analog_clock/tweens/drawing.dart';
import 'package:analog_clock/ui/animated_hand.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

abstract class TweenProvider {
  void next();

  Animation<double> getAnimationForCoordinates(Coordinates coordinates, double initialRadian, HandAnimationController animationController);
}

class RandomTweenProvider extends TweenProvider {
  final int width;
  final int height;
  final math.Random _random = math.Random();
  List<List<Pixel>> _pixels;
  int _selector;

  RandomTweenProvider(this.width, this.height) {
    next();
  }

  @override
  void next() {
    _selector = _random.nextInt(20);
    _clear();
    var time = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(time);
    formattedDate = "67:09";
    List<Drawing> drawings =
        formattedDate.codeUnits.map((codeUnit) => String.fromCharCode(codeUnit)).map((char) => Drawing.fromName(char)).toList();
    drawings = [Drawing.fromName("sun")];
    var totalLength = drawings.fold(0, (acc, drawing) => acc + drawing.pixels.length);
    var drawingsWidth = drawings.fold(0, (acc, characterAngle) => acc + characterAngle.width);
    var drawingHeight = totalLength / drawingsWidth;

    var paddingX = (width - drawingsWidth) ~/ 2;
    var paddingY = (height - drawingHeight) ~/ 2;
    
    int drawingOffsetX = 0;
    drawings.forEach((drawing) {
        int x = 0;
        int y = 0;
        drawing.pixels.forEach((pixel) {
          _pixels[y + paddingY][x + paddingX + drawingOffsetX] = pixel;
          x++;
          if (x >= drawing.width) {
            x = 0;
            y++;
          }
        });
        drawingOffsetX = drawingOffsetX + drawing.width;
      });
  }

  void _clear() {
    _pixels = new List.generate(height, (_) => List.generate(width, (_) => Drawing.fromName(" ").pixels[0]));
  }

  Animation<double> getAnimationForCoordinates(Coordinates coord, double initialRadian, HandAnimationController animationController) {
    var direction = _random.nextBool() ? 1 : -1;
    if (_selector > 0) {
      var angles = _pixels[coord.coordY][coord.coordX];
      var randomAngle = _random.nextInt(2) * 2 * math.pi;
      var end = (coord.coordType == CoordType.hours ? angles.hoursAngle : angles.minutesAngle) + randomAngle * direction;
      return Tween(begin: initialRadian, end: end).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval(
            0,
            1,
            curve: Curves.easeInOut,
          )));
    } else {
      var randomAngle = (_random.nextDouble() * (3 * math.pi));
      var end = initialRadian + randomAngle * direction;
      return Tween(begin: initialRadian, end: end).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval(
            0,
            1,
            curve: Curves.easeInOut,
          )));
    }
  }
}
