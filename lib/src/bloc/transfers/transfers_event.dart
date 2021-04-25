import 'package:flutter/cupertino.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';

class TransfersMoney extends BaseEvent {
  TransfersMoney();
}

class SendMoney extends BaseEvent {
  final TextEditingController controllerMoney;
  final TextEditingController controllerNote;
  final int providerID;
  SendMoney({
    this.controllerMoney,
    this.controllerNote,
    this.providerID,
  });
}

class ValidateMoney extends BaseEvent {
  final String value;
  final User user;
  ValidateMoney({this.value, this.user});
}

class MoneyChange extends BaseEvent {
  String money;
  MoneyChange({this.money});
}

class NoteChange extends BaseEvent {
  String note;
  NoteChange({this.note});
}

class GetUser extends BaseEvent {
  final User user;
  final Account myAccount;
  GetUser({this.user, this.myAccount});
}
