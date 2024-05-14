
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppStyle {
  static ButtonStyle dashbordButton() {
    return ButtonStyle(
      // Blue background color
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(
        horizontal: 20,
      )), // Padding for the button
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Rectangular shape
        ),
      ),
    );
  }

  static TextStyle textWhiteColorHeader() {
    return const TextStyle(fontSize: 18, color: Colors.white);
  }

  static TextStyle textWhiteColor() {
    return const TextStyle(fontSize: 12, color: Colors.black);
  }
}
