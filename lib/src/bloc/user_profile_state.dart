import 'dart:io';

import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/AccountResponse.dart';
import 'package:vecaprovider/src/models/UploadImageResponse.dart';

import 'base_state.dart';

class InitialUserProfileState extends BaseState {}

class GetUserProfile extends BaseState {
  Account account;
  GetUserProfile(this.account);
}

class UploadProfileImageSuccessState extends BaseState {
  UploadImageResponse uploadImageResponse;

  UploadProfileImageSuccessState(this.uploadImageResponse);
}

class UpdateProfileSuccessState extends BaseState {
  AccountResponse accountResponse;

  UpdateProfileSuccessState(this.accountResponse);
}
