import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/product.dart';
import 'package:vecaprovider/src/models/route_argument.dart';

class ProductGridItemWidget extends StatelessWidget {
  const ProductGridItemWidget({
    Key key,
    @required this.product,
    @required this.heroTag,
  }) : super(key: key);

  final Product product;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed(RouteNamed.PRODUCT);
      },
      child: Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(5.0),
        shadowColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).hintColor, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.12,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(product.image), fit: BoxFit.fill),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .merge(TextStyle(color: Theme.of(context).accentColor)),
              ),
              Text(
                product.price1 + "đ",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
