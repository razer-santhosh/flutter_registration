// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, sort_child_properties_last, file_names
import 'dart:math';
import 'package:flutter/material.dart';
import '../../common/theme.dart';
import '../../constants.dart';

//No Data Found Screen Starts
class NoDataFound extends StatefulWidget {
  //Constructor of No Data Found
  NoDataFound({
    this.title,
    this.subTitle,
    this.image,
    this.subtitleTextStyle,
    this.titleTextStyle,
    this.hideBackgroundAnimation = false,
  });

  final String? image;
  final String? subTitle;
  final TextStyle? subtitleTextStyle;
  final String? title;
  final TextStyle? titleTextStyle;
  final bool? hideBackgroundAnimation;

  @override
  State<StatefulWidget> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound>
    with TickerProviderStateMixin {
  //Variable Declaration Starts
  late AnimationController _backgroundController;
  late Animation _imageAnimation;
  AnimationController? _imageController;
  TextStyle? _subtitleTextStyle;
  TextStyle? _titleTextStyle;
  late AnimationController _widgetController;

  //Variable Declaration Ends

  //Initialize State Starts
  @override
  void initState() {
    _backgroundController = AnimationController(
        duration: const Duration(minutes: 1),
        vsync: this,
        lowerBound: 0,
        upperBound: 20)
      ..repeat();
    _widgetController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
        lowerBound: 0,
        upperBound: 1)
      ..forward();
    _imageController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _imageAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _imageController!, curve: Curves.linear),
    );
    setState(() {
      colorCode;
    });
    super.initState();
  }

  //Initialize State Ends

  //Dispose State Starts
  @override
  void dispose() {
    _backgroundController.dispose();
    _imageController!.dispose();
    _widgetController.dispose();
    super.dispose();
  }

//Dispose State Ends

//Animation Listener Starts
  animationListener() {
    if (_imageController == null) {
      return;
    }
    if (_imageController!.isCompleted) {
      setState(() {
        _imageController!.reverse();
      });
    } else {
      setState(() {
        _imageController!.forward();
      });
    }
  }

  //Animation Listener Ends

  //Image Widget Starts
  Widget _imageWidget() {
    return Expanded(
      flex: 3,
      child: AnimatedBuilder(
        animation: _imageAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(
                0,
                sin(_imageAnimation.value > .9
                    ? 1 - _imageAnimation.value
                    : _imageAnimation.value)),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            widget.image!,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
  //Image Widget Ends

  //Image Background circle Widget Starts
  Widget _imageBackground() {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      decoration: const BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(0, 0),
          color: colorCode,
        ),
        BoxShadow(
            blurRadius: 30,
            offset: Offset(20, 0),
            color: Color(0xffffffff),
            spreadRadius: -5),
      ], shape: BoxShape.circle),
    );
  }

  //Image Background circle Widget Ends

  //Animation Shell Widget Starts
  Widget _shell({Widget? child}) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxHeight > constraints.maxWidth) {
        return Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          height: constraints.maxWidth,
          width: constraints.maxWidth,
          child: child,
        );
      } else {
        return child!;
      }
    });
  }
  //Animation Shell Widget Ends

  //Animation Shell Child Widget Starts
  Widget _shellChild() {
    _titleTextStyle = widget.titleTextStyle ??
        Theme.of(context)
            .typography
            .dense
            .headlineSmall!
            .copyWith(color: noDataTitleShade);
    _subtitleTextStyle = widget.subtitleTextStyle ??
        Theme.of(context)
            .typography
            .dense
            .bodyLarge!
            .copyWith(color: noDataSubTitleShade);

    bool anyImageProvided = widget.image != null ? false : true;
    return FadeTransition(
      opacity: _widgetController,
      child: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!widget.hideBackgroundAnimation!)
              RotationTransition(
                child: _imageBackground(),
                turns: _backgroundController,
              ),
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: constraints.maxWidth,
                width: constraints.maxWidth - 30,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    anyImageProvided
                        ? const Center()
                        : Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                    anyImageProvided ? const Center() : _imageWidget(),
                    Column(
                      children: <Widget>[
                        if (widget.title != null)
                          Text(
                            widget.title.toString(),
                            style: _titleTextStyle,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        if (widget.title != null)
                          const SizedBox(
                            height: 10,
                          ),
                        if (widget.subTitle != null)
                          Text(widget.subTitle.toString(),
                              style: _subtitleTextStyle,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center)
                      ],
                    ),
                    anyImageProvided
                        ? const SizedBox()
                        : Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  //Animation Shell Child Widget Ends

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    return _shell(child: _shellChild());
  }

  //Main Widget Ends
}
//No Data Found Screen Ends