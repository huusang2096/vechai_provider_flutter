import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/AddressModel.dart';
import 'package:vecaprovider/src/models/OrderResponse.dart';

class InitialHomeState extends BaseState {}

class OpenAddAddress extends BaseState {}

class HomeState extends BaseState {}

class LoadedAddress extends BaseState {
  final List<AddressModel> items;
  LoadedAddress({@required this.items});
}

class OrderSuccessState extends BaseState {
  List<OrderModel> orders;

  OrderSuccessState(this.orders);
}

class OrderCountSuccessState extends BaseState {
  int count;

  OrderCountSuccessState(this.count);
}

class OrderAcceptSuccessState extends BaseState {
  int count;

  OrderAcceptSuccessState(this.count);
}

class AcceptRequestState extends BaseState {
  AcceptRequestState();
}

class AcceptRequestFailsState extends BaseState {
  String message;
  AcceptRequestFailsState(this.message);
}

class NumberPendingSuccess extends BaseState {
  int number;
  NumberPendingSuccess(this.number);
}

class OpenUpdatePassWord extends BaseState {}
