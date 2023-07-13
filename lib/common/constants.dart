import 'package:flutter/material.dart';

const appThemeColor = Color(0xFF4363b8);

const TextStyle headingText = TextStyle(
    decoration: TextDecoration.none,
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: Color(0xFF4363b8));

const TextStyle smallText = TextStyle(
    decoration: TextDecoration.none,
    color: Color(0xFF4363b8),
    fontWeight: FontWeight.w300,
    fontSize: 13);

const subTitle = TextStyle(
    decoration: TextDecoration.none,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black);

const normalText = TextStyle(
    decoration: TextDecoration.none,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black);

OutlineInputBorder commonInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(color: appThemeColor, width: 2),
);
