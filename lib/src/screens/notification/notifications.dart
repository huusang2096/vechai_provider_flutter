import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/notifications_bloc.dart';
import 'package:vecaprovider/src/bloc/notifications_event.dart';
import 'package:vecaprovider/src/bloc/notifications_state.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/config/app_config.dart' as config;
import 'package:vecaprovider/src/screens/notification/notifications_system.dart';
import 'package:vecaprovider/src/screens/notification/notifications_user.dart';


class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();

  static provider(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsBloc(),
      child: NotificationsWidget(),
    );
  }
}

class _NotificationsWidgetState extends State<NotificationsWidget>
    with UIHelper {

  NotificationsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<NotificationsBloc>(context);
    bloc.add(NotificationEvent());
    intUI();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return BlocListener<NotificationsBloc, BaseState>(
      listener: (context, state) {
        if (state is NotificationsSuccessState) {
        }
      },
      child: BlocBuilder<NotificationsBloc, BaseState>(
        builder: (context, state) {
           return DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: EasyLocalizationProvider(
                child: Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: new Icon(UiIcons.return_icon, color: Theme
                          .of(context)
                          .primaryColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    flexibleSpace:   Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            gradient: getLinearGradient())),
                    elevation: 0,
                    iconTheme: IconThemeData(color: Theme
                        .of(context)
                        .primaryColor),
                    title: Text(
                      localizedText(context, 'notification'),
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .merge(TextStyle(color: Theme
                          .of(context)
                          .primaryColor)),
                    ),
                    bottom:  new PreferredSize(
                      preferredSize: Size.fromHeight(70),
                      child: new Container(
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: config.Colors().mainDarkColor(1), width: 0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: TabBar(
                              indicatorColor: Colors.transparent,
                              indicator:  BoxDecoration(
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
                                    localizedText(context,'system'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    localizedText(context,'user'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),
                      ),
                    ),
                  ),
                  body: TabBarView(children: [
                    NotificationsSystemScreen.provider(context, bloc,changeTab: (id){
                    }),
                    NotificationsUserScreen.provider(context, bloc,changeTab: (id){
                    }),
                  ]),
                ),
              ));
        },
      ),
    );
  }
}
