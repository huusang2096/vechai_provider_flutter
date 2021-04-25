import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';

// ignore: must_be_immutable
class OrderStoreItemWidget extends StatefulWidget {
  String heroTag;
  HostModel hostModel;

  OrderStoreItemWidget({Key key, this.heroTag, this.hostModel}) : super(key: key);

  @override
  _OrderStoreItemWidgetState createState() => _OrderStoreItemWidgetState();
}

class _OrderStoreItemWidgetState extends State<OrderStoreItemWidget> with UIHelper{

  _userAvatar() {
    return AssetImage('img/cover.png');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        children: <Widget>[
          Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Color(0x802196F3),
              child: Container(
                decoration: BoxDecoration(
                  border:
                  Border.all(color: Theme.of(context).hintColor, width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: (){
                        Navigator.of(context)
                            .pushNamed(RouteNamed.SHOP_DETAIL,
                            arguments: {"HostModel" : widget.hostModel, "isHost" : false});
                    },
                    child: Column(
                      children: <Widget>[
                        ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          primary: false,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(RouteNamed.SHOP_DETAIL,
                                              arguments: {"HostModel" : widget.hostModel, "isHost" : false});
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.hostModel.name,
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            Text(
                                              widget.hostModel.phone,
                                              style:
                                              Theme.of(context).textTheme.bodyText2
                                            ),
                                          ],
                                        ),
                                      )),
                                  SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(300),
                                        child: CircleAvatar(
                                            backgroundImage: _userAvatar()),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                          title: Text(widget.hostModel.addresses.length == 0? "Đang cập nhật": widget.hostModel.addresses[0].addressTitle,
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.left),
                          trailing: Text(widget.hostModel.distance.toString() + " km",
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.right),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  widget.hostModel.addresses.length == 0? "Đang cập nhật": widget.hostModel.addresses[0].localName,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  textAlign: TextAlign.left)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}

