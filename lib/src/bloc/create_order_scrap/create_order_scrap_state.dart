import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/RequestByHostResponse.dart';
import 'package:vecaprovider/src/models/create_order_online_response.dart';

class CreateOrderScrapState extends BaseState {}

class GetOrderByHostSuccessState extends BaseState {
  final RequestByHostResponse data;

  GetOrderByHostSuccessState({this.data});
}

class CreateOrderOnlineSuccessState extends BaseState {
  final CreateOrderOnlineResponse response;

  CreateOrderOnlineSuccessState({this.response});
}

class ConfirmCreateOrderSuccessState extends BaseState {
  final bool isCreateOrderSuccess;

  ConfirmCreateOrderSuccessState({this.isCreateOrderSuccess});
}
