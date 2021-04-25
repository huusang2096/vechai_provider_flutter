import 'package:flutter/material.dart';
import 'package:vecaprovider/config/app_config.dart' as config;

class StateWidget extends StatelessWidget {
  final String title;
  final String description;
  final Image image;
  final String buttontext;
  final Function onButton;

  StateWidget({this.title, this.description, this.image, this.buttontext, this.onButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height:216,
              width: 216,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle
                ),
                child: this.image,
              ),
            ),
            SizedBox(height: 48),
            Text(
              this.title,
              style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 18,
                color: config.Colors()
                    .secondDarkColor(1)
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14),
            Text(
              this.description,
              style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 18,
                color: config.Colors()
                    .secondDarkColor(1)
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
