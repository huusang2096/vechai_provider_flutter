import 'package:flutter/cupertino.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';

class RechargeEvent extends BaseEvent {
  RechargeEvent();
}

class GetContact extends BaseEvent {}

class HasReachedSearch extends BaseEvent {}

class SearchUser extends BaseEvent {
  String keyword;
  SearchUser({this.keyword});
}

class SearchUserFromContact extends BaseEvent {
  String phone;
  SearchUserFromContact({this.phone});
}

class SearchUserInit extends BaseEvent {
  String query;
  bool hasReachedSearch = false;
  SearchUserInit({this.query, this.hasReachedSearch});
}

class HandleSuffixIcon extends BaseEvent {
  final TextEditingController textEditingController;
  HandleSuffixIcon({this.textEditingController});
}

class SearchUserFromDataByQrCode extends BaseEvent {
  dynamic providerID;
  SearchUserFromDataByQrCode({this.providerID});
}
