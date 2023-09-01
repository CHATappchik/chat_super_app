import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.purple, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
  ),
);

void nextScreen (context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace (context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}
