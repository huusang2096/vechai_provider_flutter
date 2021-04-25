import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AddressEvent extends Equatable{
  @override
  List<Object> get props => [];

  const AddressEvent();
}

class FetchAddressList extends AddressEvent {}

class DeleteAddress extends AddressEvent {
  final int id;

  DeleteAddress({@required this.id});

  @override
  List<Object> get props => [id];
}

class DeletedAddress extends AddressEvent {
  final int id;

  DeletedAddress({@required this.id});

  @override
  List<Object> get props => [id];
}
