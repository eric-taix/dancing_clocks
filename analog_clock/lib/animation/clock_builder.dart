

import 'dart:math';

import 'package:analog_clock/animation/clock_animation_provider.dart';
import 'package:analog_clock/widgets/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clock_helper/model.dart';

class ClockBuilder extends StatelessWidget {
  
  final int columns;
  final int rows;
  final ClockModel model;
  final ClockAnimationProvider _clockAnimationProvider;

  ClockBuilder(this.columns, this.rows, this.model, this._clockAnimationProvider);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: columns,
        childAspectRatio: 1,
        shrinkWrap: true,
        children: List.generate(columns * rows, (index) {
          return Center(
              child: Clock(
                point: Point(index % columns, index ~/ columns),
                clockAnimationProvider: _clockAnimationProvider,
              ));
        }));
  }
  
}