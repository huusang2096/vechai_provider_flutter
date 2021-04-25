import 'dart:io';

import 'package:meta/meta.dart';

@immutable
abstract class UserprofileEvent {

  @override
  List<Object> get props => [];
}

class UpdateUserProfile extends UserprofileEvent{
  final String username;
  final String sex;
  final String dob;

  UpdateUserProfile({@required this.username, @required this.sex, @required this.dob});

  @override
  List<Object> get props => [username, sex, dob];

}

class UpdateUserAvartar extends UserprofileEvent{
  final File imageFile;

  UpdateUserAvartar({@required this.imageFile});

  @override
  List<Object> get props => [imageFile];

}

class FetchOrderList extends UserprofileEvent {}

class LoadData extends UserprofileEvent{}

class LoadSubscriptionUser extends UserprofileEvent{}

class UsernameChange extends UserprofileEvent{
  final String username;

  UsernameChange({@required this.username});

  @override
  List<Object> get props => [username];

}
