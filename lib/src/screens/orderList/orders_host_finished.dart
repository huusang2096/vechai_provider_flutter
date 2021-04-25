import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/widgets/OrderHostConfrimListItemWidget.dart';
import 'package:vecaprovider/src/widgets/OrderHostFinishedListItemWidget.dart';

class OrdersHostFinishedWidget extends StatefulWidget {
  @override
  _OrdersHostFinishedWidgetState createState() =>
      _OrdersHostFinishedWidgetState();

  OrderHostBloc ordersBloc;

  OrdersHostFinishedWidget(this.ordersBloc);

  static provider(BuildContext context, OrderHostBloc ordersBloc) {
    return OrdersHostFinishedWidget(ordersBloc);
  }
}

class _OrdersHostFinishedWidgetState extends State<OrdersHostFinishedWidget>
    with UIHelper {
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc.add(OrderHostEvent("finished"));
    intUI();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    widget.ordersBloc.add(OrderHostEvent("finished"));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderHostBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
    }, child: BlocBuilder<OrderHostBloc, BaseState>(builder: (context, state) {
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
                return OrderHostFinishedListItemWidget(
                  heroTag: widget.ordersBloc.ordersFinish[index].id.toString(),
                  order: widget.ordersBloc.ordersFinish[index],
                );
              },
            ))
        : Container(
            height: 100,
            child: Center(
              child: Text(localizedText(context, 'order_is_empty')),
            ));
  }
}
