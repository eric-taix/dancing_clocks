import 'dart:ui';
import 'package:flutter/material.dart';

enum _Element {
  handColor, 
  backgroundColor,
  shadow,
  handShadow,
}

final _lightTheme = {
  _Element.handColor: Colors.black87, //Color(0xFF464c5e),
  _Element.backgroundColor: Color(0xFFFBFBFB),
  _Element.shadow: Color(0xFFA6AcBe),
  _Element.handShadow: Color(0xFF464c5e),
};

final _darkTheme = {
  _Element.handColor: Color(0xFF015597),
  _Element.backgroundColor: Colors.black87, //(0xFF202124),
  _Element.shadow: Color(0xFF015597),
  _Element.handShadow: Color(0xFF29B1F0)
};



class Theming {
  Map<_Element, Color> _colors;


  Color get handColor => _colors[_Element.handColor];
  Color get backgroundColor => _colors[_Element.backgroundColor];
  Color get shadowColor => _colors[_Element.shadow];
  Color get handShadowColor => _colors[_Element.handShadow];

  Theming(this._colors);

  factory Theming.of(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Theming(_lightTheme) : Theming(_darkTheme);
}
