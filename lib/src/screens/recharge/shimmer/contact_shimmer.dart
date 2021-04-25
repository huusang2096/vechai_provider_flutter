import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/src/screens/transfers/widget/separator_widget.dart';

class ContactShimmer extends StatelessWidget {
  final colorGrey300 = Colors.grey[300];
  final colorGrey100 = Colors.grey[100];
  final colorWhite = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15.0),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SeparatorWidget();
            },
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                child: Row(
                  children: [
                    SizedBox(width: 8.0),
                    SvgPicture.asset(
                      'img/avatar_icon.svg',
                      width: 60.0,
                      height: 60.0,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: colorGrey300,
                                highlightColor: colorGrey100,
                                child: Container(
                                  color: colorWhite,
                                  child: Text('huusang2096@gmail.com',
                                      style: TextStyle(
                                        color: Colors.transparent,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      )),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Shimmer.fromColors(
                                baseColor: colorGrey300,
                                highlightColor: colorGrey100,
                                child: Container(
                                  color: colorWhite,
                                  child: Text('huusang2096@gmail.com',
                                      style: TextStyle(
                                        color: Colors.transparent,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.clip),
                                ),
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 1,
          ),
        ),
      ],
    );
  }
}
