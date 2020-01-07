
import 'dart:math';

enum CoordType {
  hours,
  minutes
}

class Coordinates {

  final Point point;
  final CoordType coordType;

  Coordinates(this.point, this.coordType);
  factory Coordinates.forHours(Point point) => Coordinates(point, CoordType.hours);
  factory Coordinates.forMinutes(Point point) => Coordinates(point, CoordType.minutes);

  @override
  String toString() => "Coord $point for $coordType";

}