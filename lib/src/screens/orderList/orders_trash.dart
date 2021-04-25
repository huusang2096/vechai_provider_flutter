import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vecaprovider/config/ui_icons.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/widgets/EmptyOrdersProductsWidget.dart';
import 'package:vecaprovider/src/widgets/OrderTrashtemWidget.dart';

class OrdersTrashWidget extends StatefulWidget  {
  List<OrderModel> ordersList;
  HomeBloc bloc;

  @override
  _OrdersTrashWidgetState createState() => _OrdersTrashWidgetState();

  OrdersTrashWidget({Key key, this.ordersList, this.bloc}) : super(key: key);
}

class _OrdersTrashWidgetState extends State<OrdersTrashWidget>  with UIHelper{
  String layout = 'list';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Offstage(
            offstage: this.layout != 'list' /*|| widget.ordersList.isEmpty*/,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              primary: false,
              itemCount: widget.ordersList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 0);
              },
              itemBuilder: (context, index) {
                return OrderTrashItemWidget(
                  heroTag: 'orders_list',
                  order: widget.ordersList[index],
                  bloc: widget.bloc,
                );
              },
            ),
          ),
          Offstage(
            offstage: true,
            child: EmptyOrdersProductsWidget(),
          )
        ],
      ),
    );
  }
}
