import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/common/fir_auth.dart';
import 'package:vecaprovider/src/models/RequestPhoneNumberResponse.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import 'package:vecaprovider/src/uitls/phone_helper.dart';
import './bloc.dart';
import 'base_state.dart';

class OtpBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOtpState();

  PhoneAuth phoneAuth;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  OtpBloc() {
    phoneAuth = PhoneAuth(
        onVerificationCompleted: (_) {},
        onVerificationFailed: (_) {
          add(InternalErrorEvent('phone_verification_failed'));
        },
        onCodeSent: (String verificationId) {
          add(SendOTPDoneEvent());
        },
        onSignFailed: (_) {});
  }


  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if(event is SendOTPEvent){
      yield* _sendOTp(event.requestPhoneNumberResponse);
    }

    if(event is SendOTPDoneEvent){
      yield SendOTPSuccessState("OTP has been sent");
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _sendOTp(RequestPhoneNumberResponse requestPhoneNumberResponse) async* {
    final phoneModel = await PhoneHelper.parsePhone(requestPhoneNumberResponse.phoneNumber,requestPhoneNumberResponse.iSOCode);
    if (phoneModel == null) {
      yield ErrorState('invalid_phone_number');
      return;
    }
    phoneAuth.verifyPhoneNumber(phoneModel.e164);
  }
}