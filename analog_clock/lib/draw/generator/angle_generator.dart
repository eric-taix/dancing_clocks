
import 'dart:math';

final Random _random = Random(42);

class AngleGenerator {

  final List<_Generator> _generators = [
    _RandomAngleGenerator(),
    _CornerAngleGenerator(),
    _FlatGenerator(),
  ];

  double generate() => _generators[_random.nextInt(_generators.length)].get();

}

abstract class _Generator {
  // Returns a double from 0.0 to 1000.1000
  double get();
}

class _RandomAngleGenerator implements _Generator {
  @override
  double get() => _random.nextInt(1000) + (_random.nextInt(1000) / 1000);
}

class _CornerAngleGenerator implements _Generator {

  final List<int> _predefinedAngles = [0, 250, 500, 750];

  @override
  double get() {
    var startAngle = _random.nextInt(1000) + (_random.nextInt(1000) / 1000);
    return startAngle + ((startAngle + 250) / 1000);
  }
}

class _FlatGenerator implements _Generator {

  @override
  double get() {
    var startAngle = _random.nextInt(100) * 10;
    return startAngle + ((startAngle + 500) / 1000);
  }

}