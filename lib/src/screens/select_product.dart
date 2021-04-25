import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';
import 'package:vecaprovider/src/models/product.dart';
import 'package:vecaprovider/src/widgets/ProductSelectGridItemWidget.dart';
import 'package:intl/intl.dart';

class SelectProductWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectProductWidgetState();
  }

  static provider(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(),
      child: SelectProductWidget(),
    );
  }
}

class _SelectProductWidgetState extends State<SelectProductWidget>
    with UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ScrapModel> _productsList = [];

  ProductBloc _bloc;
  double price = 0;
  final _addPriceController = TextEditingController();

  @override
  void initState() {
    _bloc = BlocProvider.of<ProductBloc>(context);
    _bloc.add(HomeScrap());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;

    _addPriceController.addListener(() {
      _bloc.add(AddWeight(
          weight: double.parse(
              _addPriceController.text.toString().replaceAll(",", "."))));
    });

    return BlocListener<ProductBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      if (state is GetListScrapSuccessState) {
        _productsList = state.scraps;
      }

      if (state is AddScrapSuccessState) {
        price = state.price;
      }

      if (state is SendListScrapSuccessState) {
        Navigator.of(context).pop(state.scrapModel);
      }
    }, child: BlocBuilder<ProductBloc, BaseState>(builder: (context, state) {
      return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(UiIcons.return_icon,
                    color: Theme.of(context).primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: getLinearGradient())),
              elevation: 0,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              title: Text(
                localizedText(context, 'add_scraps'),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
              actions: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        localizedText(context, 'skip'),
                        style: Theme.of(context).textTheme.button.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                      ),
                    ),
                  ),
                )
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        blurRadius: 5,
                        offset: Offset(0, -2)),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ListTile(
                          title: Text(
                            localizedText(context, 'price_scraps'),
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                    color: Theme.of(context).accentColor)),
                          ),
                          subtitle: Text(
                              new NumberFormat("#,##0", "en_US")
                                      .format(price)
                                      .replaceAll(",", ".") +
                                  "đ",
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .merge(TextStyle(
                                      color: Theme.of(context)
                                          .textSelectionColor))),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: InkWell(
                        onTap: () {
                          _bloc.add(SendScrapSelect());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              gradient: getLinearGradient()),
                          width: 160,
                          height: 70,
                          child: Center(
                            child: Text(localizedText(context, 'add'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .merge(
                                      TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              localizedText(context, 'input_weight_scraps'),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: _addPriceController,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.confirmation_number,
                                    size: 25,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(localizedText(context, ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.7)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 1.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 1.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 1.0))),
                            ),
                          ),
                        ],
                      )),
                  Container(height: 10),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: _productsList.length == 0
                          ? _buildShimmer()
                          : GridView.builder(
                              shrinkWrap: true,
                              itemCount: _productsList.length,
                              physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                ScrapModel product =
                                    _productsList.elementAt(index);
                                return ProductSelectGridItemWidget(
                                  product: product,
                                  heroTag: product.name + index.toString(),
                                  bloc: _bloc,
                                );
                              },
                            )),
                ],
              ),
            )),
      );
    }));
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.98),
        primary: true,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          );
        },
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}
