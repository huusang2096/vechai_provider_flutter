import 'package:meta/meta.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/models/login_account_request.dart';


class LoginWithAccount extends BaseEvent{
  LoginAccountRequest loginAccountRequest;
  LoginWithAccount(this.loginAccountRequest);
}

class PasswordChange extends BaseEvent{
  final String password;
  PasswordChange( this.password);

}