import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/widgets/line_dash.dart';

// ignore: must_be_immutable
class OrderAcceptItemWidget extends StatefulWidget {
  String heroTag;
  OrderModel order;
  OrdersBloc bloc;
  Function(OrderModel) onSelect;

  OrderAcceptItemWidget(
      {Key key, this.heroTag, this.order, this.bloc, this.onSelect})
      : super(key: key);

  @override
  _OrderAcceptItemWidgetState createState() => _OrderAcceptItemWidgetState();
}

class _OrderAcceptItemWidgetState extends State<OrderAcceptItemWidget>
    with UIHelper {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
      child: InkWell(
        onTap: () {
          widget.onSelect(widget.order);
        },
        child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Color(0x802196F3),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).hintColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .merge(TextStyle(
                                        color: Theme.of(context).accentColor)),
                                textAlign: TextAlign.left,
                                maxLines: null)
                            : SizedBox.shrink(),
                        Text(widget.order.address.localName,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(
                                    color: Theme.of(context).accentColor)),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
