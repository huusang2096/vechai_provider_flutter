import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/models/RequestByHostResponse.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/widgets/line_dash.dart';

class ConfrimPaymentWidget extends StatefulWidget {
  @override
  _ConfrimPaymentWidgetState createState() => _ConfrimPaymentWidgetState();

  static provider(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ConfrimPaymentBloc(),
      child: ConfrimPaymentWidget(),
    );
  }
}

class _ConfrimPaymentWidgetState extends State<ConfrimPaymentWidget>
    with UIHelper {
  ProgressDialog pr;
  String barcode = "";
  ConfrimPaymentBloc _bloc;
  HostOrder hostOrder;

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _bloc = BlocProvider.of<ConfrimPaymentBloc>(context);
    super.initState();
  }

  Future scan() async {
    try {
      barcode = await BarcodeScanner.scan();
      _bloc.add(GetOrderByHost(barcode));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Widget build(BuildContext context) {
    return BlocListener<ConfrimPaymentBloc, BaseState>(listener:
        (context, state) {
      handleCommonState(context, state);
      if (state is GetOrderByHostSuccessState) {
        hostOrder = state.data.hostOrder;
      }

      if (state is ApproveSuccessState) {
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: state.message,
            buttonText: localizedText(context, 'ok'),
            image: Image.asset('img/icon_success.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
        barcode = "";
        hostOrder = null;
      }
    }, child:
        BlocBuilder<ConfrimPaymentBloc, BaseState>(builder: (context, state) {
      var data = EasyLocalizationProvider.of(context).data;
      return EasyLocalizationProvider(
        data: data,
        child: new SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              hostOrder == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                          elevation: 14.0,
                          borderRadius: BorderRadius.circular(12.0),
                          shadowColor: Color(0x802196F3),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                      title: Text(
                                    localizedText(context, 'scan_qrocde'),
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                                ),
                                InkWell(
                                  onTap: () {
                                    scan();
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Theme.of(context).primaryColor,
                                      size: 28,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    )
                  : SizedBox.shrink(),
              hostOrder != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: getLinearGradient(),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 15)
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          _bloc.add(ApproveOrderByHost(hostOrder.id));
                        },
                        child: Center(
                          child: Text(
                            localizedText(context, 'confirm'),
                            style: Theme.of(context).textTheme.headline4.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              hostOrder != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                          elevation: 14.0,
                          shadowColor: Color(0x802196F3),
                          borderRadius: BorderRadius.circular(12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: <Widget>[
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.left),
                                  trailing: Text(
                                    hostOrder.amountWallet.toString() + "đ",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                                      localizedText(context,
                                          'total_amount_payment_via_cash'),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.left),
                                  trailing: Text(
                                    hostOrder.amountCash.toString() + "đ",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                                      localizedText(context, 'subtotal'),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.left),
                                  trailing: Text(
                                    hostOrder.grandTotalAmount.toString() + "đ",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                SizedBox(height: 10),
                                LineDash(color: Colors.grey),
                                SizedBox(height: 10),
                                ListTile(
                                  title: Text(
                                    localizedText(context, 'order_detail'),
                                    style:
                                        Theme.of(context).textTheme.headline4,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.left),
                                      trailing: Text(
                                        hostOrder.id.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
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
                                          localizedText(context, 'customer'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.left),
                                      trailing: Text(
                                        hostOrder.host.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
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
                                          localizedText(
                                              context, 'date_create_order'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.left),
                                      trailing: Text(
                                        formatTime(hostOrder.createdAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
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
                                          localizedText(
                                              context, 'order_status'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.left),
                                      trailing: Text(
                                        hostOrder.status,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ItemProduct(
                                      item: hostOrder.requestItems[index],
                                    );
                                  },
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: hostOrder.requestItems.length,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          )),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 20)
            ],
          ),
        )),
      );
    }));
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
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(item.scrap.image),
                  fit: BoxFit.contain),
            ),
          )),
      title: Text(item.scrap.name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.left),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.weight.toString().replaceAll(".", ","),
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: Text(
        item.totalAmount.toString() + "đ",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
    );
  }
}
