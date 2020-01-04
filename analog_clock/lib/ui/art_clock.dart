import 'dart:async';
import 'dart:math';

import 'package:analog_clock/animation/hand_animation_controller.dart';
import 'package:analog_clock/landscape.dart';
import 'package:analog_clock/tweens/clock_animation_provider.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

import 'clock.dart';

class ArtClock extends StatefulWidget {
  final ClockModel model;

  const ArtClock(this.model);

  @override
  _ArtClockState createState() => _ArtClockState();
}

class _ArtClockState extends State<ArtClock> with SingleTickerProviderStateMixin, LandscapeStatefulMixin {
  static const columns = 14;
  static const rows = columns * 3 ~/ 5;

  ClockAnimationProvider _clockAnimationProvider;

  var _now = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockAnimationProvider = ClockAnimationProvider(columns, rows, this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      print('Update time');
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
            () {
          //_updateTime;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Art clock with time $time',
        value: time,
      ),
      child: Center(
        child: GridView.count(
            crossAxisCount: columns,
            childAspectRatio: 1,
            shrinkWrap: true,
            children: List.generate(columns * rows, (index) {
              return Center(
                  child: Clock(
                    point: Point(index % columns, index ~/ columns),
                    clockAnimationProvider: _clockAnimationProvider,
                  ));
            })),
      ),
    );
  }
}
