import 'dart:math';

import 'package:analog_clock/draw/generator/angle_generator.dart';

final Random _random = Random(42);

class AngleDistributor {

  final int _width;
  final int _height;

  List<_Distributor> _distributors;

  AngleDistributor(this._width, this._height) {
    _distributors = [
    //  _MirrorDistributor(_width, _height, 0, (point, width, height) => false),
      _MirrorDistributor(_width, _height, 500, (point, width, height) => point.y + 1 > height / 2),
    //  _MirrorDistributor(_width, _height, 1000, (point, width, height) => point.x + 1 > width / 2),
    ];
  }

  double generate(Point point) => _distributors[_random.nextInt(_distributors.length)].get(point);
}

abstract class _Distributor {
  double get(Point point);
}

typedef bool IsMirrored(Point point, int width, int height);

class _MirrorDistributor extends _Distributor {

  final int _width;
  final int _height;
  final int _mirror;
  final IsMirrored _isMirrored;

  final double _angle = AngleGenerator().generate();

  _MirrorDistributor(this._width, this._height, this._mirror, this._isMirrored);

  @override
  double get(Point point) {
    if (_isMirrored(point, _width, _height)) {
      int integer = _angle.floor();
      int decimal = ((_angle - integer) * 1000).floor();
      integer = integer <= _mirror ? _mirror - integer : 1000 + (_mirror - integer);
      decimal = decimal <= _mirror ? _mirror - decimal : 1000 + (_mirror - decimal);
      return integer + (decimal / 1000);
    } else {
      return _angle;
    }
  }
}