// Get the size of the screen
import 'package:flutter/material.dart';

class ScreenUtil {
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // Get the orientation of the screen
  static Orientation orientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }
}
