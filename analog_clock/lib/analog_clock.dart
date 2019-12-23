// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/hand.dart';
import 'package:analog_clock/hand_animation_controller.dart';
import 'package:analog_clock/landscape.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'clock.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

class MultiClocks extends StatefulWidget {
  const MultiClocks(this.model);

  final ClockModel model;

  @override
  _MultiClocksState createState() => _MultiClocksState();
}

class _MultiClocksState extends State<MultiClocks> with SingleTickerProviderStateMixin, LandscapeStatefulMixin {
  var _now = DateTime.now();
  Timer _timer;
  HandAnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new HandAnimationController(
      vsync: this,
      duration: new Duration(seconds: 5),
    )
    ..addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        animationController.notifyInnerStatusListeners(state);
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
