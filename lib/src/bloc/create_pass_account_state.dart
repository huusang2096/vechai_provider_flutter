

import 'package:vecaprovider/src/bloc/base_state.dart';

class InitialCreatePassAccountState extends  BaseState {}

class PassWordValidateError extends BaseState {
  final String newPasswordError;
  final String confrimPasswordError;

   PassWordValidateError(
    this.newPasswordError,
     this.confrimPasswordError);

}

class CreateAccountState extends BaseState {
  final String message;

  CreateAccountState(this.message);
}

