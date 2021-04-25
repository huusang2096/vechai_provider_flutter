import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/uitls/phone_helper.dart';
import 'package:vecaprovider/src/widgets/EmptyOrdersProductsWidget.dart';
import 'package:vecaprovider/src/widgets/OrderAccepttemWidget.dart';
import 'package:vecaprovider/src/widgets/OrderTrashtemWidget.dart';

class OrdersAcceptWidget extends StatefulWidget {
  OrdersBloc ordersBloc;

  OrdersAcceptWidget(this.ordersBloc);

  static provider(BuildContext context, OrdersBloc ordersBloc) {
    return OrdersAcceptWidget(ordersBloc);
  }

  @override
  _OrdersAcceptWidgetState createState() => _OrdersAcceptWidgetState();
}

class _OrdersAcceptWidgetState extends State<OrdersAcceptWidget> with UIHelper {
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc.add(OrderEvent("accepted"));
    intUI();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    widget.ordersBloc.add(OrderEvent("accepted"));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      if (state is OrderDataRemoveState) {
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, state.message),
            buttonText: localizedText(context, 'close'),
            image: Image.asset('img/icon_success.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
      }
    }, child: BlocBuilder<OrdersBloc, BaseState>(builder: (context, state) {
      return Scaffold(
        body: RefreshIndicator(
            onRefresh: _handleRefresh, child: _buildBody(state)),
      );
    }));
  }

  Future<Widget> _showActionType(OrderModel order) async {
    await showModalBottomSheet(
        elevation: 10,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext builder) {
          return StatefulBuilder(
            builder: (context, state) {
              return AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.decelerate,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  await Navigator.of(context).pushNamed(
                                      RouteNamed.UPDATE_ORDER,
                                      arguments: order.id);
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    gradient: getLinearGradient(),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          localizedText(context, 'censorship'),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .merge(TextStyle(
                                                  color: Colors.white))),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final phoneModel =
                                      await PhoneHelper.parseFullPhone(
                                          order.requestBy.phoneCountryCode +
                                              order.requestBy.phoneNumber);
                                  if (phoneModel != null) {
                                    String fullPhone = phoneModel.national
                                        .toString()
                                        .replaceAll(" ", "");
                                    launch(('tel://${fullPhone}'));
                                  }
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    gradient: getLinearGradient(),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  openGoogleMap(order.address.lLat.toString(),
                                      order.address.lLong.toString());
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    gradient: getLinearGradient(),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.map_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  widget.ordersBloc
                                      .add(RemoveOrderEvent(order.id));
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openGoogleMap(String slat, String sLong) {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$slat,$sLong';
    _launchURL(googleUrl);
  }

  _buildBody(state) {
    return widget.ordersBloc.ordersAccept.length != 0
        ? Container(
            margin: EdgeInsets.fromLTRB(6, 6, 6, 20),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              primary: false,
              itemCount: widget.ordersBloc.ordersAccept.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return OrderAcceptItemWidget(
                  heroTag: widget.ordersBloc.ordersAccept[index].id.toString(),
                  order: widget.ordersBloc.ordersAccept[index],
                  bloc: widget.ordersBloc,
                  onSelect: (order) {
                    _showActionType(order);
                  },
                );
              },
            ))
        : Container(
            height: 100,
            child: Center(
              child: Text(localizedText(context, 'order_is_empty')),
            ));
  }
}
