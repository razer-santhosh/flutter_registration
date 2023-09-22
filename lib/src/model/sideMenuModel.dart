// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../constants.dart';

//SideMenu Model Item Model Starts
class SideMenuItem {
  final IconData icon;
  final String label;

  const SideMenuItem({
    required this.icon,
    required this.label,
  });
}
//SideMenu Model Item Model Ends

//SideMenu Toggler Model Starts
class SideMenuToggler {
  final IconData expandIcon;
  final IconData shrinkIcon;
  final VoidCallback? onToggle;

  const SideMenuToggler(
      {this.expandIcon = Icons.arrow_right,
      this.shrinkIcon = Icons.arrow_left,
      this.onToggle});
}
//SideMenu Toggler Model Ends

//SideMenu Header Model Starts
class SideMenuHeader {
  final Widget image;
  final Widget? title;
  final Widget? subtitle;

  const SideMenuHeader({
    required this.image,
    this.title,
    this.subtitle,
  });
}
//SideMenu Header Model Ends

//SideMenu Footer Model Starts
class SideMenuFooter {
  final Widget label;

  const SideMenuFooter({required this.label});
}
//SideMenu Footer Model Ends

//SideMenu Theme Model Starts
class SideMenuTheme {
  final Color? backgroundColor;
  final SideMenuItemTheme itemTheme;
  final SideMenuTogglerTheme togglerTheme;
  final SideMenuDividerTheme dividerTheme;

  const SideMenuTheme({
    required this.itemTheme,
    required this.togglerTheme,
    required this.dividerTheme,
    this.backgroundColor,
  });

  //Json to Model
  factory SideMenuTheme.standard() => SideMenuTheme(
        backgroundColor: null,
        itemTheme: SideMenuItemTheme.standard(),
        togglerTheme: SideMenuTogglerTheme.standard(),
        dividerTheme: SideMenuDividerTheme.standard(),
      );
}
//SideMenu Theme Model Ends

//SideMenu Item Theme Model Starts
class SideMenuItemTheme {
  static const Color defaultSelectedItemColor = colorCode;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? iconSize;
  final TextStyle? labelTextStyle;

  const SideMenuItemTheme({
    this.selectedItemColor,
    this.unselectedItemColor,
    this.iconSize,
    this.labelTextStyle,
  });

  //Json to Model
  factory SideMenuItemTheme.standard() => const SideMenuItemTheme(
        selectedItemColor: defaultSelectedItemColor,
        unselectedItemColor: null,
        iconSize: 20,
        labelTextStyle: null,
      );
}
//SideMenu Item Theme Model Ends

//SideMenu Toggler Theme Model Starts
class SideMenuTogglerTheme {
  final Color? expandIconColor;
  final Color? shrinkIconColor;

  const SideMenuTogglerTheme({this.expandIconColor, this.shrinkIconColor});

  //Json to Model
  factory SideMenuTogglerTheme.standard() => const SideMenuTogglerTheme(
        expandIconColor: null,
        shrinkIconColor: null,
      );
}

//SideMenu Toggler Theme Model Ends
//SideMenu Divider Theme Model Starts
class SideMenuDividerTheme {
  final bool showHeaderDivider;
  final Color? headerDividerColor;
  final double? headerDividerThickness;
  final bool showMainDivider;
  final Color? mainDividerColor;
  final double? mainDividerThickness;
  final bool showFooterDivider;
  final Color? footerDividerColor;
  final double? footerDividerThickness;

  const SideMenuDividerTheme({
    required this.showHeaderDivider,
    required this.showMainDivider,
    required this.showFooterDivider,
    this.headerDividerColor,
    this.headerDividerThickness,
    this.mainDividerColor,
    this.mainDividerThickness,
    this.footerDividerColor,
    this.footerDividerThickness,
  });

  //Json to Model
  factory SideMenuDividerTheme.standard() => const SideMenuDividerTheme(
        showHeaderDivider: true,
        headerDividerColor: null,
        headerDividerThickness: null,
        showMainDivider: true,
        mainDividerColor: null,
        mainDividerThickness: null,
        showFooterDivider: true,
        footerDividerColor: null,
        footerDividerThickness: null,
      );
}
//SideMenu Divider Theme Model Ends
