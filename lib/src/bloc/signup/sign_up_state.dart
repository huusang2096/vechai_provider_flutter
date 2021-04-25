import 'package:equatable/equatable.dart';
import 'package:vecaprovider/src/models/AddressResponse.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
  @override
  List<Object> get props => [];
}

class InitialSignUpState extends SignUpState {}

class SignUpValidatorFail extends SignUpState {
  final String nameError;
  final String emailError;

  const SignUpValidatorFail({this.nameError, this.emailError});

  @override
  List<Object> get props => [nameError, emailError];
}

class SignUpLoading extends SignUpState {}
class SignUpSuccess extends SignUpState {}
class SignUpFailed extends SignUpState {
  final String error;
  const SignUpFailed({this.error});
  @override
  List<Object> get props => [error];
}

class LoadedContryList extends SignUpState {
  final List<CountryData> items;

  const LoadedContryList({this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'Loaded { items: ${items.length} }';
}

class LoadedDistrictAddressList extends SignUpState {
  final List<District> items;

  const LoadedDistrictAddressList({ this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'Loaded { items: ${items.length} }';
}

class SelectWards extends SignUpState {
  final Wards items;

  const SelectWards({ this.items});

  @override
  List<Object> get props => [items];
}

class LoadedWardsAddressList extends SignUpState {
  final List<Wards> items;

  const LoadedWardsAddressList({ this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'Loaded { items: ${items.length} }';
}

class LoadedStateAddressList extends SignUpState {
  final List<ProvincesAddress> items;

  const LoadedStateAddressList({ this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'Loaded { items: ${items.length} }';
}
