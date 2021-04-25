import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/common/prefs.dart';
import 'package:vecaprovider/src/common/validator.dart';
import 'package:vecaprovider/src/models/login_account_request.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import 'package:vecaprovider/src/uitls/device_helper.dart';
import './bloc.dart';

class LoginAccountBloc  extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialLoginAccountState();

  var newPassword = "";

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is PasswordChange) {
      newPassword = event.password;;
    }

    var validateState = _validateInfor();

    yield LoginWithPasswordValidateError(validateState.error);

    if (event is LoginWithAccount &&
        validateState.error.isEmpty) {
      yield* _loginAccount(event.loginAccountRequest);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _loginAccount(LoginAccountRequest loginAccountRequest) async* {
    yield LoadingState(true);
    loginAccountRequest.accountType = 2;
    loginAccountRequest.platform = await DeviceHelper.instance.getDeviceType();
    final response = await Repository.instance.loginAccount(loginAccountRequest);
    if (response != null && response.data != null) {
      yield LoadingState(false);
      await Prefs.saveToken(response.data.apiToken);
      await Prefs.saveAccount(response.data);
      await Prefs.setSkip(false);
      if(response.data.host == null || response.data.host.length == 0){
        await Prefs.saveProvider(true);
      } else {
        await Prefs.saveProvider(false);
      }
      Repository.instance.reloadHeaders();
      yield LoginAccountSuccess(response.message);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }

  LoginWithPasswordValidateError _validateInfor() {
    var newPasswordError = "";
    if (this.newPassword.isEmpty) {
      newPasswordError = "password_cannot_empty";
    } else if (!Validator.isValidPassword(this.newPassword)) {
      newPasswordError = "pass_format_invalid";
    }
    return LoginWithPasswordValidateError(
        newPasswordError);
  }
}
