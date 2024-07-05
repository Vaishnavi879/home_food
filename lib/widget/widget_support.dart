import 'package:flutter/material.dart';

class AppWidget {

  static TextStyle BoldTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle HeadlineTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle LightTextFieldStyle() {
    return const TextStyle(
      color: Colors.black38,
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle SemiBoldTextFieldStyle() {
    return const TextStyle(
      color: Colors.black38,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }

}