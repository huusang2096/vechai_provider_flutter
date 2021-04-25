import 'package:flutter/material.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';

class ButtonTransferWidget extends StatelessWidget with UIHelper {
  final Size size;
  final Function onPress;
  final String titleButton;
  ButtonTransferWidget({Key key, this.size, this.onPress, this.titleButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: getLinearGradientButton(),
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
                child: Text(localizedText(context, titleButton),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .merge(TextStyle(color: Colors.white, fontSize: 16))),
              ),
            ),
          ),
        ),
      ),
    );
    // return Positioned(
    //   bottom: 12.0,
    //   child: Container(
    //     width: size.width,
    //     alignment: Alignment.center,
    //     child: Container(
    //       width: size.width * 0.9,
    //       height: 45.0,
    //       decoration: BoxDecoration(
    //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //           gradient: LinearGradient(
    //             colors: <Color>[Color(0xffafdc53), Color(0xff89d461)],
    //           ),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.grey[500],
    //               offset: Offset(0.0, 1.5),
    //               blurRadius: 1.5,
    //             ),
    //           ]),
    //       child: Material(
    //         color: Colors.transparent,
    //         child: InkWell(
    //           borderRadius: BorderRadius.all(Radius.circular(56.0 / 3)),
    //           onTap: () {
    //             onPress();
    //           },
    //           child: Center(
    //             child: Text(
    //               titleButton,
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w500,
    //                 fontSize: 16,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
