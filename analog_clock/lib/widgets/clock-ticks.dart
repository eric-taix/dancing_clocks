import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClockTicks extends StatelessWidget {
  final Color color;

  ClockTicks({@required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _TicksPainter(color: color),
        ),
      ),
    );
  }
}

class _TicksPainter extends CustomPainter {
  final Color color;
  final _tickRadians = [
    0,
    pi / 4,
    2 * pi / 4,
    3 * pi / 4,
    4 * pi / 4,
    5 * pi / 4,
    6 * pi / 4,
    7 * pi / 4,
    2 * pi
  ];

  _TicksPainter({@required this.color}) : assert(color != null);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt;

    final center = (Offset.zero & size).center;
    final length = size.shortestSide * 0.5;

    for (int idx = 0; idx < _tickRadians.length; idx++) {
      final radian = _tickRadians[idx];
      final angle = radian - pi / 2.0;
      final origin = Offset(cos(angle), sin(angle)) * length;
      final dest =
          Offset(cos(angle), sin(angle)) * (idx % 2 == 0 ? 6 : 7) * length / 8;
      canvas.drawLine(center + origin, center + dest, linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
