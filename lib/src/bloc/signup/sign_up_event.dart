import 'package:equatable/equatable.dart';
import 'package:vecaprovider/src/models/AddressResponse.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object> get props => [];
}

class SignUpEnterName extends SignUpEvent {
  final String name;
  const SignUpEnterName({this.name});
}

class SignUpEnterEmail extends SignUpEvent {
  final String email;
  const SignUpEnterEmail({this.email});
}

class SignUpSubmit extends SignUpEvent {
  const SignUpSubmit();
}

class CountryChange extends SignUpEvent {
  final CountryData country;

  CountryChange({ this.country});

  @override
  List<Object> get props => [country];
}

class StateChange extends SignUpEvent {
  final ProvincesAddress stateAddress;

  StateChange({ this.stateAddress});

  @override
  List<Object> get props => [stateAddress];
}

class DistrictChange extends SignUpEvent {
  final District district;

  DistrictChange({ this.district});

  @override
  List<Object> get props => [district];
}

class WardsChange extends SignUpEvent {
  final Wards wardsAddress;

  WardsChange({ this.wardsAddress});

  @override
  List<Object> get props => [wardsAddress];
}