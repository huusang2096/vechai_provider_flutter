import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/widgets/EmptyOrdersProductsWidget.dart';
import 'package:vecaprovider/src/widgets/OrderConfrimListItemWidget.dart';

class OrdersConfirmedsWidget extends StatefulWidget {
  @override
  _OrdersConfirmedsWidgetState createState() => _OrdersConfirmedsWidgetState();

  OrdersBloc ordersBloc;

  OrdersConfirmedsWidget(this.ordersBloc);

  static provider(BuildContext context, OrdersBloc ordersBloc) {
    return OrdersConfirmedsWidget(ordersBloc);
  }
}

class _OrdersConfirmedsWidgetState extends State<OrdersConfirmedsWidget>
    with UIHelper {
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc.add(OrderEvent("finished"));
    intUI();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    widget.ordersBloc.add(OrderEvent("finished"));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
    }, child: BlocBuilder<OrdersBloc, BaseState>(builder: (context, state) {
      return Scaffold(
        body: RefreshIndicator(
            onRefresh: _handleRefresh, child: _buildBody(state)),
      );
    }));
  }

  _buildBody(state) {
    return widget.ordersBloc.ordersFinish.length != 0
        ? Container(
            margin: EdgeInsets.fromLTRB(6, 6, 6, 20),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              primary: false,
              itemCount: widget.ordersBloc.ordersFinish.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return OrderConfrimListItemWidget(
                  heroTag: widget.ordersBloc.ordersFinish[index].id.toString(),
                  order: widget.ordersBloc.ordersFinish[index],
                );
              },
            ),
          )
        : Container(
            height: 100,
            child: Center(
              child: Text(localizedText(context, 'order_is_empty')),
            ));
  }
}
