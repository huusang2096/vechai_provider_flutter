import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/product.dart';
import 'package:vecaprovider/src/widgets/ProductGridItemWidget.dart';

class ProductsByShopWidget extends StatefulWidget {
  ProductsByShopWidget({Key key}) : super(key: key);

  @override
  _ProductsByShopWidgetState createState() => _ProductsByShopWidgetState();
}

class _ProductsByShopWidgetState extends State<ProductsByShopWidget>
    with UIHelper {
  String layout = 'grid';
  ProductsList _productsList = new ProductsList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.box,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              localizedText(context, 'list_scraps'),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.headline4,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      this.layout = 'grid';
                    });
                  },
                  icon: Icon(
                    Icons.apps,
                    color: this.layout == 'grid'
                        ? Theme.of(context).accentColor
                        : Theme.of(context).focusColor,
                  ),
                )
              ],
            ),
          ),
        ),
        Offstage(
          offstage: this.layout != 'grid',
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: _productsList.list.length,
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  Product product = _productsList.list.elementAt(index);
                  return ProductGridItemWidget(
                    product: product,
                    heroTag: product.name + index.toString(),
                  );
                },
              )),
        ),
      ],
    );
  }
}
