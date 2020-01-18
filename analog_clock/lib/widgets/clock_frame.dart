import 'package:analog_clock/theming.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClockFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            decoration: new BoxDecoration(
              color: theming.backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                new CustomBoxShadow(
                  color: theming.shadowColor,
                  blurRadius: 2.0,
                  offset: new Offset(1.0, 1.0),
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                color: theming.backgroundColor,
                shape: BoxShape.circle,
              ),
            )),
      ),
    );
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
