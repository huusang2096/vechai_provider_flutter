import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/models/AddressResponse.dart';
import './bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  @override
  AddressState get initialState => InitialAddressState();

  final Repository repository;

  AddressBloc({this.repository});

  @override
  Stream<AddressState> mapEventToState(AddressEvent event,) async* {
    if (event is FetchAddressList) {
      /*try {
        var addressReposne = await repository.getAddressUser();
        if (addressReposne.success) {
          yield LoadedAddress(items: addressReposne.data);
        } else {
          yield LoadAddressFailure(error: addressReposne.message);
        }
      } catch (error) {
        yield LoadAddressFailure(error: error.toString());
      }*/
    }

    if (event is DeleteAddress) {
      final listState = state;
      if (listState is LoadedAddress) {
        final List<Address> updatedItems =
        List<Address>.from(listState.items).map((Address item) {
          return item.id == event.id ? item.copyWith(isDeleting: true) : item;
        }).toList();
        yield LoadedAddress(items: updatedItems);

        /*try {
          var addressReposne = await repository.deleteAddress(id: event.id.toString());
          if (addressReposne.success) {
            yield LoadedAddress(items: addressReposne.data);
          } else {
            yield LoadAddressFailure(error: addressReposne.message);
          }
        } catch (error) {
          yield LoadAddressFailure(error: error.toString());
        }*/
      }
    }
  }
}
