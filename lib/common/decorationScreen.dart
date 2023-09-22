// ignore_for_file: file_names
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';

class DecorationScreen {
  decorationStyle(String labelNewText, Widget? newIcon,
      {EdgeInsets? pad, Widget? suffix,int? view}) {
    return InputDecoration(
      labelText: labelNewText,
      labelStyle: fontStyleLabel,
      floatingLabelStyle:
          MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        return states.contains(MaterialState.focused)
            ? TextStyle(
                fontSize: currentScreen == 'tab' ? 16 : 14,
                color: inputBoxFocusBorder)
            : fontStyleLabel;
      }),
      suffixIcon: suffix,
      prefixIcon: newIcon,
      border:view == 1?const OutlineInputBorder(
        borderSide: BorderSide.none
      ): const OutlineInputBorder(),
      counterText: '',
      contentPadding: pad ?? const EdgeInsets.all(6),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: inputBoxFocusBorder)),
      focusColor: inputBoxFocusBorder,
    );
  }

  decorationCourseStyle(String labelNewText, Widget? newIcon,
      [TextStyle? textStyle, hint, suffix]) {
    return InputDecoration(
        labelText: labelNewText,
        labelStyle: textStyle ?? fontStyleLabel,
        icon: newIcon,
        isDense: true,
        hintText: hint,
        suffixIcon: suffix,
        counterText: '',
        contentPadding: const EdgeInsets.all(6),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: inputBoxFocusBorder)),
        floatingLabelStyle:
            MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
          return states.contains(MaterialState.focused)
              ? const TextStyle(fontSize: 14, color: inputBoxFocusBorder)
              : const TextStyle(fontSize: 14);
        }),
        errorMaxLines: 3);
  }

  decorationWithFillColor(
      String labelNewText, Widget? newIcon, Color? fillColor) {
    return InputDecoration(
        labelText: labelNewText,
        labelStyle: fontStyleLabel,
        icon: newIcon,
        border: InputBorder.none,
        // fillColor: fillColor,
        // filled: true,
        isDense: true,
        counterText: '',
        contentPadding: const EdgeInsets.all(6),
        errorMaxLines: 2);
  }

  loginDecorationStyle(String labelNewText, Widget? newIcon, Widget? prefix) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(6),
      labelText: labelNewText,
      labelStyle: const TextStyle(fontSize: 14),
      floatingLabelStyle:
          MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        return states.contains(MaterialState.focused)
            ? const TextStyle(fontSize: 14, color: inputBoxFocusBorder)
            : const TextStyle(fontSize: 14);
      }),
      suffixIcon: newIcon,
      prefixIcon: prefix,
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: inputBoxFocusBorder)),
      focusColor: inputBoxFocusBorder,
      counterText: '',
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 14, color: color, fontFamily: fontFamily);
  }
}
