import 'dart:async';

import 'package:analog_clock/animation/hand_animation_controller.dart';
import 'package:analog_clock/landscape.dart';
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
  var _now = DateTime.now();
  Timer _timer;
  HandAnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new HandAnimationController(
      vsync: this,
      duration: new Duration(seconds: 15),
    )
    ..addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        animationController.notifyHandStatusListeners(state);
        animationController.reset();
        animationController.forward();
      }
    });
    _updateTime();
    animationController.forward();
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
    print("Build analog_clock");

    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Center(
        child: GridView.count(
            crossAxisCount: 15,
            childAspectRatio: 1,
            shrinkWrap: true,
            children: List.generate(15*8, (index) {
              return Center(
                child: Clock(key: ValueKey("$index"), dateTime: _now, animationController: animationController)
              );
            }
          )
        ),
      ),
    );
  }
}
