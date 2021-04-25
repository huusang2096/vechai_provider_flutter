import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vecaprovider/src/models/AddressResponse.dart';

@immutable
abstract class AddressState extends Equatable{

  const AddressState();

  @override
  List<Object> get props => [];
}

class InitialAddressState extends AddressState {
}

class FetchDataLoading extends AddressState {}

class FetchDataDismiss extends AddressState {}

class LoadedAddress extends AddressState {
  final List<Address> items;

  const LoadedAddress({@required this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'Loaded { items: ${items.length} }';
}

class LoadAddressFailure extends AddressState {
  final String error;

  const LoadAddressFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class DeleteFailure extends AddressState {
  final String error;

  const DeleteFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

