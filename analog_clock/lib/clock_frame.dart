import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'theming.dart';

class ClockFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theming = Theming.of(context);
    return Container(
      width: 50,
      decoration: new BoxDecoration(
        color: Color(0xFFF5F5F5),
        shape: BoxShape.circle,
        boxShadow: [
          new CustomBoxShadow(
            color: Colors.black,
            blurRadius: 40.0,
            offset: new Offset(2.0, 3.0),
            blurStyle: BlurStyle.inner,
          ),
        ],
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
