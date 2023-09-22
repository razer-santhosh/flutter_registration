// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

customTransitionPage(key, customChild) {
  return CustomTransitionPage(
    key: key,
    child: customChild,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Change the opacity of the screen using a Curve based on the the animation's
      // value
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.5, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

