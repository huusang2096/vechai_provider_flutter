import 'package:flutter/material.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class ButtonScanAgain extends StatelessWidget with UIHelper {
  final Size size;
  final Function onPress;
  ButtonScanAgain({this.size, this.onPress});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          gradient: getLinearGradient(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(56.0 / 3)),
            onTap: () {
              onPress();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                localizedText(context, 're_scan_the_qr_code'),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            )),
      ),
    );
  }
}
