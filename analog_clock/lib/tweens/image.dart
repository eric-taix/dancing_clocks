
import 'dart:math' as math;

import 'package:analog_clock/tweens/coordinates.dart';
import 'package:analog_clock/tweens/drawing.dart';

class ClockImage {
  final int width;
  final int height;
  final Duration duration;
  List<List<Pixel>> _pixels;

  ClockImage(this.width, this.height, this.duration, List<Drawing> drawings, {math.Point<int> position}) {
    _clear();
    if (position == null) {
      position = _center(drawings);
    }
    int drawingOffsetX = 0;
    drawings.forEach((drawing) {
      int x = 0;
      int y = 0;
      drawing.pixels.forEach((pixel) {
        _pixels[y + position.y][x + position.x + drawingOffsetX] = pixel;
        x++;
        if (x >= drawing.width) {
          x = 0;
          y++;
        }
      });
      drawingOffsetX += drawing.width;
    });
  }

  void _clear() {
    _pixels = new List.generate(height, (_) =>
        List.generate(width, (_) =>
        Drawing
            .fromKey(" ")
            .pixels[0]));
  }

  math.Point<int> _center(List<Drawing> drawings) {
    var drawingsWidth = drawings.fold(0, (acc, characterAngle) => acc + characterAngle.width);
    var drawingHeight = drawings.fold(0, (acc, drawing) => drawing.height > acc ? drawing.height : acc);
    var paddingX = (width - drawingsWidth) ~/ 2;
    var paddingY = (height - drawingHeight) ~/ 2;
    return math.Point(paddingX, paddingY);
  }

  Pixel getPixelsAt(Coordinates coord) => _pixels[coord.point.y][coord.point.x];
}