// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'yearSelector.dart';

class MonthYearGridBuilder extends StatelessWidget {
  const MonthYearGridBuilder(
      {Key? key,
      required this.onMonthSelected,
      this.firstDate,
      this.lastDate,
      required this.selectedDate,
      required this.openDate,
      this.locale,
      this.selectableMonthPredicate,
      required this.capitalizeFirstLetter,
      this.selectedMonthBackgroundColor,
      this.selectedMonthTextColor,
      this.unselectedMonthTextColor,
      required this.page})
      : super(key: key);
  final ValueChanged<DateTime> onMonthSelected;
  final DateTime? firstDate, lastDate;
  final DateTime selectedDate, openDate;
  final Locale? locale;
  final bool Function(DateTime)? selectableMonthPredicate;
  final bool capitalizeFirstLetter;
  final Color? selectedMonthBackgroundColor,
      selectedMonthTextColor,
      unselectedMonthTextColor;
  final int page;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      children: List<Widget>.generate(
        12,
        (final int index) => MonthButton(
          openDate: openDate,
          selectedDate: selectedDate,
          theme: Theme.of(context),
          date: DateTime(
              firstDate != null ? firstDate!.year + page : page, index + 1),
          locale: getLocale(context, selectedLocale: locale),
          capitalizeFirstLetter: capitalizeFirstLetter,
          selectedMonthBackgroundColor: selectedMonthBackgroundColor,
          selectedMonthTextColor: selectedMonthTextColor,
          unselectedMonthTextColor: unselectedMonthTextColor,
          onMonthSelected: onMonthSelected,
          firstDate: firstDate,
          lastDate: lastDate,
          selectableMonthPredicate: selectableMonthPredicate,
        ),
      ).toList(growable: false),
    );
  }
}

class MonthButton extends StatelessWidget {
  const MonthButton({
    Key? key,
    required this.selectedDate,
    required this.openDate,
    this.firstDate,
    this.lastDate,
    required this.date,
    required this.theme,
    required this.locale,
    this.selectableMonthPredicate,
    required this.capitalizeFirstLetter,
    required this.selectedMonthBackgroundColor,
    required this.selectedMonthTextColor,
    required this.unselectedMonthTextColor,
    required this.onMonthSelected,
  }) : super(key: key);

  final ThemeData theme;
  final String locale;
  final ValueChanged<DateTime> onMonthSelected;
  final DateTime? firstDate, lastDate;
  final DateTime selectedDate, openDate, date;
  final bool Function(DateTime)? selectableMonthPredicate;
  final bool capitalizeFirstLetter;
  final Color? selectedMonthBackgroundColor,
      selectedMonthTextColor,
      unselectedMonthTextColor;

  bool _holdsSelectionPredicate(DateTime date) {
    if (selectableMonthPredicate != null) {
      return selectableMonthPredicate!(date);
    } else {
      return true;
    }
  }

