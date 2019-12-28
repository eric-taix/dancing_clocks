import 'dart:math' as math;

const double pi = 3.1415926535897932;

const _space = 625.625;


/// A character is defined by
/// - a width (number of clocks in the horizontal axis)
/// - an array of double
///
/// Each double encodes two angles (hours and minutes) and is expressed in thousandths of 2*PI:
/// the integer part for the first angle and the fractional part for the second angle.
///
/// The angles are computed in radian and start from the vertical top (0) and increase clockwise to 1000 (2 * PI)
///
/// Decimal cheat sheet:
/// 0:   top
/// 125: top right
/// 250: right
/// 375: bottom right
/// 500: bottom
/// 625: bottom left
/// 750: left
/// 875: top left
///
/// Note: you don't have, of course, to use these predefined values and define specific angles
///
/// Examples:
/// 500.250 defines hours at bottom and minutes at right (i.e. PI for hours and PI/2 for minutes)
/// 875.625 defines hours at top left and minutes at bottom left (i.e. 7*PI/8 for hours and 5*PI/4 for minutes)
///
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
