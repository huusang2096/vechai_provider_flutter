import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';

class InitialOrdersState extends BaseState {}

class OrderDataSuccessState extends BaseState {
  List<OrderModel> orders;

  OrderDataSuccessState(this.orders);
}

class OrderHostRemoveState extends BaseState {
  String message;
  OrderHostRemoveState(this.message);
}
