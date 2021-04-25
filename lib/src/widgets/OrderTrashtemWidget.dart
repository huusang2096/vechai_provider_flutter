import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';

// ignore: must_be_immutable
class OrderTrashItemWidget extends StatefulWidget {
  String heroTag;
  OrderModel order;
  HomeBloc bloc;

  OrderTrashItemWidget({Key key, this.heroTag, this.order, this.bloc})
      : super(key: key);

  @override
  _OrderTrashItemWidgetState createState() => _OrderTrashItemWidgetState();
}

class _OrderTrashItemWidgetState extends State<OrderTrashItemWidget>
    with UIHelper {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
              child: ListTile(
                onTap: () {
                  if (widget.bloc.isProvider) {
                    showCustomDialog2(
                        title: localizedText(context, "VECA"),
                        description: localizedText(context, 'accept_orders'),
                        buttonText: localizedText(context, 'ok'),
                        buttonClose: localizedText(context, 'close'),
                        image: Image.asset('img/icon_success.png',
                            color: Colors.white),
                        context: context,
                        onPress: () {
                          hasShowPopUp = false;
                          widget.bloc.add(AcceptRequest(widget.order.id));
                          Navigator.of(context).pop();
                        });
                  }
                },
                leading: Image.asset('img/icon_address.png',
                    color: Theme.of(context).accentColor, width: 40),
                title: Text(
                    widget.order.requestBy == null
                        ? ""
                        : widget.order.requestBy.name,
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
                    SizedBox(height: 5),
                    widget.order.address.addressDescription != ""
                        ? Text(widget.order.address.addressDescription,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(
                                    color: Theme.of(context).accentColor)),
                            textAlign: TextAlign.left,
                            maxLines: null)
                        : SizedBox.shrink(),
                    Text(widget.order.address.localName,
                        style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
