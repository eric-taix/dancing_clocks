import 'dart:math' as math;

const double pi = 3.1415926535897932;

const _space_ = 625.625;

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
void registerDrawings() {
  Drawing.registerDrawing(" ", Drawing(1, [625.625]));
  Drawing.registerDrawing(":",
      Drawing(2, [
        _space_, _space_, // Avoid formatting to preserve expressivity
        500.250, 750.500,
        0.250, 750.0,
        500.250, 750.500,
        0.250, 750.0,
        _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "0",
      Drawing(3, [
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
        0.500, 500.500, 0.500,
        0.500, 0.500, 0.500,
        0.500, 0.500, 0.500,
        0.500, 0.500, 0.500,
        0.250, 750.250, 750.0,
      ]));
  Drawing.registerDrawing(
      "1",
      Drawing(3, [
        _space_, 500.250, 750.500, // Avoid formatting to preserve expressivity
        _space_, 0.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.250, 750.0,
      ]));
  Drawing.registerDrawing(
      "2",
      Drawing(3, [
        500.250, 750.250, 750.500,// Avoid formatting to preserve expressivity
        0.250, 750.500, 0.500,
        500.250, 0.750, 0.500,
        0.500, 500.250, 0.750,
        0.500, 0.250, 750.500,
        0.250, 750.250, 750.0,
      ]));
  Drawing.registerDrawing(
      "3",
      Drawing(3, [
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
        0.250, 750.500, 0.500,
        500.250, 0.750, 0.500,
        0.250, 750.500, 0.500,
        500.250, 750.0, 0.500,
        0.250, 750.250, 0.750,
      ]));
  Drawing.registerDrawing(
      "4",
      Drawing(3, [
        500.250, 750.500, _space_, // Avoid formatting to preserve expressivity
        500.0, 0.500,  _space_,
        0.500, 0.250,  750.500,
        0.250, 750.500, 0.500,
        _space_,0.500, 0.500,
        _space_,0.250, 750.0,
      ]));
  Drawing.registerDrawing(
      "5",
      Drawing(3, [
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
        500.0, 500.250, 0.750,
        0.500, 0.250, 750.500,
        0.250, 750.500, 0.500,
        500.250, 750.0, 0.500,
        0.250, 750.250, 0.750
      ]));
  Drawing.registerDrawing(
      "6",
      Drawing(3, [
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
        500.0, 500.250, 0.750,
        0.500, 0.250, 750.500,
        0.500, 0.500, 0.500,
        0.500, 0.0, 0.500,
        0.250, 750.250, 0.750
      ]));
  Drawing.registerDrawing(
      "7",
      Drawing(3, [
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
        0.250, 750.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.250, 750.0
      ]));
  Drawing.registerDrawing(
      "8",
      Drawing(3, [
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
        0.500, 500.500, 0.500,
        0.375, 0.500, 0.625,
        125.500, 0.500, 875.500,
        0.500, 0.0, 0.500,
        0.250, 750.250, 750.0
      ]));
  Drawing.registerDrawing(
      "9",
      Drawing(3, [
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
        0.500, 500.500, 0.500,
        0.500, 0.500, 0.500,
        0.250, 750.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.250, 750.0
      ]));
  Drawing.registerDrawing(
      "cloud",
      Drawing(12, [
        _space_, _space_, _space_, _space_, 625.250, 750.250, 750.250, 750.375, _space_, _space_, _space_, _space_,
        _space_, _space_, _space_, 125.500, _space_, _space_, _space_, _space_, 875.500, 625.250, 750.375, _space_,
        _space_, 625.250, 750.250, 750.375, _space_, _space_, _space_, _space_, 000.625, _space_, _space_, 875.500,
        125.500, _space_, _space_, _space_, 865.500, _space_, _space_, 125.125, _space_, _space_, _space_, 625.000,
        000.375, _space_, _space_, _space_, _space_, _space_, _space_, 625.000, 750.250, 750.250, 750.125, _space_,
        _space_, 875.250, 750.250, 750.250, 750.250, 750.250, 750.125, _space_, _space_, _space_, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "sun",
      Drawing(6, [
        875.375, _space_, 500.435, 565.500, _space_, 625.125,
        _space_, 875.875, 625.250, 750.375, 125.125, _space_,
        250.315, 125.500, _space_, _space_, 875.500, 685.750,
        195.250, 000.375, _space_, _space_, 625.000, 815.750,
        _space_, 625.625, 875.250, 750.125, 375.375, _space_,
        625.125, _space_, 000.065, 935.000, _space_, 875.375,
      ]));
}

class Drawing {
  final int width;
  final List<Pixel> pixels;
  int get height => pixels.length ~/ width;

  static final _drawings = Map<String, Drawing>();

  Drawing(this.width, List<double> definition)
      : pixels = definition.map((value) {
          var i = value.floor();
          var d = (value - i) * 1000;
          return Pixel((i * 2 * math.pi / 1000), (d * 2 * math.pi / 1000));
        }).toList();

  static void registerDrawing(String name, Drawing code) => _drawings[name] = code;

  static Drawing fromName(String name) => _drawings[name];
}

class Pixel {
  final double hoursAngle;
  final double minutesAngle;

  Pixel(this.hoursAngle, this.minutesAngle);
}