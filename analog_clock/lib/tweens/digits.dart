const double pi = 3.1415926535897932;

const zero = """
         
 .--.--. 
 |     | 
 |  |  | 
 .  .  . 
 |  |  | 
 |  |  | 
 .  .  . 
 |  |  | 
 |  |  | 
 .  .  . 
 |  |  | 
 |  |  | 
 .  .  .          
 |  |  | 
 |     | 
 .--.--. 
         """;

const bigStar = r"""
\    /
 .  .
  \/
  /\
 .  .
/    \""";
const smallStar = r"""
      
 .  . 
  \/  
  /\  
 .  . 
      """;

const square = r"""
      
 .--. 
 |  | 
 |  | 
 .--. 
      """;

const diamon = r"""
  /\  
 .  . 
/    \
\    /
 .  . 
  \/  """;

void main() {
  print(bigStar);
  var clocksCodeUnits = prepare(smallStar);
}



List<List<int>> prepare(String definition) {
  // Split by lines
  var lines = smallStar.split("\n");
  // Compute the number of clocks per line
  int nbClocksPerLine = lines[0].length ~/ 3;
  // Align the number of character per line in case of missing characters
  lines = lines.map((s) => s.padRight(nbClocksPerLine * 3, " ")).toList();
  // Group / aggregate 3x3 characters to define a clock
  var points = List.generate(nbClocksPerLine * (lines.length ~/ 3), (int index) => "");
  for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
    for (var charIndex = 0; charIndex < lines[lineIndex].length; charIndex += 3) {
      var pointIndex = (lineIndex ~/ 3) * nbClocksPerLine + (charIndex ~/ 3);
      points[pointIndex] = points[pointIndex] + lines[lineIndex].substring(charIndex, charIndex + 3);
    }
  }
  // Compute
  points
    .map((point) => point.codeUnits)
    .map((codeUnits) {
      var clockTime = ClockTime();
      for (var idx = 0; idx < codeUnits.length; idx++) {
        clockTime.withAngle(codeUnitToAngle(codeUnits[idx], idx));
      }
      return clockTime;
    });
}

double codeUnitToAngle(int codeUnit, int index) {
  switch (codeUnit) {
    // '/' character
    case 47:
      return (1 + (index ~/ 4) * 4) * pi / 4;
    // '-' character
    case 45:
      return (2 + (index ~/ 4) * 4) * pi / 4;
    // '\' character
    case 92:
      return (3 + (index ~/ 4) * 4) * pi / 4;
    // '|' character
    case 124:
      return (4 + (index ~/ 4) * 4) * pi / 4;
    // Other characters
    default:
      return 0;
  }
}

class ClockTime {
  double _minutesAngle = 0;
  double _hoursAngle = 0;

  double get minutesAngle => _minutesAngle;

  double get hoursAngle => _hoursAngle != 0 ? _hoursAngle : _minutesAngle;

  ClockTime();

  void withAngle(double angle) {
    if (angle != 0) {
      if (_minutesAngle == 0) {
        _minutesAngle = angle;
      } else if (_hoursAngle == 0) {
        _hoursAngle = angle;
      }
    }
  }

  @override
  String toString() => "ClockTime{ h:$hoursAngle, m:$minutesAngle }";
}
