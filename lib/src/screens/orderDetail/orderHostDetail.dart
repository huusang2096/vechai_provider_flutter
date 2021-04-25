import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';
import 'package:vecaprovider/src/widgets/line_dash.dart';

class OrderHostDetailCategoryWidget extends StatefulWidget {
  OrderModel orderModel;

  OrderHostDetailCategoryWidget({Key key, this.orderModel}) : super(key: key);

  @override
  _OrderHostDetailCategoryWidgetState createState() =>
      _OrderHostDetailCategoryWidgetState();
}

class _OrderHostDetailCategoryWidgetState
    extends State<OrderHostDetailCategoryWidget> with UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(UiIcons.return_icon,
                color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: getLinearGradient())),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(
            localizedText(context, 'order_detail'),
            style: Theme.of(context)
                .textTheme
                .headline4
                .merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          actions: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    localizedText(context, 'skip'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .merge(TextStyle(color: Theme.of(context).accentColor)),
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: EasyLocalizationProvider(
          data: data,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                localizedText(context, 'collector_detail'),
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.perm_identity,
                                size: 25,
                                color: Theme.of(context).accentColor,
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 0.0,
                                  right: 10.0,
                                  left: 10.0),
                              title: Text(
                                  localizedText(context, 'collector_name'),
                                  style: Theme.of(context).textTheme.bodyText1,
                                  textAlign: TextAlign.left),
                              trailing: Text(
                                  widget.orderModel.collector?.name ?? '',
                                  style: Theme.of(context).textTheme.bodyText2),
                            ),
                            ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.phone,
                                size: 25,
                                color: Theme.of(context).accentColor,
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 0.0,
                                  right: 10.0,
                                  left: 10.0),
                              title: Text(
                                  localizedText(context, 'collector_phone'),
                                  style: Theme.of(context).textTheme.bodyText1,
                                  textAlign: TextAlign.left),
                              trailing: Text(
                                  widget.orderModel.collector?.phoneNumber ??
                                      '',
                                  style: Theme.of(context).textTheme.bodyText2),
                            ),
                          ],
                        )),
                    SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                localizedText(context, 'order_detail'),
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: <Widget>[
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.art_track,
                                    size: 25,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 0.0,
                                      right: 10.0,
                                      left: 10.0),
                                  title: Text(
                                      localizedText(context, 'id_order'),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.left),
                                  trailing: Text(
                                      widget.orderModel?.id.toString() ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.date_range,
                                    size: 25,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 0.0,
                                      right: 10.0,
                                      left: 10.0),
                                  title: Text(
                                      localizedText(context, 'collector_date'),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.left),
                                  trailing: Text(
                                      formatTime(widget.orderModel.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.report,
                                    size: 25,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 0.0,
                                      right: 10.0,
                                      left: 10.0),
                                  title: Text(
                                      localizedText(context, 'order_status'),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.left),
                                  trailing: Text(
                                      localizedText(context,
                                          widget.orderModel?.status ?? ''),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2),
                                ),
                              ],
                            ),
                            ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return ItemProduct(
                                  item: widget.orderModel.requestItems[index],
                                );
                              },
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.orderModel.requestItems.length,
                            ),
                            SizedBox(height: 10),
                            LineDash(color: Colors.grey),
                            SizedBox(height: 10),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 0.0,
                                  right: 10.0,
                                  left: 10.0),
                              title: Text(
                                  localizedText(context,
                                      'total_amount_payment_via_wallet'),
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.left),
                              trailing: Text(
                                widget.orderModel.totalAmountPaymentViaWallet
                                        .toString() +
                                    "đ",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 0.0,
                                  right: 10.0,
                                  left: 10.0),
                              title: Text(
                                  localizedText(
                                      context, 'total_amount_payment_via_cash'),
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.left),
                              trailing: Text(
                                widget.orderModel.totalAmountPaymentViaCash
                                        .toString() +
                                    "đ",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 0.0,
                                  right: 10.0,
                                  left: 10.0),
                              title: Text(localizedText(context, 'subtotal'),
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.left),
                              trailing: Text(
                                widget.orderModel.grandTotalAmount.toString() +
                                    "đ",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class ItemProduct extends StatelessWidget {
  final RequestItem item;

  _userAvatar() {
    return CachedNetworkImageProvider(item.scrap.image);
  }

  const ItemProduct({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 55,
        height: 55,
        child: item.scrap?.image != null
            ? Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(item.scrap.image),
                      fit: BoxFit.contain),
                ),
              )
            : Container(
                margin: EdgeInsets.all(8),
                child: Image.asset(
                  'img/icon_error.png',
                  scale: 0.8,
                  fit: BoxFit.contain,
                )),
      ),
      title: Text(item.scrap?.name ?? localizedText(context, 'scrap'),
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.left),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item?.weight?.toString()?.replaceAll(".", ",") ?? '',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: Text(
        item?.totalAmount?.toString() ?? '' + "đ",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
    );
  }
}
