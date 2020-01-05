
import 'package:flutter/cupertino.dart';

import 'package:analog_clock/theming.dart';

class ClockAxis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return Center(
      child: Container(
        width: 4,
        height: 4,
        decoration: new BoxDecoration(
          color: theming.backgroundColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

}