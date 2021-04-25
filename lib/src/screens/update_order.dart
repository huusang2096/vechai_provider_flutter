import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/const.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/ScrapResponse.dart';
import 'package:vecaprovider/src/widgets/ProductBuyGridItemWidget.dart';
import 'package:intl/intl.dart';

class UdpateOrderWidget extends StatefulWidget {
  @override
  _UdpateOrderWidgetState createState() => _UdpateOrderWidgetState();

  final int idOrder;

  static provider(BuildContext context, int idOrder) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: UdpateOrderWidget(idOrder),
    );
  }

  UdpateOrderWidget(this.idOrder);
}

class _UdpateOrderWidgetState extends State<UdpateOrderWidget>
    with TickerProviderStateMixin, UIHelper {
  final String screenName = "HOME";

  var appColors = [
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(111, 194, 173, 1.0)
  ];
  var cardIndex = 0;
  ScrollController scrollController;
  var currentColor = Color.fromRGBO(231, 129, 109, 1.0);

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;
  List<TextEditingController> tfCodeControllers = List();
  double price = 0;
  ProductBloc _bloc;

  _getProvider() async {
    _bloc.isProvider = await Prefs.isProvider();
    setState(() {});
  }

  _updateScrap() {
    Navigator.of(context)
        .pushNamed(RouteNamed.SELECT_PRODUCT)
        .then((value) => {_addProduct(value)});
  }

  _addProduct(value) {
    if (value != null) {
      price = 0;
      _bloc.productsListSelect.add(value);
      _bloc.productsListSelect.forEach((element) {
        price = price + element.sumPrice;
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    scrollController = new ScrollController();
    _bloc = BlocProvider.of<ProductBloc>(context);
    _getProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      if (state is GetScrapDetailSuccessState) {
        Navigator.of(context).pushNamed(RouteNamed.PRODUCT,
            arguments: state.scrapDetailResponse.data);
      }

      if (state is GetListScrapSuccessState) {}

      if (state is RemovecrapSuccessState) {
        price = 0;
        _bloc.productsListSelect.forEach((element) {
          price = price + element.sumPrice;
        });
      }

      if (state is SendScrapToOrderSuccessState) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/Tabs", (Route<dynamic> route) => false,
            arguments: 2);
        _bloc.productsListSelect = [];
        price = 0;
      }
      if (state is OpenQrcodeSuccessState) {
        Navigator.of(context)
            .pushNamed(RouteNamed.QR_CODE, arguments: state.id);
        _bloc.productsListSelect = [];
        price = 0;
      }
      if (state is CheckSendListSuccess) {
        _showModalBottomSheet(state.listScrapModel);
      }
    }, child: BlocBuilder<ProductBloc, BaseState>(builder: (context, state) {
      return Scaffold(
        appBar: _bloc.isProvider
            ? AppBar(
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
                  localizedText(context, 'create_order'),
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
              )
            : new PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: new Container(
                  color: Colors.white,
                ),
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
                  child: ListTile(
                    title: Text(
                      localizedText(context, 'sum'),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(color: Theme.of(context).accentColor)),
                    ),
                    subtitle: Text(
                        new NumberFormat("#,##0", "en_US")
                                .format(price)
                                .replaceAll(",", ".") +
                            "đ",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3.merge(
                            TextStyle(
                                color: Theme.of(context).textSelectionColor))),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: InkWell(
                    onTap: () {
                      if (_bloc.isProvider) {
                        _bloc
                            .add(SendListScrapToOrder(idOrder: widget.idOrder));
                      } else {
                        _bloc.add(CheckSendListScrapToOrder());
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          gradient: getLinearGradient()),
                      width: 160,
                      height: 70,
                      child: Center(
                        child: Text(localizedText(context, 'finish_censorship'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor),
                                )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: new SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Material(
                  elevation: 14.0,
                  shadowColor: Color(0x802196F3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              localizedText(context, 'censorship'),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              localizedText(
                                  context, 'add_the_weight_of_scrap_types'),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _updateScrap();
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _bloc.productsListSelect == null
                      ? 0
                      : _bloc.productsListSelect.length,
                  physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.98),
                  itemBuilder: (context, index) {
                    ScrapModel product =
                        _bloc.productsListSelect.elementAt(index);
                    return ProductBuyGridItemWidget(
                      product: product,
                      heroTag: product.name + index.toString(),
                      bloc: _bloc,
                    );
                  },
                )),
          ],
        )),
      );
    }));
  }

  void _showModalBottomSheet(List<ScrapModel> listScrapModel) {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext builder) {
          return StatefulBuilder(
            builder: (context, state) {
              return AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.decelerate,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              localizedText(
                                  context, 'Please_select_transaction_method'),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  await Navigator.pushNamed(
                                      context, RouteNamed.CREATE_ORDER_SCRAP,
                                      arguments: {
                                        'listScrapModel': listScrapModel,
                                      }).then((value) {
                                    if (value) {
                                      _bloc.productsListSelect = [];
                                      price = 0;
                                    }
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    gradient: getLinearGradient(),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          localizedText(context, 'censorship'),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .merge(TextStyle(
                                                  color: Colors.white))),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  _bloc.add(SendListScrapToOrder(
                                      idOrder: widget.idOrder));
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: getLinearGradient(),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          localizedText(
                                              context, 'create_orders'),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .merge(TextStyle(
                                                  color: Colors.white))),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          );
        });
  }
}
