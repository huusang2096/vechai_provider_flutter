import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vecaprovider/src/bloc/base_event.dart';
import 'package:vecaprovider/src/bloc/base_state.dart';
import 'package:vecaprovider/src/models/AddressRequest.dart';
import 'package:vecaprovider/src/network/Repository.dart';
import 'package:vecaprovider/src/uitls/bloc_helper.dart';
import './bloc.dart';

class PlaceAddressBloc extends Bloc<BaseEvent, BaseState> with BlocHelper, ChangeNotifier {
  @override
  BaseState get initialState => InitialPlaceAddressState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {

    if(event is UploadAddress){
      yield* _uploadAddress(event.addressRequest);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _uploadAddress(AddressRequest addressRequest) async* {
    yield LoadingState(true);
    final response = await Repository.instance.addAddress(addressRequest);
    if (response != null && response.data != null) {
      yield LoadingState(false);
      yield UploadAddressSuccessState(response.message, response.data);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }
}
