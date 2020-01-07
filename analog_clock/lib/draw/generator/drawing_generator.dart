import 'dart:math';
import 'package:analog_clock/draw/drawing.dart';
import 'package:analog_clock/draw/generator/angle_distributor.dart';
import 'package:analog_clock/draw/generator/angle_generator.dart';

class DrawingGenerator {
  final int _width;
  final int _height;
  double _angle;
  AngleDistributor _distributor;

  DrawingGenerator(this._width, this._height) {
    _angle = AngleGenerator().generate();
    _distributor = AngleDistributor(_width, _height);
  }

  Drawing generate() {
    return Drawing(
        _width,
        List.generate(_width * _height, (index) {
          return _distributor.getMirroredFromAngle(Point(index % _width, index ~/ _width), _angle);
        }));
  }

  Drawing generateDivergedFromPrevious() {
    return Drawing(
        _width,
        List.generate(_width * _height, (index) {
          return _distributor.getDivergedFromAngle(Point(index % _width, index ~/ _width), _angle);
        }));
  }
}
