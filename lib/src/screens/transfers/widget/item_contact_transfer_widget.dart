import 'package:flutter/material.dart';

class ItemContactTransferWidget extends StatelessWidget {
  final String imgAvatar;
  final String title;
  final String subTitle;
  final Size size;
  final Function onPress;
  ItemContactTransferWidget(
      {Key key,
      this.imgAvatar,
      this.title,
      this.subTitle,
      this.size,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onPress();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SizedBox(width: 8.0),
              SizedBox(
                width: 60.0,
                height: 60.0,
                child: CircleAvatar(
                  child: Text(imgAvatar),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(subTitle,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.clip)
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
