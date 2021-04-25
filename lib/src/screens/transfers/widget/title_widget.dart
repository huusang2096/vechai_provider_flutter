import 'package:flutter/material.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class TitleWidget extends StatelessWidget {
  final String titleKey;

  const TitleWidget({Key key, this.titleKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        localizedText(context, titleKey),
        style: TextStyle(
          color: Color(0xff87D65A),
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }
}
