// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ButtonAnimation extends StatefulWidget {
  final Color primaryColor;
  final Color darkPrimaryColor;

  const ButtonAnimation(this.primaryColor, this.darkPrimaryColor, {super.key});

  @override
  ButtonAnimationState createState() => ButtonAnimationState();
}

class ButtonAnimationState extends State<ButtonAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController scaleAnimationController;
  late AnimationController fadeAnimationController;

  late Animation<double> animation;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  double buttonWidth = 50.0;
  double scale = 1.0;
  bool animationComplete = false;
  double barColorOpacity = .6;
  bool animationStart = false;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    scaleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    fadeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    fadeAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(fadeAnimationController);

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(scaleAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          scaleAnimationController.reverse();
          fadeAnimationController.forward();
          animationController.forward();
        }
      });
    scaleAnimationController.forward();
    animation =
        Tween<double>(begin: 0.0, end: buttonWidth).animate(animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (mounted) {
                setState(() {
                  animationComplete = true;
                  barColorOpacity = .0;
                });
              }
            }
          });
  }

  @override
  void dispose() {
    animationController.dispose();
    fadeAnimationController.dispose();
    scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
            animation: scaleAnimationController,
            builder: (context, child) => Transform.scale(
                  scale: scaleAnimation.value,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: widget.primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: fadeAnimationController,
                          builder: (context, child) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: widget.darkPrimaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Align(
                                child: Icon(Icons.file_download_outlined)),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => Positioned(
            left: 0,
            top: 0,
            width: 40,
            height: animation.value,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: barColorOpacity,
              child: Container(
                decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
