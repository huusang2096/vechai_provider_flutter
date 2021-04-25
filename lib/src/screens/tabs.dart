import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/dash_board_bloc.dart';
import 'package:vecaprovider/src/bloc/tabs/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/notification.dart';
import 'package:vecaprovider/src/models/token_request.dart';
import 'package:vecaprovider/src/models/user_response.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/screens/confrimPayment.dart';
import 'package:vecaprovider/src/screens/dashBoardHost.dart';
import 'package:vecaprovider/src/screens/home.dart';
import 'package:vecaprovider/src/screens/orders.dart';
import 'package:vecaprovider/src/screens/update_order.dart';
import 'package:vecaprovider/src/uitls/device_helper.dart';
import 'package:vecaprovider/src/widgets/DrawerWidget.dart';
import 'package:vecaprovider/src/widgets/NotificationButtonWidget.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'account.dart';
import 'dashBoard.dart';
import 'orders_host.dart';

// ignore: must_be_immutable
class TabsWidget extends StatefulWidget {
  int currentTab = 0;
  int selectedTab = 0;
  String currentTitle = 'Viet Nam';

  TabsWidget({
    Key key,
    this.currentTab,
  }) : super(key: key);

  @override
  _TabsWidgetState createState() {
    return _TabsWidgetState();
  }

  static provider(BuildContext context, int currentTab) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DashBoardBloc()),
        BlocProvider(create: (context) => OrdersBloc()),
        BlocProvider(create: (context) => OrderHostBloc()),
        BlocProvider(create: (context) => HomeBloc())
      ],
      child: TabsWidget(currentTab: currentTab),
    );
  }
}

