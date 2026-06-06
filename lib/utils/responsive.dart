import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get width => MediaQuery.sizeOf(context).width;
  double get height => MediaQuery.sizeOf(context).height;

  double horizontalPadding([double fraction = 0.064]) => width * fraction;

  double scale(double designValue) {
    const designWidth = 375.0;
    return designValue * (width / designWidth);
  }
}
