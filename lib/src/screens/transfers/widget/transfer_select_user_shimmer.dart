import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/src/screens/transfers/widget/separator_widget.dart';
import 'package:vecaprovider/src/screens/transfers/widget/title_widget.dart';

class TransferSelectUserShimmer extends StatelessWidget {
  final colorGrey300 = Colors.grey[300];
  final colorGrey100 = Colors.grey[100];
  final colorWhite = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(titleKey: 'search_results'),
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
                          'assets/svg/avatar_icon.svg',
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
                                      child: Text('thevingglink@gmail.com',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.transparent)),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Shimmer.fromColors(
                                    baseColor: colorGrey300,
                                    highlightColor: colorGrey100,
                                    child: Container(
                                      color: colorWhite,
                                      child: Text('thevingglink@gmail.com',
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
        ),
      ),
    );
  }
}
