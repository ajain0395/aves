import 'package:flutter/material.dart';

import 'enums.dart';

extension ExtraEntryBackground on EntryBackground {
  bool get isColor {
    switch (this) {
      case EntryBackground.black:
      case EntryBackground.white:
        return true;
      default:
        return false;
    }
  }

  Color get color {
    switch (this) {
      case EntryBackground.black:
        return Colors.black;
      case EntryBackground.white:
        return Colors.white;
      default:
        return null;
    }
  }
}
