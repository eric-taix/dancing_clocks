import 'dart:math';

final Random _random = Random(42);

class AngleDistributor {
  _Distributor _distributor;

  AngleDistributor({int width, int height}) {
    var divergenceFactor = (_random.nextInt(40) + 10) * (_random.nextBool() ? 1 : -1);
    var divergencePoint = Point(_random.nextDouble() * (width + 1), _random.nextDouble() * (height + 1));
    var distributorIndex = _random.nextInt(6);
    switch (distributorIndex) {
      case 0:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAxis(divergencePoint),
          horizontalAxisDivergenceEvaluator(divergencePoint),
          divergenceFactor,
        );
        print("Case 1");
        break;
      case 1:
        _distributor = _MirrorDistributor(
          angleFromVerticalAxis(divergencePoint),
          verticalAxisDivergenceEvaluator(divergencePoint),
          divergenceFactor,
        );
        print("Case 2");
        break;
      case 2:
        _distributor = MagneticDistributor(width, height, Magnet(width, height, _random.nextDouble()*2-1), dontChange());
        print("Case 3");
        break;
      case 3:
        _distributor = MagneticDistributor(width, height, Magnet(width, height, _random.nextDouble()*2-1), fixAngle(0));
        print("Case 4");
        break;
      default:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAndVerticalAxis(divergencePoint),
          centerDivergenceEvaluator(divergencePoint),
          divergenceFactor,
        );
        print("Case default");
        break;
    }
  }

  double getAngle(Point point, double originalAngle) => _distributor.getAngle(point, originalAngle);
}

Point _randomPoint(int width, int height) {
  return Point(_random.nextDouble() * (width + 1), _random.nextDouble() * (height + 1));
}

/// Utilities functions to compute mirroring
typedef int Mirror(int value);

Mirror noMirror = (value) => value;
Mirror verticalMirror = (value) => 500 - value;
Mirror horizontalMirror = (value) => 1000 - value;
Mirror horizontalAndVerticalMirror = (value) => horizontalMirror(verticalMirror(value));

/// Utilities functions to evaluate a distance
typedef double DivergenceEvaluator(Point point);

DivergenceEvaluator fixedDivergenceEvaluator(double divergence) => (Point point) => divergence;

DivergenceEvaluator horizontalAxisDivergenceEvaluator(Point center) => (Point point) => center.y - (point.y + 1);

DivergenceEvaluator verticalAxisDivergenceEvaluator(Point center) => (Point point) => center.x - (point.x + 1);

DivergenceEvaluator centerDivergenceEvaluator(Point center) => (Point point) {
      var r = sqrt(pow(point.x - (center.x), 2) + pow(point.y - (center.y), 2));
      return r;
    };

/// Utilities functions to compute a mirror angle regardless its position
typedef int ComputeAngleFromMirror(Point point, int value);

ComputeAngleFromMirror sameAngle() => (Point point, int value) => noMirror(value);

ComputeAngleFromMirror angleFromHorizontalAxis(Point center) =>
    (Point point, int value) => horizontalAxisDivergenceEvaluator(center)(point) < 0 ? verticalMirror(value) : value;

ComputeAngleFromMirror angleFromVerticalAxis(Point center) =>
    (Point point, int value) => verticalAxisDivergenceEvaluator(center)(point) < 0 ? horizontalMirror(value) : value;

ComputeAngleFromMirror angleFromHorizontalAndVerticalAxis(Point center) =>
    (Point point, int value) => angleFromVerticalAxis(center)(point, angleFromHorizontalAxis(center)(point, value));

/// Compute angles
abstract class _Distributor {
  double getAngle(Point point, double angle);
}

/// Compute angles with mirror
class _MirrorDistributor implements _Distributor {
  final ComputeAngleFromMirror _computeAngleFromMirror;
  final DivergenceEvaluator _divergenceEvaluator;
  final int _divergenceFactor;

  _MirrorDistributor(this._computeAngleFromMirror, this._divergenceEvaluator, this._divergenceFactor);

  @override
  double getAngle(Point point, double angle) {
    int integer = angle.floor();
    int decimal = ((angle - integer) * 1000).floor();

    var divergence = _divergenceEvaluator(point);
    integer = (integer + divergence * _divergenceFactor).floor();
    decimal = (decimal + divergence * _divergenceFactor).floor();

    integer = _computeAngleFromMirror(point, integer);
    decimal = _computeAngleFromMirror(point, decimal);
    return integer + (decimal / 1000);
  }
}


/// A magnet which attracts hands
class Magnet {
  Point _center;
  final double _strength;
  Point get center => _center;
  double get strength => _strength;

  Magnet(int width, int height, this._strength) {
    _center = _randomPoint(width, height);
    print("ste:$_strength");
  }
}

typedef double CalcDelta(double delta);

CalcDelta dontChange() => (delta) => delta;
CalcDelta minAngle(double angle) => (delta) => (delta < angle) ? delta = angle : delta;
CalcDelta fixAngle(double angle) => (delta) => angle;

class MagneticDistributor implements _Distributor {
  double _diagonal;
  final Magnet _magnet;
  final CalcDelta _calcDelta;

  MagneticDistributor(int width, int height, this._magnet, this._calcDelta) {
    _diagonal = max(width, height).floorToDouble();
  }

  @override
  double getAngle(Point<num> point, double angle) {
    int integer = _compute(false, point);
    int decimal = _compute(true, point);

    return integer + (decimal / 1000);
  }

  int _compute(bool minutes, Point point) {
    double dx = (point.x + 1) - _magnet.center.x;
    double dy = (point.y + 1) - _magnet.center.y;
    double radius = sqrt(pow(dx, 2) + pow(dy, 2));
    double x = dx / radius;
    double y = dy / radius;
    double angle = asin(x);
    if (dy > 0) {
      angle = 2 * pi - angle + pi;
    }
    double strength = 0.4;
    double delta = pi + (_magnet.strength+1) * (pi/2) - ((pi / 2) * radius / _diagonal);
    delta = _calcDelta(delta);
    angle += (minutes ? -delta : delta);

    return (angle * 1000 / (2 * pi)).round();
  }
}
