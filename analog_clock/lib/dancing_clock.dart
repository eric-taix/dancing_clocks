import 'package:analog_clock/animation/clock_builder.dart';
import 'package:analog_clock/landscape.dart';
import 'package:analog_clock/animation/clock_animation_provider.dart';
import 'package:analog_clock/theming.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

class DancingClock extends StatefulWidget {
  final ClockModel model;

  const DancingClock(this.model);

  @override
  _DancingClockState createState() => _DancingClockState();
}

class _DancingClockState extends State<DancingClock>
    with SingleTickerProviderStateMixin, LandscapeStatefulMixin {
  static const columns = 15;
  static const rows = columns * 3 ~/ 5;

  ClockAnimationProvider _clockAnimationProvider;

  @override
  void initState() {
    super.initState();
    _clockAnimationProvider =
        ClockAnimationProvider(widget.model, columns, rows, this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());

    return Container(
      decoration: new BoxDecoration(color: Theming.of(context).backgroundColor),
      child: Semantics.fromProperties(
        properties: SemanticsProperties(
          label: 'Dancing clock with time $time',
          value: time,
        ),
        child: Center(
          child: ClockBuilder(
              columns, rows, widget.model, _clockAnimationProvider),
        ),
      ),
    );
  }
}
