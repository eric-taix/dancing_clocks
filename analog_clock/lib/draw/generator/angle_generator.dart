import 'dart:math';

final Random _random = Random(42);

class AngleGenerator {
  static final List<Generator> _generators = [
    RandomAngleGenerator(),
    CornerAngleGenerator(),
    FlatGenerator(),
  ];

  static double generate() =>
      _generators[_random.nextInt(_generators.length)].get();
}

abstract class Generator {
  // Returns a double from 0.0 to 1000.1000
  double get();
}

class RandomAngleGenerator implements Generator {
  @override
  double get() => _random.nextInt(1000) + (_random.nextInt(1000) / 1000);
}

class CornerAngleGenerator implements Generator {
  @override
  double get() {
    var startAngle = _random.nextInt(1000) + (_random.nextInt(1000) / 1000);
    return startAngle + ((startAngle + 250) / 1000);
  }
}

class FlatGenerator implements Generator {
  @override
  double get() {
    var startAngle = _random.nextInt(100) * 10;
    return startAngle + ((startAngle + 500) / 1000);
  }
}
