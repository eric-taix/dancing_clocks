// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    @required Color shadowColor,
  })  : assert(color != null),
        assert(shadowColor != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          shadowColor: shadowColor,
          size: size,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            // Remove some margin to draw the shadow
            handSize: size - 0.25,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
            shadowColor: shadowColor,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  static const pi2 = math.pi / 2.0;

  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
    @required this.shadowColor,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(shadowColor != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;
  Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    var width = lineWidth;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    final center = (Offset.zero & size).center;
    final angle = angleRadians - pi2;
    final length = size.shortestSide * 0.5 * handSize;
    final dest = Offset(math.cos(angle), math.sin(angle)) * length;
    final position = center + dest;

    final centerShadow = center + Offset.zero;
    final positionShadow = centerShadow + dest;
    var path = Path()
      ..moveTo(centerShadow.dx, centerShadow.dy)
      ..lineTo(positionShadow.dx, positionShadow.dy)
      ..lineTo(positionShadow.dx, positionShadow.dy + width)
      ..lineTo(centerShadow.dx, centerShadow.dy + width)
      ..close();
    canvas.drawShadow(path, shadowColor, 5.0, true);
    canvas.drawLine(center, position, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    var result = oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
    return result;
  }
}
