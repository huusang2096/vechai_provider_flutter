import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/RequestPhoneNumberResponse.dart';

import 'base_event.dart';


class SendOTPEvent extends BaseEvent {
  RequestPhoneNumberResponse requestPhoneNumberResponse;

  SendOTPEvent(this.requestPhoneNumberResponse);
}

class SendOTPDoneEvent extends BaseEvent {
  SendOTPDoneEvent();
}