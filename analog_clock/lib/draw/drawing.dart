import 'dart:math' as math;
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

const double pi = 3.1415926535897932;

const _space_ = null; //625.625;

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
///

const String colon = ":";
const String colonBlink = ":-blink";
const String degree = "°";
const String degreeBlink = "°-blink";

void registerDrawings() {
  Drawing.registerDrawing(" ", Drawing(1, [_space_]));
  Drawing.registerDrawing(colon,
      Drawing(2, [
        _space_, _space_, // Avoid formatting to preserve expressivity
        500.250, 750.500,
        0.250, 750.0,
        500.250, 750.500,
        0.250, 750.0,
        _space_, _space_,
      ]));
  Drawing.registerDrawing(colonBlink,
      Drawing(2, [
        _space_, _space_, // Avoid formatting to preserve expressivity
        435.315, 685.565,
        65.185, 815.935,
        435.315, 685.565,
        65.185, 815.935,
        _space_, _space_,
      ]));
  Drawing.registerDrawing(degree,
      Drawing(2, [
        _space_, _space_, // Avoid formatting to preserve expressivity
        500.250, 750.500,
        000.250, 750.000,
        _space_, _space_,
        _space_, _space_,
        _space_, _space_,
      ]));
  Drawing.registerDrawing(degreeBlink,
      Drawing(2, [
        _space_, _space_, // Avoid formatting to preserve expressivity
        560.190, 810.460,
        940.310, 690.060,
        _space_, _space_,
        _space_, _space_,
        _space_, _space_,
      ]));
  Drawing.registerDrawing("c",
      Drawing(3, [
        _space_, _space_, _space_, // Avoid formatting to preserve expressivity
        250.500, 750.250, 750.500,
        000.500, 500.250, 750.000,
        000.500, 000.500, _space_,
        000.500, 000.250, 750.500,
        000.250, 750.250, 000.750
      ]));
  Drawing.registerDrawing("f",
      Drawing(3, [
        _space_, _space_, _space_, // Avoid formatting to preserve expressivity
        500.250, 750.250, 750.500,
        000.500, 250.500, 750.000,
        000.500, 000.250, 750.500,
        000.500, 500.250, 750.000,
        000.250, 750.000, _space_
      ]));
  Drawing.registerDrawing(
      "-",
      Drawing(3, [
        _space_, _space_, _space_, // Avoid formatting to preserve expressivity
        _space_, _space_, _space_,
        500.250, 750.250, 750.500,
        000.250, 750.250, 000.750,
        _space_, _space_, _space_,
        _space_, _space_, _space_,
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
        500.250, 750.250, 750.500, // Avoid formatting to preserve expressivity
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
        500.0, 0.500, _space_,
        0.500, 0.250, 750.500,
        0.250, 750.500, 0.500,
        _space_, 0.500, 0.500,
        _space_, 0.250, 750.0,
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
      "cloudy",
      Drawing(12, [
        _space_, _space_, _space_, _space_, 625.250, 750.250, 750.250, 750.375, _space_, _space_, _space_, _space_,
        _space_, _space_, _space_, 125.500, _space_, _space_, _space_, _space_, 875.500, 625.250, 750.375, _space_,
        _space_, 625.250, 750.250, 750.375, _space_, _space_, _space_, _space_, 000.625, _space_, _space_, 875.500,
        125.500, _space_, _space_, _space_, 865.500, _space_, _space_, 125.125, _space_, _space_, _space_, 625.000,
        000.375, _space_, _space_, _space_, _space_, _space_, _space_, 625.000, 750.250, 750.250, 750.125, _space_,
        _space_, 875.250, 750.250, 750.250, 750.250, 750.250, 750.125, _space_, _space_, _space_, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "cloudy-blink",
      Drawing(12, [
        _space_, _space_, _space_, _space_, 685.250, 750.250, 750.250, 750.315, _space_, _space_, _space_, _space_,
        _space_, _space_, _space_, 65.500, _space_, _space_, _space_, _space_, 935.500, 685.190, 810.315, _space_,
        _space_, 685.250, 750.250, 750.315, _space_, _space_, _space_, _space_, 000.565, _space_, _space_, 935.460,
        065.560, _space_, _space_, _space_, 925.460, _space_, _space_, 185.185, _space_, _space_, _space_, 565.060,
        940.435, _space_, _space_, _space_, _space_, _space_, _space_, 565.060, 750.250, 750.250, 750.185, _space_,
        _space_, 815.250, 750.250, 750.250, 750.250, 750.250, 750.185, _space_, _space_, _space_, _space_, _space_,
      ]));

  Drawing.registerDrawing(
      "foggy",
      Drawing(12, [
        _space_, _space_, _space_, _space_, _space_, _space_, 625.250, 750.250, 375.750, _space_, _space_, _space_,
        _space_, _space_, _space_, 625.250, 750.375, 500.125, _space_, _space_, _space_, 500.875, _space_, _space_,
        _space_, _space_, 375.125, _space_, _space_, _space_, _space_, _space_, _space_, 625.000, _space_, _space_,
        _space_, _space_, _space_, 875.250, 750.250, 750.250, 750.250, 750.250, 750.125, _space_, _space_, _space_,
        _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, _space_, _space_,
        _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, _space_, _space_, _space_, _space_,
        _space_, _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.250, _space_, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "foggy-blink",
      Drawing(12, [
        _space_, _space_, _space_, _space_, _space_, _space_, 685.250, 750.250, 315.750, _space_, _space_, _space_,
        _space_, _space_, _space_, 685.250, 750.315, 560.065, _space_, _space_, _space_, 500.935, _space_, _space_,
        _space_, _space_, 440.060, _space_, _space_, _space_, _space_, _space_, _space_, 560.000, _space_, _space_,
        _space_, _space_, _space_, 815.250, 750.250, 750.250, 750.250, 750.250, 750.185, _space_, _space_, _space_,
        _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, _space_, _space_,
        _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, _space_, _space_, _space_, _space_,
        _space_, _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.250, _space_, _space_, _space_,
      ]));

  Drawing.registerDrawing(
      "rainy",
      Drawing(12, [
        _space_, _space_, _space_, _space_, 625.250, 750.250, 750.250, 750.375, _space_, _space_, _space_, _space_,
        _space_, _space_, _space_, 125.500, _space_, _space_, _space_, _space_, 875.500, 625.250, 750.375, _space_,
        _space_, 625.250, 750.250, 750.375, _space_, _space_, _space_, _space_, 000.625, _space_, _space_, 875.500,
        125.500, _space_, _space_, _space_, 865.500, _space_, _space_, 125.125, _space_, _space_, _space_, 625.000,
        000.375, _space_, _space_, _space_, _space_, _space_, _space_, 625.000, 750.250, 750.250, 750.125, _space_,
        _space_, 875.250, 750.250, 750.250, 750.250, 750.250, 750.125, 625.125, _space_, 625.125, _space_, _space_,
        _space_, _space_, 625.125, _space_, 625.125, _space_, 625.125, _space_, 625.125, _space_, _space_, _space_,
        _space_, _space_, _space_, 625.125, _space_, 625.125, _space_, _space_, _space_, _space_, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "rainy-blink",
      Drawing(12, [
        _space_, _space_, _space_, _space_, 685.250, 750.250, 750.250, 750.315, _space_, _space_, _space_, _space_,
        _space_, _space_, _space_, 065.500, _space_, _space_, _space_, _space_, 935.500, 685.250, 750.315, _space_,
        _space_, 685.250, 750.250, 750.315, _space_, _space_, _space_, _space_, 000.565, _space_, _space_, 935.500,
        125.500, _space_, _space_, _space_, 935.500, _space_, _space_, 185.185, _space_, _space_, _space_, 565.000,
        000.435, _space_, _space_, _space_, _space_, _space_, _space_, 565.000, 750.250, 750.250, 750.185, _space_,
        _space_, 815.250, 750.250, 750.250, 750.250, 750.250, 750.185, 625.125, _space_, 625.125, _space_, _space_,
        _space_, _space_, 625.125, _space_, 625.125, _space_, 625.125, _space_, 625.125, _space_, _space_, _space_,
        _space_, _space_, _space_, 625.125, _space_, 625.125, _space_, _space_, _space_, _space_, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "snowy",
      Drawing(7, [
        _space_, _space_, _space_, 815.185, _space_, _space_, _space_,
        _space_, 690.060, _space_, 000.500, _space_, 940.3100, _space_,
        _space_, _space_, 375.875, 000.500, 125.625, _space_, _space_,
        935.565, 750.250, 750.250, _space_, 750.250, 750.250, 065.435,
        _space_, _space_, 625.125, 000.500, 375.875, _space_, _space_,
        _space_, 440.810, _space_, 000.500, _space_, 190.560, _space_,
        _space_, _space_, _space_, 315.685, _space_, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "snowy-blink",
      Drawing(7, [
        _space_, _space_, _space_, 875.125, _space_, _space_, _space_,
        _space_, 750.000, _space_, 000.500, _space_, 000.250, _space_,
        _space_, _space_, 375.875, 000.500, 125.625, _space_, _space_,
        875.625, 750.250, 750.250, _space_, 750.250, 750.250, 125.375,
        _space_, _space_, 625.125, 000.500, 375.875, _space_, _space_,
        _space_, 500.750, _space_, 000.500, _space_, 250.500, _space_,
        _space_, _space_, _space_, 375.625, _space_, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "sunny",
      Drawing(6, [
        _space_, _space_, 500.435, 565.500, _space_, _space_,
        _space_, 875.875, 685.190, 810.315, 125.125, _space_,
        250.315, 065.560, _space_, _space_, 935.460, 685.750,
        195.250, 940.435, _space_, _space_, 565.060, 815.750,
        _space_, 625.625, 815.310, 690.185, 375.375, _space_,
        _space_, _space_, 000.065, 935.000, _space_, _space_,
      ]));
  Drawing.registerDrawing(
      "sunny-blink",
      Drawing(6, [
        _space_, _space_, 467.467, 532.532, _space_, _space_,
        _space_, 875.875, 625.250, 750.375, 125.125, _space_,
        282.282, 125.500, _space_, _space_, 875.500, 717.717,
        227.227, 000.375, _space_, _space_, 625.000, 782.782,
        _space_, 625.625, 875.250, 750.125, 375.375, _space_,
        _space_, _space_, 032.032, 967.967, _space_, _space_,
      ]));

  Drawing.registerDrawing(
      "thunderstorm",
      Drawing(11, [
        _space_, _space_, _space_, _space_, _space_, _space_, 625.250, 750.250, 750.250, 375.750, _space_,
        _space_, _space_, 625.250, 750.250, 750.375, 500.125, _space_, _space_, _space_, _space_, 500.875,
        _space_, 500.125, _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 000.500,
        _space_, 000.375, _space_, _space_, _space_, 625.250, 750.625, _space_, _space_, _space_, 625.000,
        _space_, 625.625, 875.250, 750.250, 125.625, 125.625, 750.250, 750.250, 750.250, 750.125, _space_,
        125.250, 750.625, _space_, 125.625, 125.250, 750.250, 750.625, _space_, 625.625, _space_, _space_,
        125.125, _space_, 125.250, 750.250, 750.625, 125.625, _space_, 125.250, 750.625, _space_, _space_,
        _space_, _space_, _space_, 125.625, 125.625, _space_, _space_, 125.125, _space_, _space_, _space_,
        _space_, _space_, 125.250, 125.750, _space_, _space_, _space_, _space_, _space_, _space_, _space_,
      ]));

  Drawing.registerDrawing(
      "thunderstorm-blink",
      Drawing(11, [
        _space_, _space_, _space_, _space_, _space_, _space_, 685.250, 750.250, 750.250, 315.750, _space_,
        _space_, _space_, 685.250, 750.250, 750.315, 500.065, _space_, _space_, _space_, _space_, 500.935,
        _space_, 500.065, _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 000.500,
        _space_, 000.435, _space_, _space_, _space_, 625.250, 750.625, _space_, _space_, _space_, 565.000,
        _space_, 625.625, 815.250, 750.250, 125.625, 125.625, 750.250, 750.250, 750.250, 750.185, _space_,
        125.250, 750.625, _space_, 125.625, 125.250, 750.250, 750.625, _space_, 625.625, _space_, _space_,
        125.125, _space_, 125.250, 750.250, 750.625, 125.625, _space_, 125.250, 750.625, _space_, _space_,
        _space_, _space_, _space_, 125.625, 125.625, _space_, _space_, 125.125, _space_, _space_, _space_,
        _space_, _space_, 125.250, 125.750, _space_, _space_, _space_, _space_, _space_, _space_, _space_,
      ]));

  Drawing.registerDrawing(
      "windy",
      Drawing(11, [
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, 625.250, 750.375, _space_, _space_,
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 750.375, 875.500, _space_,
        _space_, _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.125, 000.625, _space_,
        _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.125, _space_, _space_,
        750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, _space_,
        _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.375, _space_,
        _space_, _space_, _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.375, 875.500,
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 750.125, 000.625,
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 875.250, 750.125, _space_,
      ]));
  Drawing.registerDrawing(
      "windy-blink",
      Drawing(11, [
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, 685.250, 750.315, _space_, _space_,
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 750.375, 935.500, _space_,
        _space_, _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.125, 000.565, _space_,
        _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.185, _space_, _space_,
        750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, 750.250, _space_,
        _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.250, 750.250, 750.315, _space_,
        _space_, _space_, _space_, _space_, _space_, _space_, 750.250, 750.250, 750.250, 750.375, 935.500,
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 750.125, 000.565,
        _space_, _space_, _space_, _space_, _space_, _space_, _space_, _space_, 815.250, 750.185, _space_,
      ]));

}

class Drawing {
  final int width;
  final List<Angle> pixels;

  int get height => pixels.length ~/ width;

  static final _drawings = Map<String, Drawing>();

  Drawing(this.width, List<double> definition)
      : pixels = definition.map((value) {
        if (value != null) {
          var i = value.floor();
          var d = (value - i) * 1000;
          return Angle((i * 2 * math.pi / 1000), (d * 2 * math.pi / 1000));
        } else {
          return null;
        }
  }).toList();

  static void registerDrawing(String key, Drawing code) => _drawings[key] = code;

  static Drawing fromKey(String key) {
    var drawing = _drawings[key];
    if (drawing == null) {
      throw Exception("'$key' drawing is not registered");
    }
    return drawing;
  }

  static List<Drawing> fromTime(DateTime time, String timeFormatSeparator, bool is24Format) {
    String date = (is24Format ? DateFormat('kk:mm') : DateFormat('hh:mm')).format(time);
    var hm = date.split(":");
    return fromCharacters(hm[0])
      ..add(fromKey(timeFormatSeparator))
      ..addAll(fromCharacters(hm[1]));
  }

  static List<Drawing> fromTemperature(num temperature, String degreeKey, TemperatureUnit unit) {
    return fromCharacters("${temperature.round()}")
      ..add(fromKey(degreeKey))
      ..addAll(fromCharacters(unit == TemperatureUnit.celsius ? "c" : "f"));
  }

  static List<Drawing> fromCharacters(String characters) {
    return characters.codeUnits
        .map((codeUnit) => String.fromCharCode(codeUnit))
        .map((char) => Drawing.fromKey(char)).toList();
  }
}

class Angle {
  final double hoursAngle;
  final double minutesAngle;

  Angle(this.hoursAngle, this.minutesAngle);
}
