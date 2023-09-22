// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';

class DashboardCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardCard(
      {super.key,
      required this.selected,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          color: selected ? Colors.grey[100] : Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: width * 0.28,
            height: currentScreen == 'mobile' ? 70 : 120,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: !selected ? Colors.black45 : colorCode,
                  size: currentScreen == 'mobile' ? 30 : 35,
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Text(
                  label,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: currentScreen == 'mobile' ? 12 : 15,
                      fontWeight:
                          !selected ? FontWeight.normal : FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
