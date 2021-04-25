import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';

import 'base_state.dart';

class InitialOrdersHostState extends BaseState {}

class OrderHostSuccessState extends BaseState {
  List<OrderModel> orders;

  OrderHostSuccessState(this.orders);
}

class OrderDataRemoveState extends BaseState {
  String message;

  OrderDataRemoveState(this.message);
}
