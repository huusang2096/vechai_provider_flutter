import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/models/AddressModel.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/widgets/OrderStoreWidget.dart';
import 'package:vecaprovider/src/widgets/OrderTrashtemWidget.dart';
import 'package:vecaprovider/config/app_config.dart' as config;

import 'orderList/orders_trash.dart';

class HomeWidget extends StatefulWidget {
  final void Function(int tabId) changeTab;
  final bool isProvider;
  HomeBloc bloc;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();

  HomeWidget(this.bloc, this.changeTab, this.isProvider);

  static provider(BuildContext context, bloc,
      {void Function(int tabID) changeTab, bool isProvider}) {
    return HomeWidget(bloc, changeTab, isProvider);
  }
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin, UIHelper {
  PermissionStatus permission;
  Position currentLocation;
  PermissionStatus permissionStatus;

  @override
  void initState() {
    widget.bloc.add(HomeEventData());
    intUI();
    super.initState();
  }

  handleRefresh() {
    if (widget.bloc != null) {
      widget.bloc.add(HomeEventData());
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _handleRefresh() async {
      await new Future.delayed(new Duration(seconds: 3));
      widget.bloc.add(HomeEventData());
      return null;
    }

    var data = EasyLocalizationProvider.of(context).data;
    return BlocListener<HomeBloc, BaseState>(listener: (context, state) {
      handleUnauthenticatedState(context, state);

      if (state is OpenUpdatePassWord) {
        Navigator.of(context)
            .pushNamed(RouteNamed.CHANGE_PASS)
            .then((value) => {widget.bloc.add(HomeEventData())});
      }

      if (state is OpenAddAddress) {
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, 'no_address_exists'),
            buttonText: localizedText(context, 'ok'),
            image: Image.asset('img/icon_warning.png', color: Colors.white),
            context: context,
            onPress: () async {
              hasShowPopUp = false;
              Navigator.of(context).pop();
              var callBack = (address) {
                widget.bloc.add(GetListOrder());
                widget.bloc.addressSelect = address;
              };
              Navigator.of(context).pushNamed(RouteNamed.FILLTER_MAP,
                  arguments: {"funcition": callBack});
            });
      }

      if (state is AcceptRequestState) {
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, 'accept_order_success'),
            buttonText: localizedText(context, 'close'),
            image: Image.asset('img/icon_success.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
      }

      if (state is AcceptRequestFailsState) {
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, state.message),
            buttonText: localizedText(context, 'close'),
            image: Image.asset('img/icon_warning.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
      }
    }, child: BlocBuilder<HomeBloc, BaseState>(builder: (context, state) {
      return EasyLocalizationProvider(
          data: data,
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView(
                children: <Widget>[
                  widget.isProvider
                      ? _providerScreen(state)
                      : _hostScreen(state)
                ],
              ),
            ),
          ));
    }));
  }

  _userAvatar() {
    if (widget.bloc.account != null &&
        widget.bloc.account.data.avatar != null) {
      return CachedNetworkImageProvider(widget.bloc.account.data.avatar);
    } else {
      return AssetImage('img/user_placeholder.png');
    }
  }

  _hostScreen(state) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16),
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Theme.of(context).accentColor.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, top: 30, bottom: 30, right: 24),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            HostModel host = widget.bloc.account.data.host[0];
                            Navigator.of(context).pushNamed(
                                RouteNamed.SHOP_DETAIL,
                                arguments: {"HostModel": host, "isHost": true});
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.bloc.account == null
                                    ? ""
                                    : widget.bloc.account.data.host[0].name,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                        )),
                        SizedBox(
                            width: 55,
                            height: 55,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(300),
                              child:
                                  CircleAvatar(backgroundImage: _userAvatar()),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      gradient: getLinearGradient(),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'img/chat.png',
                          width: 20,
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(localizedText(context, 'call_to_admin'),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(
                                  color: config.Colors().accentDarkColor(1))))),
                ],
              ),
              onTap: () {
                _launchEmail();
              }),
          ListTile(
            title: Text(localizedText(context, 'list_host'),
                style: Theme.of(context).textTheme.headline4),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            primary: false,
            itemCount: widget.bloc.hosts.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return OrderStoreItemWidget(
                heroTag:
                    widget.bloc.hosts[index].id.toString() + index.toString(),
                hostModel: widget.bloc.hosts[index],
              );
            },
          ),
          SizedBox(height: 40)
        ],
      ),
    );
  }

  _callPhone(String number) async {
    if (await canLaunch("tel:" + number)) {
      await launch("tel:" + number);
    } else {
      throw 'Could not Call Phone';
    }
  }

  _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'plveca2020@gmail.com',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  _providerScreen(state) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Text(
              localizedText(
                  context,
                  localizedText(context, 'order_your_accept',
                      args: [widget.bloc.numberOrder.toString()])),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4.merge(
                  TextStyle(color: Theme.of(context).textSelectionColor))),
          SizedBox(height: 20),
          Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTile(
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  gradient: getLinearGradient(),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      'img/map.png',
                                      width: 20,
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 16.0)),
                              Text(localizedText(context, 'locate'),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(TextStyle(
                                          color: config.Colors()
                                              .accentDarkColor(1))))
                            ],
                          )), onTap: () async {
                    var callBack = (address) {
                      widget.bloc.orderModels.clear();
                      widget.bloc.addressSelect = address;
                      widget.bloc.add(GetListOrder());
                    };
                    Navigator.of(context).pushNamed(RouteNamed.FILLTER_MAP,
                        arguments: {
                          "funcition": callBack,
                          "addressModel": widget.bloc.addressSelect
                        });
                  }),
                  _buildTile(
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width:
                                      MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                    gradient: getLinearGradient(),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(Icons.store,
                                      size: 25, color: Colors.white)),
                              Padding(padding: EdgeInsets.only(bottom: 16.0)),
                              Text(localizedText(context, 'host'),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(TextStyle(
                                          color: config.Colors()
                                              .accentDarkColor(1))))
                            ],
                          )), onTap: () async {
                    if (widget.bloc.addressSelect == null) {
                      showCustomDialog(
                          title: localizedText(context, "VECA"),
                          description: localizedText(
                              context, 'add_address_before_view_store'),
                          buttonText: localizedText(context, 'ok'),
                          image: Image.asset('img/icon_warning.png',
                              color: Colors.white),
                          context: context,
                          onPress: () async {
                            hasShowPopUp = false;
                            Navigator.of(context).pop();
                          });
                    } else {
                      Navigator.of(context).pushNamed(RouteNamed.STORES);
                    }
                  })
                ],
              )),
          InkWell(
            onTap: () {
              widget.changeTab(3);
            },
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                gradient: getLinearGradient(),
                border: Border.all(color: Color(0xFF999998), width: 0.5),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 15)
                ],
              ),
              child: Container(
                  height: 60,
                  child: Center(
                    child: Text(
                        localizedText(
                            context,
                            widget.bloc.numberPending.toString() +
                                localizedText(context, 'order_pending')),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .merge(TextStyle(color: Colors.white))),
                  )),
            ),
          ),
          widget.bloc.orderModels.length == 0
              ? SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          title: Text(
                              localizedText(context, 'list_order_trash'),
                              style: Theme.of(context).textTheme.headline4),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: widget.bloc.orderModels.length > 0
                            ? _buildTile(
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset('img/correct.png',
                                              width: 20, color: Colors.white)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text(localizedText(context, 'accepted_all'),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                color: config.Colors()
                                                    .accentDarkColor(1))))
                                  ],
                                ), onTap: () async {
                                widget.bloc.add(AcceptAllRequest());
                              })
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
          _buildBody(state)
        ],
      ),
    );
  }

  _buildBody(state) {
    return widget.bloc.orderModels.length == 0
        ? SizedBox.shrink()
        : Container(
            margin: EdgeInsets.fromLTRB(6, 6, 6, 25),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              primary: false,
              itemCount: widget.bloc.orderModels.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 0);
              },
              itemBuilder: (context, index) {
                return OrderTrashItemWidget(
                  heroTag: 'orders_list',
                  order: widget.bloc.orderModels[index],
                  bloc: widget.bloc,
                );
              },
            ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return InkWell(
        // Do onTap() if it isn't null, otherwise do print()
        onTap: onTap != null
            ? () => onTap()
            : () {
                print('Not set yet');
              },
        child: child);
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, ScreenUtil().setHeight(100.0));
    path.quadraticBezierTo(size.width / 2.0, ScreenUtil().setHeight(180.0),
        size.width, ScreenUtil().setHeight(100.0));
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
