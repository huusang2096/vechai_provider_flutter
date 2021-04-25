import 'package:vecaprovider/src/bloc/base_state.dart';

class InitialTransferScanQRcodeState extends BaseState {}

class ChangeIsPauseState extends BaseState {
  final bool isPause;
  ChangeIsPauseState({this.isPause});
}

class ErrorTextState extends BaseState {
  final String errorText;
  ErrorTextState({this.errorText});
}

class PopAndPassDataState extends BaseState {
  final Map map;
  PopAndPassDataState({this.map});
}

class ValidationDataSuccessState extends BaseState {
  final bool isVal;
  ValidationDataSuccessState({this.isVal});
}
