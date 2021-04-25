import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/bloc.dart';
import 'package:vecaprovider/src/common/ui_helper.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';
import 'package:vecaprovider/src/widgets/OrderHostConfrimListItemWidget.dart';

class OrdersHostAcceptWidget extends StatefulWidget {
  OrderHostBloc ordersBloc;

  OrdersHostAcceptWidget(this.ordersBloc);

  static provider(BuildContext context, OrderHostBloc ordersBloc) {
    return OrdersHostAcceptWidget(ordersBloc);
  }

  @override
  _OrdersHostAcceptWidgetState createState() => _OrdersHostAcceptWidgetState();
}

class _OrdersHostAcceptWidgetState extends State<OrdersHostAcceptWidget>
    with UIHelper {
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc.add(OrderHostEvent("pending"));
    intUI();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    widget.ordersBloc.add(OrderHostEvent("pending"));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderHostBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      if (state is OrderHostRemoveState) {
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, state.message),
            buttonText: localizedText(context, 'close'),
            image: Image.asset('img/icon_success.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
      }
    }, child: BlocBuilder<OrderHostBloc, BaseState>(builder: (context, state) {
      return Scaffold(
        body: RefreshIndicator(
            onRefresh: _handleRefresh, child: _buildBody(state)),
      );
    }));
  }

  _buildBody(state) {
    return widget.ordersBloc.ordersPending.length != 0
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              primary: false,
              itemCount: widget.ordersBloc.ordersPending.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return OrderHostConfrimListItemWidget(
                  heroTag: widget.ordersBloc.ordersPending[index].id.toString(),
                  order: widget.ordersBloc.ordersPending[index],
                  bloc: widget.ordersBloc,
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
