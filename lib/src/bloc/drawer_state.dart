import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';

import 'base_state.dart';


class InitialDrawerState extends BaseState {}

class UserAccountSuccess extends BaseState {
  Account user;
  UserAccountSuccess(this.user);
}
