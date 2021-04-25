import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/bloc/recharge/bloc.dart';
import 'package:vecaprovider/src/models/search_user_response.dart';

class RechargeState extends BaseState {
  RechargeState();
}

class InitialRechargeState extends BaseState {}

class RechargeLoading extends BaseState {}

class Searching extends BaseState {}

class Searched extends BaseState {}

class SearchNotFound extends BaseState {
  final String error;

  SearchNotFound({@required this.error});
}

class GetContactSuccessState extends BaseState {
  List<Contact> listContact;
  PermissionStatus permissionStatus;

  GetContactSuccessState({this.listContact, this.permissionStatus});
}

class TransferChangeHasReachedState extends BaseState {
  bool hasReachedSearch = false;
  TransferChangeHasReachedState({this.hasReachedSearch});
}

class TransferSelectUserSearchUserState extends BaseState {
  SearchUserResponse searchUserResponse;
  String currentSearchContent;
  TransferSelectUserSearchUserState(
      {this.searchUserResponse, this.currentSearchContent});
}

class CannotRecognizePhoneState extends BaseState {}

class SearchUserFromContactSuccess extends BaseState {
  User user;
  SearchUserFromContactSuccess({this.user});
}

class SearchUserFromContactFailure extends BaseState {}

class TransferLoadMoreError extends BaseState {}

class SomethingWentWrong extends BaseState {}

class ChangeIsLoading extends BaseState {
  bool isLoading = false;
  ChangeIsLoading({this.isLoading});
}

class ChangeSuffixIconState extends BaseState {
  bool isChangeSuffixIcon = false;
  ChangeSuffixIconState({this.isChangeSuffixIcon});
}

class HanldleSuffixIconIsFalseState extends BaseState {
  User user;
  HanldleSuffixIconIsFalseState({this.user});
}

class SearchUserFromDataByQrCodeSuccessState extends BaseState {
  User user;
  SearchUserFromDataByQrCodeSuccessState({this.user});
}

class SearchUserFromDataByQrCodeFailureState extends BaseState {}
