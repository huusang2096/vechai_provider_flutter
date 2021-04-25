import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/common/const.dart';

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({
    this.iconColor,
    this.labelColor,
    this.labelCount = 0,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  final int labelCount;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(RouteNamed.NOTIFICATIONS);
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Image.asset('img/notification.png',
                width: 20,color: Colors.white),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
