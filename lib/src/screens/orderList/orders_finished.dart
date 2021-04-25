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
import 'package:vecaprovider/src/widgets/OrderHostConfrimListItemWidget.dart';
import 'package:vecaprovider/src/widgets/OrderHostFinishedListItemWidget.dart';
import 'package:vecaprovider/src/widgets/OrderProviderFinishedListItemWidget.dart';

class OrdersFinishedWidget extends StatefulWidget {
  @override
  _OrdersFinishedWidgetState createState() => _OrdersFinishedWidgetState();
  OrdersBloc ordersBloc;

  OrdersFinishedWidget(this.ordersBloc);

  static provider(BuildContext context, OrdersBloc ordersBloc) {
    return OrdersFinishedWidget(ordersBloc);
  }
}

class _OrdersFinishedWidgetState extends State<OrdersFinishedWidget>
    with UIHelper {
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc.add(OrderFinishEvent());
    intUI();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    widget.ordersBloc.add(OrderFinishEvent());
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
    return widget.ordersBloc.ordersSale.length != 0
        ? Container(
            margin: EdgeInsets.fromLTRB(6, 6, 6, 20),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              primary: false,
              itemCount: widget.ordersBloc.ordersSale.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return OrderProviderFinishedListItemWidget(
                  heroTag: widget.ordersBloc.ordersSale[index].id.toString(),
                  order: widget.ordersBloc.ordersSale[index],
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
