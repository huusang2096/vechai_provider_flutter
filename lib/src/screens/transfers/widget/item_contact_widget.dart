import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class UserStatus {
  static const ONLINE = 'online';
  static const OFFLINE = 'offline';
  static const MINUTES_AGO = 'MINUTES_AGO';
}

class ItemContactWidget extends StatelessWidget {
  final double width = 60.0;
  final double height = 60.0;
  final String imgUrl;
  final String pathSvg;
  final String title;
  final String subTitle;
  final bool showStatus;
  final String statusUser;
  final Size size;
  final Function onPress;
  ItemContactWidget(
      {Key key,
      this.pathSvg,
      this.title,
      this.subTitle,
      this.showStatus,
      this.statusUser,
      this.size,
      this.onPress,
      this.imgUrl})
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
              imgUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imgUrl,
                      //memCacheWidth: 250,
                      imageBuilder: (context, img) {
                        return Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            image:
                                DecorationImage(image: img, fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(
                              Radius.circular(width / 2),
                            ),
                          ),
                        );
                      },
                      errorWidget: (
                        context,
                        url,
                        error,
                      ) {
                        return SizedBox(
                          width: width,
                          height: height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              SizedBox(height: 2.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  localizedText(context, 'image_error'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      placeholder: (context, string) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(width / 2),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    )
                  : SvgPicture.asset(
                      pathSvg,
                      width: width,
                      height: height,
                    ),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showStatus
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: (size.width - 84.0) * 0.6,
                                    child: Text(title,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        )),
                                  ),
                                  buildStatusUser(context, statusUser),
                                ],
                              )
                            : Text(title,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                )),
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

  Widget buildStatusUser(BuildContext context, String userStatus) {
    switch (userStatus) {
      case UserStatus.ONLINE:
        return buildStatusUserOnOff(context, userStatus);
      case UserStatus.OFFLINE:
        return buildStatusUserOnOff(context, userStatus);
      case UserStatus.MINUTES_AGO:
        return buildStatusUserOnOff(context, userStatus);
      default:
        return buildStatusUserOnOff(context, userStatus);
    }
  }

  Widget buildStatusUserOnOff(BuildContext context, String userStatus) {
    return SizedBox(
      child: Row(
        children: [
          Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: userStatus == UserStatus.ONLINE
                    ? Color(0xff87D65A)
                    : Colors.redAccent),
          ),
          SizedBox(width: 4.0),
          Text(
            localizedText(context, userStatus),
            style: TextStyle(color: Colors.black54, fontSize: 11.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
