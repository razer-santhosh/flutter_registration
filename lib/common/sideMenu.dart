// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, file_names, unnecessary_null_comparison
import 'package:flutter/material.dart';
import '../src/model/sideMenuModel.dart';
import '../constants.dart';
import 'sideMenuItemWidget.dart';

class SideMenu extends StatefulWidget {
  /// Constructor variables
  final int selectedIndex;
  final List<SideMenuItem> items;
  final ValueChanged<int> onTap;
  final SideMenuHeader? header;
  final SideMenuFooter? footer;
  final SideMenuToggler? toggler;
  final SideMenuTheme? theme;
  final bool expandable;
  final bool initiallyExpanded;

  const SideMenu({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onTap,
    this.header,
    this.footer,
    this.toggler,
    this.theme,
    this.expandable = true,
    this.initiallyExpanded = true,
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
  static _SideMenuState of(final BuildContext context) {
    final _SideMenuState? state =
        context.findAncestorStateOfType<_SideMenuState>();
    if (state == null) {
      throw StateError('Trying to access null state _SideMenuState');
    }
    return state;
  }
}

class _SideMenuState extends State<SideMenu> {
  final double _minWidth = 50;
  final double _maxWidth = 210;
  late double _width;
  late double sizedBoxWidth;
  late bool _expanded;
  late SideMenuTheme theme;

  @override
  void initState() {
    super.initState();
    _evaluateInitialStructure();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: _evaluateMainDivider(),
      ),
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 350),
        child: SizedBox(
          width: _width,
          height: double.infinity,
          child: Column(
            children: [
              // Header
              Row(children: [
                if (header != null) _evaluateHeaderWidget(),
                SizedBox(
                  width: sizedBoxWidth,
                ),
                _evaluateTogglerWidget(),
              ]),
              _evaluateHeaderDivider(),
              // Navigation content
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    children: _generateItems(),
                  ),
                ),
              ),
              _evaluateFooterDivider(),
              // Footer
              _evaluateFooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// Toggles this widget. Determine width here for now.
  void _toggle() {
    setState(() {
      if (_expanded) {
        _width = _minWidth;
        sizedBoxWidth = 5;
      } else {
        _width = _maxWidth;
        sizedBoxWidth = 40;
      }
      _expanded = !_expanded;
    });
    widget.toggler?.onToggle?.call();
  }

  void _evaluateInitialStructure() {
    theme = widget.theme ?? SideMenuTheme.standard();
    _evaluateInitiallyExpanded();
  }

  void _evaluateInitiallyExpanded() {
    if (widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
      _width = _maxWidth;
      sizedBoxWidth = 40;
    } else {
      _expanded = widget.initiallyExpanded;
      _width = _minWidth;
      sizedBoxWidth = 0;
    }
  }

  List<Widget> _generateItems() {
    List<Widget> _items = widget.items
        .asMap()
        .entries
        .map<SideMenuItemWidget>(
            (MapEntry<int, SideMenuItem> entry) => SideMenuItemWidget(
                  itemData: entry.value,
                  onTap: widget.onTap,
                  itemTheme: theme.itemTheme,
                  index: entry.key,
                  expanded: _expanded,
                ))
        .toList();
    return _items;
  }

  /// Determines if a [SideMenuHeader] was provided
  Widget _evaluateHeaderWidget() {
    if (widget.header == null) {
      return Container();
    }
    if (widget.expandable) {
      if (_expanded) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.header!.image,
              if (widget.header!.title != null)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.header!.title != null)
                            widget.header!.title!,
                          if (widget.header!.subtitle != null)
                            widget.header!.subtitle!,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: widget.header!.image,
        );
      }
    } else {
      if (widget.initiallyExpanded) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.header!.image,
              if (widget.header!.title != null)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.header!.title != null)
                            widget.header!.title!,
                          if (widget.header!.subtitle != null)
                            widget.header!.subtitle!,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: widget.header!.image,
        );
      }
    }
  }

  /// Determines if a [SideMenuFooter] was provided
  Widget _evaluateFooterWidget() {
    if (widget.footer != null) {
      if (widget.expandable) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: widget.footer!.label,
              ),
            ],
          ),
        );
      } else {
        if (widget.initiallyExpanded) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: widget.footer!.label,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      }
    }
    return Container();
  }

  /// Logic to handle building the toggler widget.
  Widget _evaluateTogglerWidget() {
    if (!widget.expandable && widget.toggler != null) {
      throw StateError(
          'SideMenu is not expandable but a SideBarToggler is given.');
    }

    // Toggler is not needed if the bar is not expandable
    if (!widget.expandable) {
      return Container();
    }

    if (widget.toggler != null) {
      return IconButton(
        icon: Icon(
          widget.expandable
              ? widget.toggler!.shrinkIcon
              : widget.toggler!.expandIcon,
          color: widget.expandable
              ? theme.togglerTheme.shrinkIconColor
              : theme.togglerTheme.expandIconColor,
        ),
        onPressed: () => _toggle(),
      );
    } else {
      const SideMenuToggler barToggler = SideMenuToggler();
      return IconButton(
        icon: Icon(
          widget.expandable ? barToggler.shrinkIcon : barToggler.expandIcon,
          color: widget.expandable
              ? theme.togglerTheme.shrinkIconColor
              : theme.togglerTheme.expandIconColor,
        ),
        onPressed: () => _toggle(),
      );
    }
  }

  /// Determines whether to put a [Border] between the bar and the main content
  Border? _evaluateMainDivider() {
    if (!theme.dividerTheme.showMainDivider) {
      return null;
    }
    return Border(
      right: BorderSide(
        width: theme.dividerTheme.mainDividerThickness ?? 0.5,
        color: theme.dividerTheme.mainDividerColor ??
            (MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey[700]!
                : Colors.white),
      ),
    );
  }

  /// Determines if a [Divider] should be displayed between the [SideMenuHeaderWidget] and
  /// the [SideMenu.items]
  Widget _evaluateHeaderDivider() {
    if (!theme.dividerTheme.showHeaderDivider) {
      return Container();
    }
    if (widget.header == null) {
      return Container();
    }
    return Divider(
      color: theme.dividerTheme.headerDividerColor,
      thickness: theme.dividerTheme.headerDividerThickness,
    );
  }

  /// Determines if a [Divider] should be displayed between the [SideMenuFooterWidget] and
  Widget _evaluateFooterDivider() {
    if (!theme.dividerTheme.showFooterDivider) {
      return Container();
    }
    if (widget.footer == null) {
      return Container();
    }
    if (!widget.expandable) {
      return Container();
    }
    return Divider(
      color: theme.dividerTheme.footerDividerColor,
      thickness: theme.dividerTheme.footerDividerThickness,
    );
  }
}
