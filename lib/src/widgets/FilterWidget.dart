import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/widgets/dateTimeline/date_picker_timeline.dart';

class FilterWidget extends StatefulWidget {
  void Function() updateFilter;

  FilterWidget({this.updateFilter});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> with UIHelper {
  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    return Drawer(
      child: EasyLocalizationProvider(
        data: data,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(localizedText(context, 'Lọc đơn hàng'),
                        style: Theme.of(context).textTheme.headline4.merge(
                            TextStyle(color: Theme.of(context).accentColor))),
                    MaterialButton(
                      onPressed: () {},
                      child: Text(
                        localizedText(context, "clear"),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  primary: true,
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.date_range,
                        size: 25,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        localizedText(context, 'Lọc đơn theo ngày '),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    DatePickerTimeline(
                      DateTime.now(),
                      onDateChange: (date) {
                        // New date selected
                        print(date.day.toString());
                      },
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(
                        Icons.map,
                        size: 25,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        localizedText(context, 'Lọc đơn theo khoảng cách '),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              FlatButton(
                onPressed: () {},
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Theme.of(context).accentColor,
                shape: StadiumBorder(),
                child: Text(
                  localizedText(context, "apply_filters"),
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}
