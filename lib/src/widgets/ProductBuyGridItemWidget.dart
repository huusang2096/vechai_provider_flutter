import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';
import 'package:vecaprovider/src/models/product.dart';
import 'package:vecaprovider/src/models/route_argument.dart';

class ProductBuyGridItemWidget extends StatelessWidget {
  const ProductBuyGridItemWidget({
    Key key,
    @required this.product,
    @required this.heroTag,
    @required this.bloc,
  }) : super(key: key);

  final ScrapModel product;
  final String heroTag;
  final ProductBloc bloc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Theme.of(context).primaryColor,
        onTap: () {
          bloc.add(SelectScrap(id: product.id));
        },
        child: Material(
          elevation: 14.0,
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).hintColor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8),
                Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.12,
                        width: MediaQuery.of(context).size.width * 0.12,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(product.image),
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 5,
                        child: InkWell(
                          onTap: () {
                            bloc.add(RemoveScrapSelect(idScrap: product.id));
                          },
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ))
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .merge(TextStyle(color: Theme.of(context).accentColor)),
                ),
                Text(
                  bloc.isProvider
                      ? product.collectorPrice + "đ"
                      : product.hostPrice + "đ",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ));
  }
}