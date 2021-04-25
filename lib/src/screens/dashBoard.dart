import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/models/ReportResponse.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:intl/intl.dart' show DateFormat;

class DashBoardWidget extends StatefulWidget {
  @override
  _DashBoardWidgetState createState() => _DashBoardWidgetState();
  DashBoardBloc dashBoardBloc;

  DashBoardWidget(this.dashBoardBloc);

  static provider(BuildContext context,  DashBoardBloc dashBoardBloc) {
    return DashBoardWidget(dashBoardBloc);
  }
}

class _DashBoardWidgetState extends State<DashBoardWidget> with UIHelper{

  DateTime now = DateTime.now();
  ReportResponse reportResponse;
  DatePickerController _controler;

  _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'doanthanhnam231992@gmail.com',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
     _controler = DatePickerController();
    String start = DateFormat('yyyy-MM-dd').format(widget.dashBoardBloc.selectedValue) + " 00:00:00";
    String end = DateFormat('yyyy-MM-dd').format(widget.dashBoardBloc.selectedValue) + " 23:59:59";
    print("DAY" + start + end);
    widget.dashBoardBloc.add(GetReportEvent(start,end));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Future<Null> _handleRefresh() async {
      await new Future.delayed(new Duration(seconds: 3));
      String start = DateFormat('yyyy-MM-dd').format(widget.dashBoardBloc.selectedValue) + " 00:00:00";
      String end = DateFormat('yyyy-MM-dd').format(widget.dashBoardBloc.selectedValue) + " 23:59:59";
      widget.dashBoardBloc.add(GetReportEvent(start,end));
      return null;
    }

    return BlocListener<DashBoardBloc, BaseState>(
        listener: (context, state) {
          if(state is ReportSuccess){
            reportResponse = state.reportResponse;
            _controler.animateToDate(widget.dashBoardBloc.selectedValue.subtract(Duration(days: 3)));
          }
        },
        child: BlocBuilder<DashBoardBloc, BaseState>(builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Scaffold(
                body: StaggeredGridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  children: <Widget>[
                    // _buildTile(
                    //   Padding(
                    //     padding: const EdgeInsets.only(left: 12,top: 24,right: 12,bottom: 24),
                    //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //       Flexible(
                    //         flex: 1,
                    //         child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: <Widget>[
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: <Widget>[
                    //                   Expanded(
                    //                       child: InkWell(
                    //                         onTap: () {
                    //                         },
                    //                         child: Column(
                    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                           crossAxisAlignment: CrossAxisAlignment.start,
                    //                           children: <Widget>[
                    //                             Text(localizedText(context, 'numer_sum'),
                    //                             style: Theme.of(context).textTheme.headline3.merge(TextStyle(color:  Theme.of(context).accentColor))),
                    //                             SizedBox(height: 5),
                    //                             Text(reportResponse == null ? "0 đ" : reportResponse.data.balance.toString() + " đ",
                    //                                 style: Theme.of(context).textTheme.headline4),
                    //                           ],
                    //                         ),
                    //                       )),
                    //                 ],
                    //               ),
                    //
                    //             ]),
                    //       ),
                    //
                    //     ],),
                    //   ),
                    // ),
                    // _buildTile(
                    //     Padding(
                    //         padding: const EdgeInsets.all(12.0),
                    //         child:  Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: <Widget>[
                    //             Container(
                    //               width: 60,
                    //               height: 60,
                    //               decoration: BoxDecoration(
                    //                 gradient: getLinearGradient(),
                    //                 borderRadius: BorderRadius.circular(50),
                    //                 boxShadow: [
                    //                   BoxShadow(
                    //                     color: Colors.black26,
                    //                     blurRadius: 10,
                    //                   )
                    //                 ],
                    //               ),
                    //               child: Padding(
                    //                   padding: const EdgeInsets.all(12.0),
                    //                   child:  Icon(Icons.store,
                    //                       size: 30, color: Colors.white),
                    //               ),
                    //             ),
                    //             Padding(padding: EdgeInsets.only(bottom: 16.0)),
                    //             Text(localizedText(context, 'host_title'),
                    //                 overflow: TextOverflow.ellipsis,
                    //                 style: Theme.of(context).textTheme.headline3.merge(TextStyle(color:  Theme.of(context).accentColor))),
                    //             SizedBox(height: 5),
                    //             Text(reportResponse == null ? "0 " + localizedText(context, 'number_host')
                    //                 : reportResponse.data.totalHost.toString() + localizedText(context, 'number_host'),
                    //                 style: Theme.of(context).textTheme.headline4),
                    //
                    //           ],
                    //         )
                    //     ),
                    //     onTap: () {
                    //       Navigator.of(context).pushNamed(RouteNamed.STORES);
                    //     }
                    // ),
                    _buildTile(
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: getLinearGradient(),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('img/chat.png',
                                          width: 20)),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                Text(localizedText(context, 'feedback'),
                                    style: Theme.of(context).textTheme.headline3.merge(TextStyle(color:  Theme.of(context).accentColor))),
                                SizedBox(height: 5),
                                Text(localizedText(context, 'your_conmment'),
                                    style: Theme.of(context).textTheme.headline4),
                              ],
                            )), onTap: () {
                      _launchEmail();
                    }),
                    _buildTile(
                      Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(localizedText(context, 'value_in_day'),
                                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(color:  Theme.of(context).accentColor))),
                              SizedBox(height: 5),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    right: 10.0,
                                    left: 10.0),
                                title: Text(localizedText(context, 'number_buy'),
                                    style: Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left),
                                trailing: Text(
                                  reportResponse == null ? "0 kg" : reportResponse.data.totalBuyFromCustomer +" kg",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    right: 10.0,
                                    left: 10.0),
                                title: Text(localizedText(context, 'number_sale'),
                                    style: Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left),
                                trailing: Text(
                                  reportResponse == null ? "0 kg":reportResponse.data.totalSellToHost +" kg",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    right: 10.0,
                                    left: 10.0),
                                title: Text(localizedText(context, 'number_total'),
                                    style: Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left),
                                trailing: Text(
                                  reportResponse == null ? "0 đ" :reportResponse.data.totalRevenue+ " đ" ,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              SizedBox(height: 10),
                              DatePicker(
                                DateTime(now.year, 1, 1),
                                width: 60,
                                height: 100,
                                controller: _controler,
                                locale: "vi",
                                selectionColor: Theme.of(context).accentColor,
                                initialSelectedDate: widget.dashBoardBloc.selectedValue == null? DateTime.now(): widget.dashBoardBloc.selectedValue,
                                selectedTextColor: Colors.white,
                                onDateChange: (date) {
                                  setState(() {
                                    widget.dashBoardBloc.selectedValue = date;
                                    _handleRefresh();
                                  });
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(2, 190.0),
                    StaggeredTile.extent(2, 350.0),],
                )),
          );
        }));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
