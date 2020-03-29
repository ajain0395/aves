import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Constants {
  // as of Flutter v1.11.0, overflowing `Text` miscalculates height and some text (e.g. 'Å') is clipped
  // so we give it a `strutStyle` with a slightly larger height
  static const overflowStrutStyle = StrutStyle(height: 1.3);

  static const titleTextStyle = TextStyle(
    color: Color(0xFFEEEEEE),
    fontSize: 20,
    fontFamily: 'Concourse Caps',
    shadows: [
      Shadow(
        offset: Offset(0, 2),
        blurRadius: 3,
        color: Color(0xFF212121),
      ),
    ],
  );

  // TODO TLAD smarter sizing, but shouldn't only depend on `extent` so that it doesn't reload during gridview scaling
  static const double thumbnailCacheExtent = 50;

  static const svgBackground = Colors.white;
  static const svgColorFilter = ColorFilter.mode(svgBackground, BlendMode.dstOver);
}
