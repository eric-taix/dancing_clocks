import 'dart:math' as math;

const double pi = 3.1415926535897932;

const _space = 625.625;

void registerCharacters() {
  CharacterCode.registerChar(
      "0",
      CharacterCode(3, [
        500.250, 250.750, 750.500, // Avoid formatting to preserve expressivity
        0.500, _space, 0.500,
        0.500, _space, 0.500,
        0.500, _space, 0.500,
        0.500, _space, 0.500,
        0.250, 750.250, 0.750
      ]));
  CharacterCode.registerChar(
      "1",
      CharacterCode(3, [
        _space, 625.125, _space, // Avoid formatting to preserve expressivity
        625.125, 0.500, _space,
        _space, 0.500, _space,
        _space, 0.500, _space,
        _space, 0.500, _space,
        750.250, 750.250, 750.250
      ]));
  CharacterCode.registerChar(
      "2",
      CharacterCode(3, [
        625.250, 750.250, 750.375, // Avoid formatting to preserve expressivity
        500.0, _space, 500.625,
        _space, 125.625, _space,
        125.500, _space, _space,
        0.500, _space, _space,
        0.375, 750.250, 750.125
      ]));
}

class CharacterCode {
  final int width;
  final List<ClockAngles> angles;

  static final _chars = Map<String, CharacterCode>();

  CharacterCode(this.width, List<double> definition)
      : angles = definition.map((value) {
          var i = value.floor();
          var d = (value - i) * 1000;
          return ClockAngles(i * math.pi / 1000, d * math.pi / 1000);
        }).toList();

  static void registerChar(String char, CharacterCode code) => _chars[char] = code;

  static CharacterCode char(String char) => _chars[char];
}

class ClockAngles {
  final double minutesAngles;
  final double hoursAngles;

  ClockAngles(this.minutesAngles, this.hoursAngles);
}
