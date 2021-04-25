import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/models/RequestItems.dart';
import 'package:vecaprovider/src/widgets/line_dash.dart';

// ignore: must_be_immutable
class OrderHostConfrimListItemWidget extends StatefulWidget {
  String heroTag;
  OrderModel order;
  OrderHostBloc bloc;

  OrderHostConfrimListItemWidget({Key key, this.heroTag, this.order, this.bloc})
      : super(key: key);

  @override
  _OrderHostConfrimListItemWidgetState createState() =>
      _OrderHostConfrimListItemWidgetState();
}

class _OrderHostConfrimListItemWidgetState
    extends State<OrderHostConfrimListItemWidget> with UIHelper {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(RouteNamed.QR_CODE, arguments: widget.order.id),
        child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(12.0),
            shadowColor: Color(0x802196F3),
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).hintColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                          widget.order == null
                              ? "#123"
                              : widget.order.host.name,
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.left),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.order == null
                                ? ""
                                : formatTime(widget.order.createdAt),
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      trailing: InkWell(
                        onTap: () {
                          showCustomDialog2(
                              title: localizedText(context, "VECA"),
                              description:
                                  localizedText(context, 'cancel_orders'),
                              buttonText: localizedText(context, 'ok'),
                              buttonClose: localizedText(context, 'close'),
                              image: Image.asset('img/icon_warning.png',
                                  color: Colors.white),
                              context: context,
                              onPress: () {
                                hasShowPopUp = false;
                                widget.bloc
                                    .add(RemoveOrderHostEvent(widget.order.id));
                                Navigator.of(context).pop();
                              });
                        },
                        child: Material(
                            color: Colors.red,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete,
                                  color: Colors.white, size: 18.0),
                            )),
                      ),
                    ),
                    SizedBox(height: 10),
                    LineDash(color: Colors.grey),
                    SizedBox(height: 10),
                    ListTile(
                      dense: true,
                      title: Text(localizedText(context, 'subtotal'),
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.left),
                      trailing: Text(
                        widget.order.grandTotalAmount.toString() + "đ",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class ItemProduct extends StatelessWidget {
  final RequestItem item;
  final Function() click;

  _userAvatar() {
    return CachedNetworkImageProvider(item.scrap.image);
  }

  const ItemProduct({Key key, @required this.item, this.click})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        click();
      },
      leading: SizedBox(
          width: 55,
          height: 55,
          child: InkWell(
            borderRadius: BorderRadius.circular(300),
            child: CircleAvatar(backgroundImage: _userAvatar()),
          )),
      title: Text(item.scrap.name,
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