  bool _isEnabled(final DateTime date) {
    if ((firstDate == null &&
            (lastDate == null ||
                (lastDate != null && lastDate!.compareTo(date) >= 0))) ||
        (firstDate != null &&
            ((lastDate != null &&
                    firstDate!.compareTo(date) <= 0 &&
                    lastDate!.compareTo(date) >= 0) ||
                (lastDate == null && firstDate!.compareTo(date) <= 0)))) {
      return _holdsSelectionPredicate(date);
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = _isEnabled(date);
    final backgroundColor =
        selectedMonthBackgroundColor ?? theme.colorScheme.secondary;
    return TextButton(
      onPressed: isEnabled
          ? () => onMonthSelected(DateTime(date.year, date.month))
          : null,
      style: TextButton.styleFrom(
        foregroundColor: date.month == selectedDate.month &&
                date.year == selectedDate.year
            ? theme.textTheme.labelLarge!
                .copyWith(
                  color:
                      selectedMonthTextColor ?? theme.colorScheme.onSecondary,
                )
                .color
            : date.month == DateTime.now().month &&
                    date.year == DateTime.now().year
                ? backgroundColor
                : unselectedMonthTextColor,
        backgroundColor:
            date.month == selectedDate.month && date.year == selectedDate.year
                ? backgroundColor
                : null,
        shape: const CircleBorder(),
      ),
      child: Text(
        capitalizeFirstLetter
            ? toBeginningOfSentenceCase(DateFormat.MMM(locale).format(date))!
            : DateFormat.MMM(locale).format(date).toLowerCase(),
      ),
    );
  }
}

class PickerHeader extends StatelessWidget {
  const PickerHeader(
      {Key? key,
      required this.theme,
      required this.locale,
      this.headerColor,
      this.headerTextColor,
      required this.capitalizeFirstLetter,
      required this.selectedDate,
      required this.isMonthSelector,
      required this.onDownButtonPressed,
      required this.onSelectYear,
      required this.onUpButtonPressed,
      required this.upDownButtonEnableStatePublishSubject,
      required this.upDownPageLimitPublishSubject,
      required this.roundedCornersRadius})
      : super(key: key);
  final ThemeData theme;
  final String locale;
  final Color? headerTextColor, headerColor;
  final bool capitalizeFirstLetter;
  final DateTime selectedDate;
  final bool isMonthSelector;
  final VoidCallback onSelectYear, onUpButtonPressed, onDownButtonPressed;
  final PublishSubject<UpDownPageLimit>? upDownPageLimitPublishSubject;
  final PublishSubject<UpDownButtonEnableState>?
      upDownButtonEnableStatePublishSubject;
  final double roundedCornersRadius;

  @override
  Widget build(BuildContext context) {
    final TextStyle? headline5 = headerTextColor == null
        ? theme.primaryTextTheme.headlineSmall
        : theme.primaryTextTheme.headlineSmall!
            .copyWith(color: headerTextColor);
    final Color? arrowColors = headerTextColor;

    return Material(
      color: headerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(roundedCornersRadius),
          topRight: Radius.circular(roundedCornersRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              capitalizeFirstLetter
                  ? '${toBeginningOfSentenceCase(DateFormat.yMMM(locale).format(selectedDate))}'
                  : DateFormat.yMMM(locale).format(selectedDate).toLowerCase(),
              style: headerTextColor == null
                  ? theme.primaryTextTheme.titleMedium
                  : theme.primaryTextTheme.titleMedium!
                      .copyWith(color: headerTextColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                isMonthSelector
                    ? GestureDetector(
                        onTap: onSelectYear,
                        child: StreamBuilder<UpDownPageLimit>(
                          stream: upDownPageLimitPublishSubject,
                          initialData: const UpDownPageLimit(0, 0),
                          builder:
                              (_, AsyncSnapshot<UpDownPageLimit> snapshot) =>
                                  Text(
                            DateFormat.y(locale)
                                .format(DateTime(snapshot.data!.upLimit)),
                            style: headline5,
                          ),
                        ),
                      )
                    : StreamBuilder<UpDownPageLimit>(
                        stream: upDownPageLimitPublishSubject,
                        initialData: const UpDownPageLimit(0, 0),
                        builder: (_, AsyncSnapshot<UpDownPageLimit> snapshot) =>
                            Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              DateFormat.y(locale)
                                  .format(DateTime(snapshot.data!.upLimit)),
                              style: headline5,
                            ),
                            Text(
                              '-',
                              style: headline5,
                            ),
                            Text(
                              DateFormat.y(locale)
                                  .format(DateTime(snapshot.data!.downLimit)),
                              style: headline5,
                            ),
                          ],
                        ),
                      ),
                StreamBuilder<UpDownButtonEnableState>(
                  stream: upDownButtonEnableStatePublishSubject,
                  initialData: const UpDownButtonEnableState(true, true),
                  builder:
                      (_, AsyncSnapshot<UpDownButtonEnableState> snapshot) =>
                          Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_up,
                          color: snapshot.data!.upState
                              ? arrowColors
                              : arrowColors!.withOpacity(0.5),
                        ),
                        onPressed:
                            snapshot.data!.upState ? onUpButtonPressed : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: snapshot.data!.downState
                              ? arrowColors
                              : arrowColors!.withOpacity(0.5),
                        ),
                        onPressed: snapshot.data!.downState
                            ? onDownButtonPressed
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
