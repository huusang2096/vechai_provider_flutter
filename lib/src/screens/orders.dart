import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/src/bloc/orders_bloc.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/screens/orderList/orders_accept.dart';
import 'package:vecaprovider/src/screens/orderList/orders_confrim.dart';
import 'package:vecaprovider/src/screens/orderList/orders_finished.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';
import 'package:vecaprovider/config/app_config.dart' as config;

class OrdersCollertorWidget extends StatefulWidget {
  int currentTab;
  final void Function(int tabId) changeTab;
  OrdersBloc ordersBloc;

  OrdersCollertorWidget(this.ordersBloc, this.changeTab);

  static provider(BuildContext context, OrdersBloc bloc,
      {void Function(int tabID) changeTab}) {
    return OrdersCollertorWidget(bloc, changeTab);
  }

  @override
  State<OrdersCollertorWidget> createState() {
    return _OrdersWidgetState();
  }
}

class _OrdersWidgetState extends State<OrdersCollertorWidget> with UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: widget.currentTab ?? 0,
        length: 3,
        child: EasyLocalizationProvider(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: new PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 5),
                padding: EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: config.Colors().mainDarkColor(1), width: 0.5),
                      borderRadius: BorderRadius.circular(20)),
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    indicator: BoxDecoration(
                      gradient: getLinearGradient(),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 15)
                      ],
                    ),
                    indicatorWeight: 0.0,
                    unselectedLabelColor: config.Colors().secondColor(1),
                    labelColor: Colors.white,
                    labelStyle: Theme.of(context).textTheme.subtitle2,
                    unselectedLabelStyle: Theme.of(context).textTheme.subtitle2,
                    isScrollable: false,
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          localizedText(context, 'new_order'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Tab(
                        child: Text(
                          localizedText(context, 'confirmed_order'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Tab(
                        child: Text(
                          localizedText(context, 'finished_order'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(children: [
              OrdersAcceptWidget.provider(context, widget.ordersBloc),
              OrdersConfirmedsWidget.provider(context, widget.ordersBloc),
              OrdersFinishedWidget.provider(context, widget.ordersBloc),
            ]),
          ),
        ));
  }
}
