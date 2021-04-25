import 'package:vecaprovider/src/bloc/base_state.dart';

class InitialTransfersState extends BaseState {}

class TransfersTestState extends BaseState {}

class ValidateMoneySuccessState extends BaseState {
  final String value;
  ValidateMoneySuccessState({this.value});
}

class ValidateError extends BaseState {
  final String moneyError;
  ValidateError({this.moneyError});
}

class SendMoneyFailureState extends BaseState {}

class SendMoneySuccessState extends BaseState {}
