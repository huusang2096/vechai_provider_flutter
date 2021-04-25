import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/src/models/HostResponse.dart';
import 'package:vecaprovider/src/widgets/MarqueeWidget.dart';
import 'package:vecaprovider/src/widgets/ToastWidget.dart';

class ProductHostGridItemWidget extends StatelessWidget {
  const ProductHostGridItemWidget({
    Key key,
    @required this.product,
    @required this.heroTag,
  }) : super(key: key);

  final AcceptScrap product;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).primaryColor,
      onTap: () {},
      child: Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).hintColor, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8),
              product?.scrap?.image != null
                  ? Container(
                      height: MediaQuery.of(context).size.width * 0.12,
                      width: MediaQuery.of(context).size.width * 0.12,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(product.scrap.image),
                            fit: BoxFit.contain),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.width * 0.12,
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: Image.asset(
                        'img/icon_error.png',
                        fit: BoxFit.contain,
                      ),
                    ),
              SizedBox(height: 8),
              Text(
                product?.scrap?.name ?? localizedText(context, 'scrap'),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .merge(TextStyle(color: Theme.of(context).accentColor)),
              ),
              MarqueeWidget(
                direction: Axis.horizontal,
                child: Text(
                  '${product?.hostPrice ?? '0'} đ',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
