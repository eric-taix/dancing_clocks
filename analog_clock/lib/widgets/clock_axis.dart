
import 'package:flutter/cupertino.dart';

import 'package:analog_clock/theming.dart';
import 'package:flutter/material.dart';

class ClockAxis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return Center(
      child: Container(
        width: 5,
        height: 5,
        decoration: new BoxDecoration(
          color: theming.backgroundColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

}