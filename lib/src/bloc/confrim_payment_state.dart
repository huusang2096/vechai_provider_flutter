import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/RequestByHostResponse.dart';


class InitialConfrimPaymentState extends BaseState {}

class GetOrderByHostSuccessState  extends BaseState {

  final RequestByHostResponse data;
  GetOrderByHostSuccessState({@required this.data});
}

class ApproveSuccessState  extends BaseState {

  final String message;
  ApproveSuccessState(this.message);
}