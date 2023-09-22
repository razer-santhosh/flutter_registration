// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../src/model/sideMenuModel.dart';
import '../constants.dart';
import 'sideMenu.dart';

class SideMenuItemWidget extends StatefulWidget {
  /// Constructor Variables
  final SideMenuItem itemData;
  final ValueChanged<int> onTap;
  final int index;
  final SideMenuItemTheme itemTheme;
  final bool expanded;
  const SideMenuItemWidget({
    Key? key,
    required this.itemData,
    required this.onTap,
    required this.index,
    required this.itemTheme,
    required this.expanded,
  }) : super(key: key);

  @override
  SideMenuItemWidgetState createState() => SideMenuItemWidgetState();
}

class SideMenuItemWidgetState extends State<SideMenuItemWidget> {
  @override
  void initState() {
    super.initState();
    setState(() {
      colorCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Variables
    final List<SideMenuItem> barItems = SideMenu.of(context).widget.items;
    final int selectedIndex = SideMenu.of(context).widget.selectedIndex;
    final bool isSelected = _isTileSelected(barItems, selectedIndex);
    final Color? currentColor = _evaluateColor(context, isSelected);

    /// Return a basic list-tile for now
    return Tooltip(
      waitDuration: const Duration(seconds: 1),
      message: widget.itemData.label,
      child: widget.expanded
          ? ListTile(
              leading: Icon(
                widget.itemData.icon,
                color: currentColor,
                size: widget.itemTheme.iconSize,
              ),
              title: Text(
                widget.itemData.label,
                style: _evaluateTextStyle(currentColor),
              ),
              onTap: () {
                widget.onTap(widget.index);
              },
            )
          : IconButton(
              icon: Icon(
                widget.itemData.icon,
                color: currentColor,
                size: widget.itemTheme.iconSize,
              ),
              onPressed: () {
                widget.onTap(widget.index);
              },
            ),
    );
  }

  /// Determines if this tile is currently selected
  bool _isTileSelected(final List<SideMenuItem> items, final int index) {
    for (final SideMenuItem item in items) {
      if (item.label == widget.itemData.label && index == widget.index) {
        return true;
      }
    }
    return false;
  }

  /// Check if this item [isSelected] and return the passed [widget.selectedColor]
  Color? _evaluateColor(final BuildContext context, final bool isSelected) {
    final Brightness brightness = Theme.of(context).brightness;
    return isSelected
        // If selectedItemColor is null we pass the default
        ? (widget.itemTheme.selectedItemColor != null)
            ? widget.itemTheme.selectedItemColor
            : colorCode
        // If unselectedItemColor is null we evaluate current brightness and return either grey or white
        : (widget.itemTheme.unselectedItemColor != null)
            ? widget.itemTheme.unselectedItemColor
            : (brightness == Brightness.light ? Colors.grey : Colors.white);
  }

  /// Evaluate what text style to use for an item based on a
  TextStyle? _evaluateTextStyle(final Color? evaluatedColor) {
    // No custom styled passed via theme - using default empty theme with color
    if (widget.itemTheme.labelTextStyle == null) {
      return TextStyle(
        color: evaluatedColor,
      );
    }
    // Return custom text style overridden with evaluated color
    return widget.itemTheme.labelTextStyle!.apply(color: evaluatedColor);
  }
}
