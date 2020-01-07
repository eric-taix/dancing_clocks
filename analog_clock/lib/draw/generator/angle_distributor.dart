import 'dart:math';

final Random _random = Random(42);

class AngleDistributor {
  _Distributor _distributor;

  AngleDistributor(int width, int height) {
    var _center = Point((width + 1) / 2, (height + 1) / 2);
    var divergenceFactor = (_random.nextInt(40) + 10) * (_random.nextBool() ? 1 : -1);
    var distributorIndex = _random.nextInt(8);
    switch (distributorIndex) {
      case 1:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAxis(_center.y),
          horizontalAxisDivergenceEvaluator(_center.y),
          divergenceFactor,
        );
        break;
      case 2:
        _distributor = _MirrorDistributor(
          angleFromVerticalAxis(_center.x),
          verticalAxisDivergenceEvaluator(_center.x),
          divergenceFactor,
        );
        break;
      case 3:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAndVerticalAxis(_center),
          centerDivergenceEvaluator(_center),
          divergenceFactor,
        );
        break;
      case 4:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAndVerticalAxis(Point(_center.x, height-1.toDouble())),
          centerDivergenceEvaluator(Point(_center.x, height-1.toDouble())),
          divergenceFactor,
        );
        break;
      case 5:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAndVerticalAxis(Point(_center.x, 0.toDouble())),
          centerDivergenceEvaluator(Point(_center.x, 0.toDouble())),
          divergenceFactor,
        );
        break;
      case 6:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAndVerticalAxis(Point(0.toDouble(), _center.y)),
          centerDivergenceEvaluator(Point(0.toDouble(), _center.y)),
          divergenceFactor,
        );
        break;
      case 7:
        _distributor = _MirrorDistributor(
          angleFromHorizontalAndVerticalAxis(Point(width-1.toDouble(), _center.y)),
          centerDivergenceEvaluator(Point(width-1.toDouble(), _center.y)),
          divergenceFactor,
        );
        break;
      default:
        _distributor = _MirrorDistributor(sameAngle(), fixedDivergenceEvaluator(3), divergenceFactor);
    }
  }

  double getMirroredFromAngle(Point point, double originalAngle) => _distributor.getMirroredFromAngle(point, originalAngle);

  double getDivergedFromAngle(Point point, double originalAngle) => _distributor.getDivergedFromAngle(point, originalAngle);
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

DivergenceEvaluator horizontalAxisDivergenceEvaluator(double axisY) => (Point point) => axisY - (point.y + 1);

DivergenceEvaluator verticalAxisDivergenceEvaluator(double axisX) => (Point point) => axisX - (point.x + 1);

DivergenceEvaluator centerDivergenceEvaluator(Point center) => (Point point) {
      var r = sqrt(pow(point.x - (center.x), 2) + pow(point.y - (center.y), 2));
      return r;
    };

/// Utilities functions to compute a mirror angle regardless its position
typedef int ComputeAngleFromMirror(Point point, int value);

ComputeAngleFromMirror sameAngle() => (Point point, int value) => noMirror(value);

ComputeAngleFromMirror angleFromHorizontalAxis(double axisY) =>
    (Point point, int value) => horizontalAxisDivergenceEvaluator(axisY)(point) < 0 ? verticalMirror(value) : value;

ComputeAngleFromMirror angleFromVerticalAxis(double axisX) =>
    (Point point, int value) => verticalAxisDivergenceEvaluator(axisX)(point) < 0 ? horizontalMirror(value) : value;

ComputeAngleFromMirror angleFromHorizontalAndVerticalAxis(Point axes) =>
    (Point point, int value) => angleFromVerticalAxis(axes.x)(point, angleFromHorizontalAxis(axes.y)(point, value));

/// C
abstract class _Distributor {
  double getMirroredFromAngle(Point point, double angle);

  double getDivergedFromAngle(Point point, double angle);
}

class _MirrorDistributor implements _Distributor {
  final ComputeAngleFromMirror _computeAngleFromMirror;
  final DivergenceEvaluator _divergenceEvaluator;
  final int _divergenceFactor;

  _MirrorDistributor(this._computeAngleFromMirror, this._divergenceEvaluator, this._divergenceFactor);

  @override
  double getMirroredFromAngle(Point point, double angle) {
    int integer = angle.floor();
    int decimal = ((angle - integer) * 1000).floor();
    integer = _computeAngleFromMirror(point, integer);
    decimal = _computeAngleFromMirror(point, decimal);
    return integer + (decimal / 1000);
  }

  @override
  double getDivergedFromAngle(Point point, double angle) {
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
