import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants.dart';

messageFlushBar(ctx, [String message = '', int duration = 2]) {
  Size size = MediaQuery.sizeOf(ctx);
  double width = size.width;
  double height = size.height;
  final snackBar = SnackBar(
    content: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            width: width * 0.04,
            height: height * 0.03,
            logo,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Text(message,
                softWrap: true,
                style: fontStyleSubNoDataFound.copyWith(fontSize: 14))),
      ],
    ),
    duration: Duration(seconds: message.length < 30 ? duration : 4),
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(8),
    margin: EdgeInsets.only(
        bottom: width * 0.1,
        left: message.length < 26 ? width * 0.15 : width * 0.05,
        right: message.length < 26 ? width * 0.15 : width * 0.05),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    backgroundColor: Colors.white,
  );
  //remove if any snackbar already showing
  ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
  return ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
}
