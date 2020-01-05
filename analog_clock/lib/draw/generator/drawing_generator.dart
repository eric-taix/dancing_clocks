
import 'dart:math';
import 'package:analog_clock/draw/drawing.dart';
import 'package:analog_clock/draw/generator/angle_distributor.dart';

class DrawingGenerator {
  final int _width;
  final int _height;

  DrawingGenerator(this._width, this._height);

  Drawing generate() {
    AngleDistributor distributor = AngleDistributor(_width, _height);
    return Drawing(_width, List.generate(_width * _height, (index) {
      return distributor.generate(Point(index % _width, index ~/ _width));
    }));
  }
}
