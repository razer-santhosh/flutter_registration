// ignore_for_file: non_constant_identifier_names, file_names
import 'package:flutter/material.dart';

class BaseSideMenuModel {
  final int bottomIndex;
  final IconData icon;
  final String menu_module_name;
  final String route;

  const BaseSideMenuModel(
      {required this.bottomIndex,
      required this.icon,
      required this.menu_module_name,
      required this.route});

  //Json to Model
  factory BaseSideMenuModel.fromMap(Map<String, dynamic> json) =>
      BaseSideMenuModel(
          bottomIndex: json["bottomIndex"],
          icon: json["Icon"],
          menu_module_name: json["menu_module_name"],
          route: json["route"]);

  //Model to Json
  Map toJson() => {
        'bottomIndex': bottomIndex,
        'menu_module_name': menu_module_name,
        'icon': icon,
        'route': route
      };
}
