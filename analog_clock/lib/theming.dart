import 'dart:ui';
import 'package:flutter/material.dart';

enum _Element {
  handColor, 
  backgroundColor,
  counterShadow,
}

final _lightTheme = {
  _Element.handColor: Color(0xFF464c5e), //Color(0xFF231f20),
  _Element.backgroundColor: Color(0xFFFBFBFB),
  _Element.counterShadow: Colors.white

};

final _darkTheme = {
  _Element.handColor: Colors.white,//(0xFFfafafa),
  _Element.backgroundColor: Colors.black, //  (0xFF231f20)
};



class Theming {
  Map<_Element, Color> _colors;


  Color get handColor => _colors[_Element.handColor];
  Color get backgroundColor => _colors[_Element.backgroundColor];
  Color get counterShadow => _colors[_Element.counterShadow];

  Theming(this._colors);

  factory Theming.of(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Theming(_lightTheme) : Theming(_darkTheme);
}
