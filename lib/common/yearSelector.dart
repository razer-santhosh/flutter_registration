// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'monthYearGrid.dart';

class MonthSelector extends StatefulWidget {
  final ValueChanged<DateTime> onMonthSelected;
  final DateTime? firstDate, lastDate;
  final DateTime selectedDate, openDate;
  final PublishSubject<UpDownPageLimit> upDownPageLimitPublishSubject;
  final PublishSubject<UpDownButtonEnableState>
      upDownButtonEnableStatePublishSubject;
  final Locale? locale;
  final bool Function(DateTime)? selectableMonthPredicate;
  final bool capitalizeFirstLetter;
  final Color? selectedMonthBackgroundColor,
      selectedMonthTextColor,
      unselectedMonthTextColor;

  const MonthSelector({
    Key? key,
    required this.openDate,
    required this.selectedDate,
    required this.onMonthSelected,
    required this.upDownPageLimitPublishSubject,
    required this.upDownButtonEnableStatePublishSubject,
    this.firstDate,
    this.lastDate,
    this.locale,
    this.selectableMonthPredicate,
    required this.capitalizeFirstLetter,
    required this.selectedMonthBackgroundColor,
    required this.selectedMonthTextColor,
    required this.unselectedMonthTextColor,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => MonthSelectorState();
}

class MonthSelectorState extends State<MonthSelector> {
  PageController? _pageController;

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        onPageChanged: _onPageChange,
        itemCount: _getPageCount(),
        itemBuilder: (final BuildContext context, final int page) =>
            MonthYearGridBuilder(
          capitalizeFirstLetter: widget.capitalizeFirstLetter,
          onMonthSelected: widget.onMonthSelected,
          openDate: widget.openDate,
          page: page,
          selectedDate: widget.selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          locale: widget.locale,
          selectableMonthPredicate: widget.selectableMonthPredicate,
          selectedMonthBackgroundColor: widget.selectedMonthBackgroundColor,
          selectedMonthTextColor: widget.selectedMonthTextColor,
          unselectedMonthTextColor: widget.unselectedMonthTextColor,
        ),
      );

  void _onPageChange(final int page) {
    widget.upDownPageLimitPublishSubject.add(
      UpDownPageLimit(
        widget.firstDate != null ? widget.firstDate!.year + page : page,
        0,
      ),
    );
    widget.upDownButtonEnableStatePublishSubject.add(
      UpDownButtonEnableState(page > 0, page < _getPageCount() - 1),
    );
  }

  int _getPageCount() {
    if (widget.firstDate != null && widget.lastDate != null) {
      return widget.lastDate!.year - widget.firstDate!.year + 1;
    } else if (widget.firstDate != null && widget.lastDate == null) {
      return 9999 - widget.firstDate!.year;
    } else if (widget.firstDate == null && widget.lastDate != null) {
      return widget.lastDate!.year + 1;
    } else {
      return 9999;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: widget.firstDate == null
            ? widget.openDate.year
            : widget.openDate.year - widget.firstDate!.year);
    Future.delayed(Duration.zero, () {
      widget.upDownPageLimitPublishSubject.add(
        UpDownPageLimit(
          widget.firstDate == null
              ? _pageController!.page!.toInt()
              : widget.firstDate!.year + _pageController!.page!.toInt(),
          0,
        ),
      );
      widget.upDownButtonEnableStatePublishSubject.add(
        UpDownButtonEnableState(
          _pageController!.page!.toInt() > 0,
          _pageController!.page!.toInt() < _getPageCount() - 1,
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void goDown() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goUp() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class YearSelector extends StatefulWidget {
  final ValueChanged<int> onYearSelected;
  final DateTime? initialDate, firstDate, lastDate;
  final PublishSubject<UpDownPageLimit> upDownPageLimitPublishSubject;
  final PublishSubject<UpDownButtonEnableState>
      upDownButtonEnableStatePublishSubject;
  final Locale? locale;
  final Color? selectedMonthBackgroundColor,
      selectedMonthTextColor,
      unselectedMonthTextColor;

  const YearSelector({
    Key? key,
    this.initialDate,
    required this.onYearSelected,
    required this.upDownPageLimitPublishSubject,
    required this.upDownButtonEnableStatePublishSubject,
    this.firstDate,
    this.lastDate,
    this.locale,
    required this.selectedMonthBackgroundColor,
    required this.selectedMonthTextColor,
    required this.unselectedMonthTextColor,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => YearSelectorState();
}

class YearSelectorState extends State<YearSelector> {
  PageController? _pageController;

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        onPageChanged: _onPageChange,
        itemCount: _getPageCount(),
        itemBuilder: _yearGridBuilder,
      );

  Widget _yearGridBuilder(final BuildContext context, final int page) =>
      GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 4,
        children: List<Widget>.generate(
          12,
          (final int index) => _getYearButton(
              page, index, getLocale(context, selectedLocale: widget.locale)),
        ).toList(growable: false),
      );

  Widget _getYearButton(final int page, final int index, final String locale) {
    final int year = (widget.firstDate == null ? 0 : widget.firstDate!.year) +
        page * 12 +
        index;
    final bool isEnabled = _isEnabled(year);
    final ThemeData theme = Theme.of(context);
    final backgroundColor =
        widget.selectedMonthBackgroundColor ?? theme.colorScheme.secondary;
    return TextButton(
      onPressed: isEnabled ? () => widget.onYearSelected(year) : null,
      style: TextButton.styleFrom(
          foregroundColor: year == widget.initialDate!.year
              ? theme.textTheme.labelLarge!
                  .copyWith(
                    color: widget.selectedMonthTextColor ??
                        theme.colorScheme.onSecondary,
                  )
                  .color
              : year == DateTime.now().year
                  ? backgroundColor
                  : widget.unselectedMonthTextColor,
          backgroundColor:
              year == widget.initialDate!.year ? backgroundColor : null,
          shape: const CircleBorder()),
      child: Text(
        DateFormat.y(locale).format(DateTime(year)),
      ),
    );
  }

  void _onPageChange(final int page) {
    widget.upDownPageLimitPublishSubject.add(UpDownPageLimit(
        widget.firstDate == null
            ? page * 12
            : widget.firstDate!.year + page * 12,
        widget.firstDate == null
            ? page * 12 + 11
            : widget.firstDate!.year + page * 12 + 11));
    if (page == 0 || page == _getPageCount() - 1) {
      widget.upDownButtonEnableStatePublishSubject.add(
        UpDownButtonEnableState(page > 0, page < _getPageCount() - 1),
      );
    }
  }

  int _getPageCount() {
    if (widget.firstDate != null && widget.lastDate != null) {
      if (widget.lastDate!.year - widget.firstDate!.year <= 12) {
        return 1;
      } else {
        return ((widget.lastDate!.year - widget.firstDate!.year + 1) / 12)
            .ceil();
      }
    } else if (widget.firstDate != null && widget.lastDate == null) {
      return (_getItemCount() / 12).ceil();
    } else if (widget.firstDate == null && widget.lastDate != null) {
      return (_getItemCount() / 12).ceil();
    } else {
      return (9999 / 12).ceil();
    }
  }

  int _getItemCount() {
    if (widget.firstDate != null && widget.lastDate != null) {
      return widget.lastDate!.year - widget.firstDate!.year + 1;
    } else if (widget.firstDate != null && widget.lastDate == null) {
      return 9999 - widget.firstDate!.year;
    } else if (widget.firstDate == null && widget.lastDate != null) {
      return widget.lastDate!.year;
    } else {
      return 9999;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: widget.firstDate == null
            ? (widget.initialDate!.year / 12).floor()
            : ((widget.initialDate!.year - widget.firstDate!.year) / 12)
                .floor());
    Future.delayed(Duration.zero, () {
      widget.upDownPageLimitPublishSubject.add(UpDownPageLimit(
        widget.firstDate == null
            ? _pageController!.page!.toInt() * 12
            : widget.firstDate!.year + _pageController!.page!.toInt() * 12,
        widget.firstDate == null
            ? _pageController!.page!.toInt() * 12 + 11
            : widget.firstDate!.year + _pageController!.page!.toInt() * 12 + 11,
      ));
      widget.upDownButtonEnableStatePublishSubject.add(
        UpDownButtonEnableState(_pageController!.page!.toInt() > 0,
            _pageController!.page!.toInt() < _getPageCount() - 1),
      );
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  bool _isEnabled(final int year) {
    if (widget.firstDate == null && widget.lastDate == null) {
      return true;
    } else if (widget.firstDate != null &&
        widget.lastDate != null &&
        year >= widget.firstDate!.year &&
        year <= widget.lastDate!.year) {
      return true;
    } else if (widget.firstDate != null &&
        widget.lastDate == null &&
        year >= widget.firstDate!.year) {
      return true;
    } else if (widget.firstDate == null &&
        widget.lastDate != null &&
        year <= widget.lastDate!.year) {
      return true;
    } else {
      return false;
    }
  }

  void goDown() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goUp() {
    _pageController!.animateToPage(
      _pageController!.page!.toInt() - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class UpDownPageLimit {
  const UpDownPageLimit(this.upLimit, this.downLimit);
  final int upLimit;
  final int downLimit;
}

class UpDownButtonEnableState {
  const UpDownButtonEnableState(this.upState, this.downState);
  final bool upState;
  final bool downState;
}

String getLocale(
  BuildContext context, {
  Locale? selectedLocale,
}) {
  if (selectedLocale != null) {
    return '${selectedLocale.languageCode}_${selectedLocale.countryCode}';
  }
  final Locale locale = Localizations.localeOf(context);
  return '${locale.languageCode}_${locale.countryCode}';
}
