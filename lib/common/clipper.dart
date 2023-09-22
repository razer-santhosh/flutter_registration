// ignore_for_file: annotate_overrides
import 'package:flutter/material.dart';

//Wave Shape for Add Course Page Custom Code Starts
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    final firstControlPoint = Offset(0, size.height - 80);
    final firstEndPoint = Offset(size.width / 2, size.height - 60);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    final secondControlPoint = Offset(size.width, firstEndPoint.dy);
    final secondEndPoint = Offset(size.width, size.height / 1.8);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
//Wave Shape for Add Course Page Custom Code Ends

//Profile Circle Shape Custom Code Starts
class MyClip extends CustomClipper<Rect> {
  MyClip();
  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width, size.height);
    final distanceToCorner = epicenter.dy;
    final radius = distanceToCorner;
    final diameter = radius;

    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}//Profile Circle Shape Custom Code Ends