class _TabsWidgetState extends State<TabsWidget>
    with SingleTickerProviderStateMixin, UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage;
  User _user;
  int badges = 2;
  bool isProvider = false;
  List<Widget> screens = [];

  PermissionStatus permission;
  Position currentLocation;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var serviceStatus;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _firebaseMessaging.getToken().then((token) async {
      if (token != null) {
        await Prefs.saveFCMToken(token ?? "");
        sendFCMToken();
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        var data = message['data'] ?? message;
        String jsonData = json.encode(data);

        NotificationModel notificationModel =
            NotificationModel.fromRawJson(jsonData);
        if (notificationModel.type == "logout") {
          showCustomDialog(
              title: localizedText(context, "VECA"),
              description: localizedText(context, "unauthenticated"),
              buttonText: localizedText(context, 'ok'),
              image: Image.asset('img/icon_warning.png', color: Colors.white),
              context: context,
              onPress: () {
                hasShowPopUp = false;
                Prefs.clearAll();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteNamed.SIGN_IN, (Route<dynamic> route) => false);
              });
        } else {
          displayNotification(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  sendFCMToken() async {
    String platform = '';
    if (Platform.isIOS) {
      platform = 'ios';
    } else if (Platform.isAndroid) {
      platform = 'android';
    }
    String token = await Prefs.getFCMToken();
    if (token != null) {
      TokenRequest tokenRequest = new TokenRequest();
      tokenRequest.accountType = 2;
      tokenRequest.deviceId = await DeviceHelper.instance.getId();
      tokenRequest.platform = platform;
      tokenRequest.fcmToken = token;
      Repository.instance
          .sendFCM(tokenRequest)
          .then((value) =>
              {print("ERROR---------------------" + value.toString())})
          .catchError(
              (err) => print("ERROR---------------------" + err.toString()));
    }
  }

  _getLocationAndUpdate() async {
    if (await Geolocator().isLocationServiceEnabled()) {
      getLocation();
    } else {
      _checkLocationService();
    }
  }

  Future<bool> _checkLocationService() async {
    serviceStatus = await Geolocator().isLocationServiceEnabled();
    if (!serviceStatus) {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context, 'location_is_disabled'),
          buttonText: localizedText(context, 'ok'),
          image: Image.asset('img/icon_warning.png'),
          context: context,
          onPress: () async {
            hasShowPopUp = false;
            serviceStatus = await Permission.locationWhenInUse.serviceStatus;
            if (serviceStatus == ServiceStatus.enabled) {
              Navigator.of(context).pop();
              getLocation();
            } else {
              AppSettings.openLocationSettings();
            }
          });
      return false;
    }
    return true;
  }

  getLocation() {
    requestPermission()?.then((_) async {
      currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
          currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          widget.currentTitle = pos.name +
              ', ' +
              pos.thoroughfare +
              ', ' +
              pos.subAdministrativeArea +
              ', ' +
              pos.administrativeArea +
              ', ' +
              pos.country;
          print("Location" + widget.currentTitle);
        });
      }
    });
  }

  _getUser() async {
    _user = await Prefs.getUser();
    if (_user != null) {
      setState(() {});
    }
  }

  _getProvider() async {
    isProvider = await Prefs.isProvider();
    setState(() {
      screens = [
        isProvider
            ? DashBoardWidget.provider(context, dashBoardBloc)
            : DashBoardHostWidget.provider(context, dashBoardBloc),
        isProvider
            ? ConfrimPaymentWidget.provider(context)
            : HomeWidget.provider(context, homeBloc, changeTab: (tabID) {
                _selectTab(tabID);
              }, isProvider: isProvider),
        isProvider
            ? HomeWidget.provider(context, homeBloc, changeTab: (tabID) {
                _selectTab(tabID);
              }, isProvider: isProvider)
            : UdpateOrderWidget.provider(context, 0),
        isProvider
            ? OrdersCollertorWidget.provider(context, ordersBloc)
            : OrdersHostWidget.provider(context, orderHostBloc),
        AccountWidget.provider(context, isProvider),
      ];
    });
  }

  _getBadgesCart() {
    Prefs.getBadgeCart().then((value) {
      setState(() {
        this.badges = value;
      });
    });
  }

  DashBoardBloc dashBoardBloc;
  OrdersBloc ordersBloc;
  OrderHostBloc orderHostBloc;
  HomeBloc homeBloc;

  @override
  initState() {
    firebaseCloudMessaging_Listeners();
    sendFCMToken();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    dashBoardBloc = BlocProvider.of<DashBoardBloc>(context);
    orderHostBloc = BlocProvider.of<OrderHostBloc>(context);
    ordersBloc = BlocProvider.of<OrdersBloc>(context);

    _getProvider();
    _selectTab(widget.currentTab);
    _getUser();
    _getBadgesCart();
    _getLocationAndUpdate();
    super.initState();
  }

  @override
  void didUpdateWidget(TabsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      widget.selectedTab = tabItem;
      switch (tabItem) {
        case 0:
          String start =
              DateFormat('yyyy-MM-dd').format(dashBoardBloc.selectedValue) +
                  " 00:00:00";
          String end =
              DateFormat('yyyy-MM-dd').format(dashBoardBloc.selectedValue) +
                  " 23:59:59";
          if (isProvider) {
            currentPage = DashBoardWidget.provider(context, dashBoardBloc);
            dashBoardBloc.add(GetReportEvent(start, end));
          } else {
            currentPage = DashBoardHostWidget.provider(context, dashBoardBloc);
            dashBoardBloc.add(GetHostReportEvent(start, end));
          }
          break;
        case 1:
          if (isProvider) {
            currentPage = ConfrimPaymentWidget.provider(context);
          } else {
            currentPage =
                HomeWidget.provider(context, homeBloc, changeTab: (tabID) {
              _selectTab(tabID);
            }, isProvider: isProvider);
            homeBloc.add(HomeEventData());
          }
          break;
        case 2:
          if (isProvider) {
            currentPage =
                HomeWidget.provider(context, homeBloc, changeTab: (tabID) {
              _selectTab(tabID);
            }, isProvider: isProvider);
            homeBloc.add(HomeEventData());
          } else {
            UdpateOrderWidget.provider(context, 0);
          }
          break;
        case 3:
          if (isProvider) {
            currentPage = OrdersCollertorWidget.provider(context, ordersBloc);
            ordersBloc.add(OrderEvent("accepted"));
            ordersBloc.add(OrderEvent("finished"));
            ordersBloc.add(OrderFinishEvent());
          } else {
            currentPage = OrdersHostWidget.provider(context, orderHostBloc);
            orderHostBloc.add(OrderHostEvent("pending"));
            orderHostBloc.add(OrderHostEvent("finished"));
          }
          break;
        case 4:
          currentPage = AccountWidget.provider(context, isProvider);
          break;
      }
    });
  }

  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _userAvatar() {
      if (_user != null && _user.avatar != null) {
        return CachedNetworkImageProvider(_user.avatar);
      } else {
        return AssetImage('img/user_placeholder.png');
      }
    }

    var data = EasyLocalizationProvider.of(context).data;
    return BlocListener<TabsBloc, TabsState>(
        listener: (context, state) {},
        child: BlocBuilder<TabsBloc, TabsState>(builder: (context, state) {
          return EasyLocalizationProvider(
            data: data,
            child: WillPopScope(
              onWillPop: () {
                return _willPopCallback();
              },
              child: Scaffold(
                key: _scaffoldKey,
                drawer: DrawerWidget.provider(context, changeTab: (tabID) {
                  _selectTab(tabID);
                }),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                      icon: new Icon(Icons.menu, color: Colors.white, size: 25),
                      onPressed: () => _scaffoldKey.currentState.openDrawer()),
                  flexibleSpace: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          gradient: getLinearGradient())),
                  elevation: 0,
                  bottomOpacity: 0,
                  centerTitle: true,
                  title: Container(
                      width: 300,
                      child: Text(
                        localizedText(context, widget.currentTitle ?? ''),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .merge(TextStyle(color: Colors.white)),
                      )),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        new NotificationButtonWidget(
                            iconColor: Colors.white,
                            labelColor: Colors.black,
                            labelCount: this.badges),
                      ],
                    )
                  ],
                ),
                body: IndexedStack(
                  index: widget.currentTab,
                  children: screens,
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(gradient: getLinearGradient()),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: widget.selectedTab,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: Color(0xFFdce260),
                    unselectedItemColor: Colors.white,
                    selectedLabelStyle: Theme.of(context).textTheme.caption,
                    unselectedLabelStyle: Theme.of(context).textTheme.caption,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    elevation: 0,
                    onTap: (int i) {
                      this._selectTab(i);
                    },
                    // this will be set when a new tab is tapped
                    items: [
                      BottomNavigationBarItem(
                        icon: Image.asset('img/marketing.png',
                            width: 25,
                            color: widget.currentTab != 0
                                ? Colors.white
                                : Color(0xFFdce260)),
                        title: Text(
                          localizedText(context, 'dashBoard'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                            isProvider ? UiIcons.photo_camera : Icons.store,
                            size: 25,
                            color: widget.currentTab != 1
                                ? Colors.white
                                : Color(0xFFdce260)),
                        title: Text(
                          isProvider
                              ? localizedText(context, 'scan')
                              : localizedText(context, 'host'),
                        ),
                      ),
                      BottomNavigationBarItem(
                          title: new Container(height: 0.0),
                          icon: new Container(
                            width: 70,
                          )),
                      BottomNavigationBarItem(
                        icon: Image.asset('img/history.png',
                            width: 25,
                            color: widget.currentTab != 3
                                ? Colors.white
                                : Color(0xFFdce260)),
                        title: Text(
                          localizedText(context, 'my_orders_menu'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset('img/user.png',
                            width: 25,
                            color: widget.currentTab != 4
                                ? Colors.white
                                : Color(0xFFdce260)),
                        title: Text(
                          localizedText(context, 'profile'),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: 80,
                    height: 100,
                    child: FloatingActionButton(
                      onPressed: () {
                        _selectTab(2);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: getLinearGradientButton(),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.white,
                              width: 2,
                              style: BorderStyle.solid),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Center(
                            child: Text(
                                isProvider
                                    ? localizedText(context, 'buy')
                                    : localizedText(context, 'censorship'),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .merge(
                                        TextStyle(color: Color(0xFF003428)))),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          );
        }));
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Fluttertoast.showToast(
        msg: "",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: "",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
    );
  }
}
