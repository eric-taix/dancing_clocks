import 'dart:math';

final Random _random = Random(42);

class AngleDistributor {
  _Distributor _distributor;

  AngleDistributor(int width, int height) {
    var increment = (_random.nextInt(40) + 10) * (_random.nextBool() ? 1 : -1);
    var r = _random.nextInt(4);
    r = 3;
    switch (r) {
      case 0:
        // No mirror
        _distributor = _MirrorDistributor(width, height, (value) => value, [(point, width, height) => -3], increment);
        break;
      case 1:
        // Vertical mirror
        _distributor = _MirrorDistributor(width, height, (value) => 500 - value, [
          (point, width, height) => (((height + 1) / 2) - point.y - 1),
          (point, width, height) => point.y + 1 > ((height + 1) / 2) ? (height - point.y).toDouble() : -(point.y + 1).toDouble(),
        ], increment);
        break;
      case 2:
        // Horizontal mirror
        _distributor = _MirrorDistributor(width, height, (value) => 1000 - value, [
          (point, width, height) => (((width + 1) / 2) - point.x - 1),
          (point, width, height) => point.x + 1 > ((width + 1) / 2) ? (width - point.x).toDouble() : -(point.x + 1).toDouble(),
        ], increment);
        break;
      default:
        // Quarter mirror
        _distributor = _CompositeMirrorDistributor(width, height, [
          _MirrorDistributor(width, height, (value) => value, [
            (point, width, height) => (((height + 1) / 2) - point.y - 1),
          ], increment),
          _MirrorDistributor(width, height, (value) => 500 - value, [
            (point, width, height) => (((height + 1) / 2) - point.y - 1),
          ], increment),
          _MirrorDistributor(width, height, (value) => 1000 - value, [
            (point, width, height) => (((width + 1) / 2) - point.x - 1),
          ], increment),
          _MirrorDistributor(width, height, (value) => 500 + value, [
            (point, width, height) => 0, //(((width + 1) / 2) - point.x - 1),
            (point, width, height) => 0
          ], increment),
        ], (point, width, height) {
          if (point.x + 1 <= width / 2) {
            return point.y + 1 <= height / 2 ? 0 : 1;
          } else {
            return point.y + 1 <= height / 2 ? 2 : 3;
          }
        });
        break;
    }
  }

  double generateFromAngle(Point point, double originalAngle) => _distributor.fromAngle(point, originalAngle);

  double generateFromPreviousAngle(Point point, double originalAngle) => _distributor.fromPreviousAngle(point, originalAngle);
}

abstract class _Distributor {
  double fromAngle(Point point, double angle);

  double fromPreviousAngle(Point point, double angle);
}

typedef int Calc(int value);
typedef double DistanceFromMirrorPoint(Point point, int width, int height);

class _MirrorDistributor implements _Distributor {
  final int _width;
  final int _height;
  final Calc _calc;
  final List<DistanceFromMirrorPoint> _distancesFromMirror;
  DistanceFromMirrorPoint _distanceFromMirror;

  final int _increment;

  _MirrorDistributor(this._width, this._height, this._calc, this._distancesFromMirror, this._increment) {
    _distanceFromMirror = _distancesFromMirror[_random.nextInt(_distancesFromMirror.length)];
  }

  @override
  double fromAngle(Point point, double angle) {
    if (_distanceFromMirror(point, _width, _height) < 0) {
      int integer = angle.floor();
      int decimal = ((angle - integer) * 1000).floor();
      integer = _calc(integer);
      decimal = _calc(decimal);
      return integer + (decimal / 1000);
    } else {
      return angle;
    }
  }

  @override
  double fromPreviousAngle(Point point, double previousAngle) {
    var angle = fromAngle(point, previousAngle);
    var distance = _distanceFromMirror(point, _width, _height);
    int integer = angle.floor();
    int decimal = ((angle - integer) * 1000).floor();
    return (integer + _increment * distance) + ((decimal - _increment * distance) / 1000);
  }
}

typedef int ChooseMirror(Point point, int width, int height);

class _CompositeMirrorDistributor implements _Distributor {
  final int _width;
  final int _height;
  final List<_MirrorDistributor> _mirrors;
  final ChooseMirror _chooseMirror;

  _CompositeMirrorDistributor(this._width, this._height, this._mirrors, this._chooseMirror);

  @override
  double fromAngle(Point<num> point, double angle) {
    int index = _chooseMirror(point, _width, _height);
    return _mirrors[index].fromAngle(point, angle);
  }

  @override
  double fromPreviousAngle(Point point, double angle) {
    int index = _chooseMirror(point, _width, _height);
    return _mirrors[index].fromPreviousAngle(point, angle);
  }
}
