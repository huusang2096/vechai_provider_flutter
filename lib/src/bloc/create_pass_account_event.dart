

import 'package:vecaprovider/src/bloc/base_event.dart';

class SendNewPassword extends BaseEvent{
  final newPassword, otp, phonecode, phoneNumber;

  SendNewPassword(this.newPassword, this.otp,this.phonecode, this.phoneNumber);
}

class NewPasswordChange extends BaseEvent{
  final String newPassword;
  NewPasswordChange( this.newPassword);

}


class ConfrimPasswordChange extends BaseEvent{
  final String confrimPassword;

  ConfrimPasswordChange(this.confrimPassword);
}
