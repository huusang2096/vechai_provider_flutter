import 'dart:io';

import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/UploadUser.dart';

import 'base_event.dart';

class GetAccountData extends BaseEvent {
  GetAccountData();
}

class UploadProfileImage extends BaseEvent {
  File image;

  UploadProfileImage(this.image);
}


class UpdateProfile extends BaseEvent {
  UploadUser uploadUser;

  UpdateProfile(this.uploadUser);
}