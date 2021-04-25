
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:vecaprovider/src/models/user_response.dart';


@immutable
abstract class UserprofileState {}

class InitialUserprofileState extends UserprofileState {
  @override
  List<Object> get props => [];
}

class InitialUpdateUsernameState extends UserprofileState {}

class UpdateUsernameLoading extends UserprofileState {}

class UpdateUsernameDismiss extends UserprofileState {}

class UpdateUsernameFailure extends UserprofileState {
  final String error;

  UpdateUsernameFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'UsernameFailure { error: $error }';
}

class UsernameValidateError extends UserprofileState {
  final String error;

  UsernameValidateError({@required this.error});


  @override
  List<Object> get props => [error];
}

class UsernameSuccess extends UserprofileState {
  final String message;

  UsernameSuccess({@required this.message});


  @override
  List<Object> get props => [message];
}

class LoadOrdersFailure extends UserprofileState {
  final String error;

  LoadOrdersFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class LoadUser extends UserprofileState {
  final User user;

  LoadUser({@required this.user});

  @override
  List<Object> get props => [user];
}

class LoadSkip extends UserprofileState {
  final bool skip;

  LoadSkip({@required this.skip});

  @override
  List<Object> get props => [skip];
}