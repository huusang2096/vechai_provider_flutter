import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/src/bloc/transfers/bloc.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class InformationContactWidget extends StatelessWidget {
  final double width = 80.0;
  final double height = 80.0;
  final User user;
  final TransfersBloc bloc;

  InformationContactWidget({this.user, this.bloc});
  @override
  Widget build(BuildContext context) {
    // final state = context.watch<TransferCubit>().state;
    final phone = '${user?.phoneCountryCode ?? ''}${user?.phoneNumber ?? ''}';
    return Container(
      child: Column(
        children: [
          user?.avatar != null && user.avatar.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: user?.avatar ?? '',
                  // memCacheWidth: 250,
                  imageBuilder: (context, img) {
                    return Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: img, fit: BoxFit.cover),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                  'img/avatar_icon.svg',
                  width: width,
                  height: height,
                ),
          SizedBox(height: 5.0),
          Text(
            user.name ?? ' ',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            //(phone.isEmpty || user.phoneNumber.isEmpty) ?? user.email ?? ' ',
            (user.phoneNumber.isEmpty || user.phoneCountryCode.isEmpty)
                ? user.email ?? ' '
                : phone,
          ),
        ],
      ),
    );
  }
}
