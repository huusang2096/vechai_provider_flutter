library date_picker_timeline;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/widgets/dateTimeline/date_widget.dart';
import 'package:vecaprovider/src/widgets/dateTimeline/gestures/tap.dart';
import 'package:vecaprovider/config/app_config.dart' as config;

class DatePickerTimeline extends StatefulWidget with UIHelper{
  double width;
  double height;

  Color selectionColor = config.Colors().mainColor(1);
  DateTime currentDate = DateTime.now();
  DateChangeListener onDateChange;
  int daysCount;
  String locale;

  // Creates the DatePickerTimeline Widget
  DatePickerTimeline(
    this.currentDate, {
    Key key,
    this.width,
    this.height = 100,
    this.daysCount = 30,
    this.onDateChange,
    this.locale = "en_US",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DatePickerState();
}

class _DatePickerState extends State<DatePickerTimeline> {

  @override void initState() {
    super.initState();

    initializeDateFormatting(widget.locale, null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.daysCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // Return the Date Widget
          DateTime _date = DateTime.utc(2020, 1, 1).add(Duration(days: index));
          DateTime date = new DateTime(_date.year, _date.month, _date.day);
          bool isSelected = compareDate(date, widget.currentDate);

          return DateWidget(
            date: date,
            monthTextStyle: Theme.of(context).textTheme.bodyText2,
            dateTextStyle:Theme.of(context).textTheme.bodyText1,
            dayTextStyle: Theme.of(context).textTheme.bodyText2,
            locale: widget.locale,
            selectionColor:
                isSelected ? widget.selectionColor : Colors.transparent,
            onDateSelected: (selectedDate) {
              // A date is selected
              if (widget.onDateChange != null) {
                widget.onDateChange(selectedDate);
              }
              setState(() {
                widget.currentDate = selectedDate;
              });
            },
          );
        },
      ),
    );
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
